# 🚐 Trip Tracker App

A Flutter-based application to manage and monitor trips, vehicles, drivers, and expenses.  
It provides a real-time dashboard, trip summaries, and Firebase synchronization for data storage and updates.

---

## ✨ Features

- 📅 **Trip Management** — Add, edit, and view trips with date, driver, vehicle, and cost details.  
- 🚘 **Vehicle Management** — View per-vehicle trip summaries and performance.  
- 👨‍✈️ **Driver Management** — Track trips and balances by driver.  
- 💰 **Expense Tracking** — Auto-calculates trip expenses and remaining balances.  
- 📊 **Dashboard Overview** — Total trips, balances, and expenses with color-coded tiles.  
- 🔥 **Firebase Integration** — Syncs all data in real time using Firestore.  
- 📱 **Responsive UI** — Works across Android, iOS, and desktop.

---

## 🏗️ Project Structure

```lib/
├── business/
│ └── providers/
│ ├── trip_provider.dart
│ ├── vehicle_provider.dart
│ └── driver_provider.dart
├── models/
│ └── trip.dart
├── ui/
│ ├── pages/
│ │ ├── landing_page.dart
│ │ ├── trips_page.dart
│ │ └── trip_form_page.dart
│ └── components/
│ ├── total_summary.dart
│ ├── trip_summary_tile.dart
│ ├── vehicle_summary_list.dart
│ └── dropdowns/
│ ├── vehicle_dropdown.dart
│ └── driver_dropdown.dart
└── main.dart

```


---

## ⚙️ Installation

### 1️⃣ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Firebase project configured (Firestore + Android/iOS setup)

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/<your-username>/trip-tracker.git
cd trip-tracker

nstall Dependencies
flutter pub get
```

### 4️⃣ Configure Firebase

Follow official FlutterFire documentation
 to add:

google-services.json (Android)

GoogleService-Info.plist (iOS)

### 5️⃣ Run the App
flutter run


## 🧠 How It Works

Each trip record is stored in Firestore with fields like:

```{
  "vehicleNumber": "KL 13 AB 1234",
  "driverName": "John",
  "startDate": "2025-10-05T10:00:00",
  "total": 1500,
  "balance": 600
}
```

The app fetches trips for the selected date range and groups them by vehicle.

Summary widgets calculate totals dynamically.

## 🧩 Tech Stack

| **Layer**           | **Technology**                         |
|----------------------|----------------------------------------|
| Frontend             | Flutter                                |
| State Management     | Provider                               |
| Backend              | Firebase Firestore                     |
| Auth (optional)      | Firebase Auth                          |
| Build Tools          | Flutter CLI, Android Studio, VS Code   |


## 🚀 Roadmap

- Add authentication
- Export trip data to Excel/PDF
- Enable live location tracking per trip
- Push notifications for upcoming trips

## 🧑‍💻 Author

Pradeep Panayal 


Built with ❤️ using Flutter & Firebase
