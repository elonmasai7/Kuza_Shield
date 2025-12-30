from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from ..services.db_service import get_db
from ..models.db_models import Lesson, UserProgress
import logging

router = APIRouter()

class ProgressRequest(BaseModel):
    lesson_id: str
    score: float

@router.get("/educate")
def get_lessons(sector: str, db: Session = Depends(get_db)):
    logging.debug(f"Fetching lessons for sector: {sector}")
    lessons = db.query(Lesson).filter(Lesson.sector.in_([sector, 'general'])).all()
    if not lessons:
        logging.warning(f"No lessons found for sector: {sector}")
        raise HTTPException(status_code=404, detail="No lessons found")
    return [lesson.to_dict() for lesson in lessons]

@router.post("/progress")
def save_progress(request: ProgressRequest, db: Session = Depends(get_db)):
    logging.debug(f"Saving progress: lesson_id={request.lesson_id}, score={request.score}")
    user_id = 1  # Replace with real user ID from auth
    progress = db.query(UserProgress).filter(UserProgress.user_id == user_id, UserProgress.lesson_id == request.lesson_id).first()
    if progress:
        progress.score = request.score
    else:
        progress = UserProgress(user_id=user_id, lesson_id=request.lesson_id, score=request.score)
        db.add(progress)
    db.commit()
    logging.info(f"Progress saved for user {user_id}")
    return {"status": "success"}