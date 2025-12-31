from fastapi import APIRouter, HTTPException, UploadFile, File
from pydantic import BaseModel
from ..models.ai_models import detect_phishing
import logging
import shutil
import os
from sqlalchemy.orm import Session
from ..services.db_service import get_db
from ..models.db_models import User
from firebase_admin import messaging  # Added

router = APIRouter()

class ScanRequest(BaseModel):
    text: str

@router.post("/scan")
async def scan_endpoint(request: ScanRequest, db: Session = Depends(get_db)):
    logging.debug(f"Scan request: text='{request.text[:50]}...'")
    try:
        is_phishing, confidence = detect_phishing(request.text)
        if is_phishing and confidence > 0.7:
            # Send real-time alert; assume user_id=1 mock
            user = db.query(User).filter(User.id == 1).first()
            if user and user.device_token:
                message = messaging.Message(
                    notification=messaging.Notification(
                        title='High Threat Detected!',
                        body=f'Potential phishing with confidence {confidence}. Review immediately.',
                    ),
                    token=user.device_token,
                )
                messaging.send(message)
                logging.info(f"Sent notification to token {user.device_token[:10]}...")
        return {"is_phishing": is_phishing, "confidence": confidence}
    except Exception as e:
        logging.error(f"Scan error: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/scan_file")
async def scan_file(file: UploadFile = File(...), db: Session = Depends(get_db)):
    logging.debug(f"File upload: {file.filename}")
    try:
        temp_path = os.path.join("/tmp", file.filename)
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        with open(temp_path, "r") as f:
            content = f.read()
        is_threat, confidence = detect_phishing(content)
        if is_threat and confidence > 0.7:
            # Send real-time alert
            user = db.query(User).filter(User.id == 1).first()
            if user and user.device_token:
                message = messaging.Message(
                    notification=messaging.Notification(
                        title='File Threat Detected!',
                        body=f'Suspicious content in file with confidence {confidence}.',
                    ),
                    token=user.device_token,
                )
                messaging.send(message)
                logging.info(f"Sent notification for file threat")
        os.remove(temp_path)
        return {"is_threat": is_threat, "confidence": confidence}
    except Exception as e:
        logging.error(f"File scan error: {str(e)}")
        if os.path.exists(temp_path):
            os.remove(temp_path)
        raise HTTPException(status_code=500, detail=str(e))

# New endpoint for token
from pydantic import BaseModel

class TokenRequest(BaseModel):
    user_id: int
    device_token: str

@router.post("/update_token")
def update_token(req: TokenRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == req.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.device_token = req.device_token
    db.commit()
    logging.info(f"Updated device token for user {req.user_id}")
    return {"status": "success"}