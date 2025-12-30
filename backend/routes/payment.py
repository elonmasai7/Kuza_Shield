from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
import requests
import json
import os
import logging
from ..services.db_service import get_db
from ..models.db_models import User, Transaction

router = APIRouter()

class PaymentRequest(BaseModel):
    user_id: int
    amount: str
    phone_number: str

class StatusRequest(BaseModel):
    user_id: int
    transaction_id: str

def get_airtel_access_token():
    client_id = os.getenv("AIRTEL_CLIENT_ID")
    client_secret = os.getenv("AIRTEL_CLIENT_SECRET")
    url = f"{os.getenv('AIRTEL_BASE_URL')}/auth/oauth2/token"
    headers = {'Content-Type': 'application/json', 'Accept': '*/*'}
    data = {"client_id": client_id, "client_secret": client_secret, "grant_type": "client_credentials"}
    resp = requests.post(url, headers=headers, data=json.dumps(data))
    if resp.statusCode != 200:
        raise HTTPException(status_code=500, detail="Failed to get Airtel token")
    return resp.json()["access_token"]

@router.post("/initiate_airtel")
def initiate_airtel(req: PaymentRequest, db: Session = Depends(get_db)):
    logging.debug(f"Initiating Airtel payment for user {req.user_id}")
    try:
        token = get_airtel_access_token()
        transaction_id = str(int(datetime.datetime.now().timestamp() * 1000))
        reference = f"KS-{req.user_id}-{transaction_id}"

        headers = {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'X-Country': 'KE',
            'X-Currency': 'KES',
            'Authorization': f'Bearer {token}'
        }
        payload = {
            "reference": reference,
            "subscriber": {
                "country": "KE",
                "currency": "KES",
                "msisdn": int(req.phone_number)
            },
            "transaction": {
                "amount": int(req.amount),
                "country": "KE",
                "currency": "KES",
                "id": transaction_id
            }
        }
        url = f"{os.getenv('AIRTEL_BASE_URL')}/merchant/v1/payments/"
        resp = requests.post(url, headers=headers, data=json.dumps(payload))
        if resp.statusCode != 200:
            raise HTTPException(status_code=500, detail="Airtel payment initiation failed")
        transaction = Transaction(user_id=req.user_id, transaction_id=transaction_id, method='airtel', status='pending')
        db.add(transaction)
        db.commit()
        return {"transactionId": transaction_id, "data": resp.json()}
    except Exception as e:
        logging.error(f"Airtel payment error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/check_airtel_status")
def check_airtel_status(req: StatusRequest, db: Session = Depends(get_db)):
    logging.debug(f"Checking Airtel status for tx {req.transaction_id}")
    try:
        token = get_airtel_access_token()
        headers = {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'X-Country': 'KE',
            'X-Currency': 'KES',
            'Authorization': f'Bearer {token}'
        }
        url = f"{os.getenv('AIRTEL_BASE_URL')}/standard/v1/payments/{req.transaction_id}"
        resp = requests.get(url, headers=headers)
        if resp.statusCode != 200:
            raise HTTPException(status_code=500, detail="Status check failed")
        data = resp.json()["data"]["transaction"]
        status = data["status"]
        success = status == "TS"
        failed = status == "TF"
        transaction = db.query(Transaction).filter(Transaction.transaction_id == req.transaction_id).first()
        if transaction:
            transaction.status = 'success' if success else 'failed' if failed else 'pending'
            db.commit()
        if success:
            user = db.query(User).filter(User.id == req.user_id).first()
            if user:
                user.subscription_status = 'premium'
                db.commit()
        return {"success": success, "failed": failed, "status": status}
    except Exception as e:
        logging.error(f"Status check error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))