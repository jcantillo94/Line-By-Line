# Line-By-Line
A iOS journaling app created in Swift that translates entered texts into a target language. Journal entries are stored into a Firebase database for easy access via account creation and authentication.

## Purpose

- Create and save journal entries that are tied to account authentication so that saved entries can persist outside the initial device that they were saved on.

1. When typing text, select the text that you'd want to translate then select the target language the text will translate into. If you don't select any text, all text within the entry's text field will be translated into the target langauge.
2. You can also utilize photos stored in your camera roll; The top-right camera functionality in the 'New Entry' function will attempt to transcribe the text within the images onto the entry's text field.
3. When finished with the entry, select the back button on the top-left to save and return back to the Home screen.

## Current To-Do's (10/18/21)

- Delete function for unwanted, saved entries on the 'Previous Entries' table view
- Better UI design: Color, Font
- Account Settings functionality (Discuss this with me if interested on working on this one)
- Better text recognition for images (text recognition is not reliable if the text/handwriting is unorthodox)
- Limited languages to select

## Screenshots of Main Functionalities

![image](https://user-images.githubusercontent.com/48455155/137930705-9ed6247d-ee77-4537-9ee3-161e5b6e7a90.png)
![image](https://user-images.githubusercontent.com/48455155/137930823-9d3fc3a1-de92-4ce7-994b-eebe1b540ddc.png)
![image](https://user-images.githubusercontent.com/48455155/137930928-1d3db6a0-a95e-4683-8731-183c1c0b9f27.png)
![image](https://user-images.githubusercontent.com/48455155/137930955-ec5348a2-c8cc-42b0-bd6b-6dafd8136da7.png)
![image](https://user-images.githubusercontent.com/48455155/137947700-85c16155-13de-45cd-a9ff-0d039d321190.png) 
![image](https://user-images.githubusercontent.com/48455155/137947737-9dd85dc7-c699-4daa-a622-c86464c22e82.png)
![image](https://user-images.githubusercontent.com/48455155/137930864-c4536d53-8046-4b0c-98a2-ddc00b64cfe0.png)

## Quick Start

To run this project locally:

- Message or email me directly for my own Google Translation API Key and Firebase GoogleService-Info.plist.
- Within NewEntryViewController.swift, replace line 38's 'with' parameter (K.googleTranslateAPIKey) with the key that you received from me.
- Copy & Paste the GoogleSerive-Info.plist within the 'LinePerLine' project folder directory
- If you wish to run your own Google Translation API key, proceed to https://cloud.google.com/translate/docs/reference/rest/ and follow the instructions within 'Get Started for Free' on the top-right.
- If you wish to run your own Firestore database, get started with https://firebase.google.com/ and simply create a dedicated project for this project.
- Once you run the project in Xcode, Register an email and password so that you can proceed to the functionalities.


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
