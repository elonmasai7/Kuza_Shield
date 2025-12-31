# KuzaShield - AI-Powered Cyber Security App for Kenya

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)](https://flutter.dev/)
[![FastAPI Version](https://img.shields.io/badge/FastAPI-0.95%2B-green?logo=fastapi)](https://fastapi.tiangolo.com/)
[![Python Version](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)](https://www.python.org/)
[![GitHub Issues](https://img.shields.io/github/issues/elonmasai7/Kuza_Shield)](https://github.com/elonmasai7/Kuza_Shield/issues)
[![GitHub Stars](https://img.shields.io/github/stars/elonmasai7/Kuza_Shield)](https://github.com/elonmasai7/Kuza_Shield/stargazers)

KuzaShield ("Kuza" meaning "protect" in Swahili) is an innovative, mobile-first cyber security application tailored for Kenya's dynamic digital landscape. Dubbed the "Silicon Savannah Guardian," it equips users with AI-driven tools to combat rising cyber threats like phishing, ransomware, and scams. Leveraging Kenya's high mobile penetration (over 110%), the app focuses on accessible, real-time protection for individuals, SMEs, and SACCOs.

Built on insights from Kenya's cyber landscape (e.g., 842 million threats in Q3 2025 per CA reports), KuzaShield promotes digital resilience amid the growth of M-Pesa, e-government, and fintech.

## Key Features

- **AI-Powered Threat Detection**: Scan SMS, emails, or text for phishing/social engineering using NLP models (TF-IDF + Logistic Regression via scikit-learn). Real-time results with confidence scores.
- **File Scanning**: Upload and analyze TXT/PDF files for hidden threats or malicious links.
- **Personalized Cyber Education**: Sector-specific modules (e.g., finance, agriculture) with interactive quizzes, progress tracking, and certifications. Offline support via Hive.
- **Advanced Threat Analytics**: Visualize trends with charts (fl_chart): confidence levels, threat counts, average risks, and predictive risk assessments (low/medium/high).
- **Real-Time Threat Alerts**: Push notifications via Firebase Cloud Messaging for high-confidence threats, even in background mode.
- **Secure Premium Upgrades**: Freemium model with payments via Airtel Money (USSD prompts, polling for confirmation). Integrates Tala for quick loans to afford premium features.
- **Cross-Sector Compliance**: Aligns with Kenya's Data Protection Act and CA standards; supports rural-urban divide with mobile-first design.
- **Offline Capabilities**: Cached education and basic scans; syncs when online.

## Screenshots

| Home Dashboard | Threat Scanner | Education Module | Analytics |
|---------------|---------------|------------------|-----------|
| ![Home](screenshots/home.png) | ![Scanner](screenshots/scanner.png) | ![Education](screenshots/education.png) | ![Analytics](screenshots/analytics.png) |


## Technology Stack

### Frontend (Flutter/Dart)
- UI/State: Material Design, Provider.
- Storage: Hive for offline data.
- Charts: fl_chart for analytics.
- Notifications: Firebase Messaging.
- Integrations: http for API, file_picker for uploads, url_launcher for deep links.

### Backend (Python/FastAPI)
- API: FastAPI with CORS.
- DB: SQLAlchemy + PostgreSQL.
- AI/ML: scikit-learn for phishing detection.
- Payments: Requests for Airtel API.
- Notifications: Firebase Admin SDK.
- Logging: Built-in logging to file/console.

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Python 3.10+
- PostgreSQL
- Airtel Developer Credentials
- Firebase Project (for FCM)
- Pre-trained ML models (included)

### Installation

#### Frontend
1. Clone repo: `git clone https://github.com/elonmasai7/Kuza_Shield.git && cd frontend`
2. Install deps: `flutter pub get`
3. Generate Hive: `flutter pub run build_runner build`
4. Add Firebase configs (Android/iOS).
5. Run: `flutter run`

#### Backend
1. Navigate: `cd backend`
2. Install deps: `pip install -r requirements.txt`
3. Configure .env (DB URL, Airtel keys, Firebase JSON path).
4. Run: `uvicorn app:app --reload`

### Database Setup
- Create PostgreSQL DB.
- Tables auto-created on start.
- Seed sample data: Add lessons/users via SQL or admin script.

### ML Model Training (Optional)
- Use scikit-learn to train on phishing datasets.
- Save as .pkl files.

## Configuration

- **API Base URL**: Update in `api_service.dart` for production.
- **Airtel Sandbox**: Test payments; switch to live in .env.
- **Firebase**: Set up FCM topic subscriptions for broader alerts.
- **Customization**: Extend sectors in education DB.

## Deployment

- **Frontend**: Build APK/iPA: `flutter build apk --release` or `flutter build ios`.
- **Backend**: Deploy to Heroku/AWS; use Gunicorn for prod: `gunicorn -w 4 -k uvicorn.workers.UvicornWorker app:app`.
- **CI/CD**: Use GitHub Actions for builds/tests.
- **Monitoring**: Integrate Sentry for errors, Prometheus for metrics.

## Contributing

We welcome PRs! Follow:
1. Fork repo.
2. Branch: `git checkout -b feat/new-feature`.
3. Commit: `git commit -m "Add new feature"`.
4. Push & PR.

Focus areas: AI accuracy for Swahili scams, more integrations (e.g., M-Pesa), UI localization.

## Roadmap

- Q1 2026: Multi-language support (Swahili).
- Q2 2026: Community threat reporting.
- Q3 2026: Enterprise version for SACCOs.
- Ongoing: Model updates via Kenyan threat data.

## License

MIT - see [LICENSE](LICENSE).

## Contact

- GitHub: [elonmasai7](https://github.com/elonmasai7)
- Email: elonmasai@tutamail.com
- Issues: [Open Ticket](https://github.com/elonmasai7/Kuza_Shield/issues)

Stay protected in the digital savannah! 🇰🇪 
