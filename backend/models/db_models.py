from sqlalchemy import Column, Integer, String, Float, ForeignKey, JSON
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    phone = Column(String)
    sector = Column(String)
    subscription_status = Column(String, default='free')

class Lesson(Base):
    __tablename__ = 'lessons'
    id = Column(String, primary_key=True)
    title = Column(String)
    content = Column(String)
    sector = Column(String)
    quiz_questions = Column(JSON)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'content': self.content,
            'sector': self.sector,
            'quiz_questions': self.quiz_questions
        }

class UserProgress(Base):
    __tablename__ = 'user_progress'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    lesson_id = Column(String, ForeignKey('lessons.id'))
    score = Column(Float)

class Transaction(Base):
    __tablename__ = 'transactions'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    transaction_id = Column(String)
    method = Column(String)
    status = Column(String, default='pending')