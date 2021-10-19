# Line-By-Line
A iOS journaling app created in Swift that translates entered texts into a target language. Journal entries are stored into a Firebase database for easy access via account creation and authentication.

## Screenshots of Main Functionalities

![image](https://user-images.githubusercontent.com/48455155/137930705-9ed6247d-ee77-4537-9ee3-161e5b6e7a90.png)
![image](https://user-images.githubusercontent.com/48455155/137930823-9d3fc3a1-de92-4ce7-994b-eebe1b540ddc.png)
![image](https://user-images.githubusercontent.com/48455155/137930928-1d3db6a0-a95e-4683-8731-183c1c0b9f27.png)
![image](https://user-images.githubusercontent.com/48455155/137930955-ec5348a2-c8cc-42b0-bd6b-6dafd8136da7.png)
![image](https://user-images.githubusercontent.com/48455155/137930864-c4536d53-8046-4b0c-98a2-ddc00b64cfe0.png)
![image](https://user-images.githubusercontent.com/48455155/137947700-85c16155-13de-45cd-a9ff-0d039d321190.png) 
![image](https://user-images.githubusercontent.com/48455155/137947737-9dd85dc7-c699-4daa-a622-c86464c22e82.png)




## Quick Start

To run this project locally:

- Message or email me directly for my own Google Translation API Key and Firebase GoogleService-Info.plist.
- Within NewEntryViewController.swift, replace line 38's 'with' parameter (K.googleTranslateAPIKey) with the key that you received from me.
- Copy & Paste the GoogleSerive-Info.plist within the 'LinePerLine' project folder directory
- If you wish to run your own Google Translation API key, proceed to https://cloud.google.com/translate/docs/reference/rest/ and follow the instructions within 'Get Started for Free' on the top-right.
- If you wish to run your own Firestore database, get started with https://firebase.google.com/ and simply create a dedicated project for this project.


## Technologies Used
- Firebase/Firestore for account authentication and data storage
- Google Translate API
- Apple Vision Framework for Text recognition within photo images

## What I learned/reinforced
- To acheieve the minimal value product (MVP) of an intended idea 
- using DispatchQueue.main.async in situations where UI updates need to occur on the main thread
- continued practice with using Firestore db methods 
- first time using Firebase account authentication on a personal project
- using MVC design pattern for project structure 
