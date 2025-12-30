from fastapi import APIRouter, HTTPException, UploadFile, File
from pydantic import BaseModel
from ..models.ai_models import detect_phishing
import logging
import shutil
import os

router = APIRouter()

class ScanRequest(BaseModel):
    text: str

@router.post("/scan")
async def scan_endpoint(request: ScanRequest):
    logging.debug(f"Scan request: text='{request.text[:50]}...'")
    try:
        is_phishing, confidence = detect_phishing(request.text)
        return {"is_phishing": is_phishing, "confidence": confidence}
    except Exception as e:
        logging.error(f"Scan error: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/scan_file")
async def scan_file(file: UploadFile = File(...)):
    logging.debug(f"File upload: {file.filename}")
    try:
        temp_path = os.path.join("/tmp", file.filename)
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        with open(temp_path, "r") as f:
            content = f.read()
        is_threat, confidence = detect_phishing(content)
        os.remove(temp_path)
        return {"is_threat": is_threat, "confidence": confidence}
    except Exception as e:
        logging.error(f"File scan error: {str(e)}")
        if os.path.exists(temp_path):
            os.remove(temp_path)
        raise HTTPException(status_code=500, detail=str(e))