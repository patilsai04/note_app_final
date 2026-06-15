Note App

A Flutter-based Note App with offline storage and synchronization support.

Getting Started

This project uses a Mock Server (JSON Server) for testing API functionality.

1. Install JSON Server
npm install -g json-server
2. Start the Mock Server

Navigate to the mockServer folder and run:

json-server --watch db.json --port 3000
3. Configure the API URL

If you are running the app on a physical mobile device, update the API base URL with your computer's local IP address.

Example:

http://192.168.1.100:3000

Replace 192.168.1.100 with your laptop's actual IP address.

If you are using an Android Emulator, you can use the default emulator IP:

http://10.0.2.2:3000
4. Run the Flutter App
flutter pub get
flutter run
Features
Create, update, and delete notes
Offline data storage
Data synchronization
Mock API integration using JSON Server
State management with Riverpod
Local database using Hive
