from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import re
import logging

# Load pre-trained models
vectorizer = joblib.load('tfidf_vectorizer.pkl')
model = joblib.load('phishing_model.pkl')

def detect_phishing(text: str) -> tuple[bool, float]:
    logging.debug(f"Detecting phishing in text (snippet): {text[:50]}...")
    text = re.sub(r'http\S+', '', text.lower())
    vec_text = vectorizer.transform([text])
    prediction = model.predict(vec_text)[0]
    probability = model.predict_proba(vec_text)[0][1]
    return prediction == 1, probability