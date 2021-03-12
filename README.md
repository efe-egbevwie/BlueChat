# Bluechat

Bluechat is an instant messaging cross-platform app built with flutter and Google Firebase.
Firebase cloud Firestore hosts the app data in a document database.
Firebase auth is used to provide user authentication.
Firebase Storage is used to host file storage for the app files like pictures etc.

# Libraries/Packages used
## Firebase Core
The Firebase core plugin connects the app to a firebase project.

## Firebase auth
This flutter package enables the app to use the authentication methods provided by the Firebase Authentication API such as email and password sign in.

## Cloud Firestore
This flutter package enables usage of the NoSQL, live-updated database provided by firebase.

## Firebase Storage
Flutter plugin for Firebase Cloud Storage, a powerful, simple, and cost-effective object storage service for Android and iOS.

## Provider
Used to manage state across widgets in the app. Essentially a wrapper around the flutter inheritedWidget to make it easier to use.

## Flutter svg
An SVG rendering and widget library for Flutter, which allows painting and displaying Scalable Vector Graphics 1.1 files

## Flushbar
A package for showing highly customizable snackbars.

## Image Picker
Flutter plugin for selecting images from the Android and iOS image library, and taking new pictures with the camera.

# Core App logic
The app uses streams to listen to firebase collections and documents and updates the UI immediately there is a new document written to the database.
The new document writes are messages one user sends to the other and each user builds a message widget containing the message content when the stream emits new data.
The widgets are built with the use of a streambuilder widget which accepts a stream and builds the message widget.

# Pre-Requisites
The app can be run on both android and ios platforms.
On android, a minimum sdk level 21 (android 5.0) is requires to run the app.
On ios, a minimum of ios 8 is requires.

# Running the project
To run the project, clone the repository and run flutter pub get to get the dependencies.
You also have to register the app to your own firebase project, if you want to have access to and run it with your own database.

# Pending features
A non-exhaustive list of pending features include:
- Adding a time stamp to the message widget
- Improving the UI of the authentication screens
- Improving the UI of the chatscreens
- Adding a settings screen
- Adding an imageview for the avatars 
- Enable users to navigate to their profile pae from the app drawer  
- Enable users to add others with their phone numbers
- Proper handling of potential errors from authentication
- Adding file sharing support

# Contribution
To make a contribution, just make a pull-request.

# License
The MIT License (MIT)
Copyright © 2021 Efe Egbevwie

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.











