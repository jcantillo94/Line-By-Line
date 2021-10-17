//
//  NewEntryViewController.swift
//  LinePerLine
//
//  Created by Jose Cantillo on 10/6/21.
//

import Foundation
import UIKit
import Firebase
import Vision
import SwiftGoogleTranslate


class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var languages = LanguageManager()
    
    var previousLang = ""
    
    var selectedLanguage : String?
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.languageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages.languageArray[row].name
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedLanguage = languages.languageArray[row].code
    }
    
    
    let db = Firestore.firestore()
    
    var currentLang = ""
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var googleT: () = SwiftGoogleTranslate.shared.start(with: "AIzaSyCLQbNaYbJ_CpSPxUHsFN5Lb5QEfJccMsg")
    
    @IBAction func translateButton(_ sender: UIButton) {
        print("translatebutton")
        
        if let originalText = textField.text{
            print(originalText)
            
            var lang = " "
            
            SwiftGoogleTranslate.shared.detect(originalText) { detections, error in
                if let detections = detections {
                    for detection in detections {
                      lang = detection.language
                        print(lang)
    //                                  let reliable = detection.isReliable
    //                                  let confidence = detection.confidence
    //                                  print("---")
                    
            }
                    self.translate(text: originalText, lang: lang)
                } else {
                    print("error: \(String(describing: error))")
                }
    }
            
            print("before translate:" + lang)
            
//            SwiftGoogleTranslate.shared.translate(originalText, "es", lang) { text, error in
//
//                print(text)
//                if let t = text {
//
//                    DispatchQueue.main.async {
//                        self.textField.text += t + " "
//                    }
//                } else {
//                    print("error: \(String(describing: error))")
//                }
            }
        }

    
    
    func translate (text : String, lang : String) {
        
        if self.selectedLanguage == self.previousLang  {
            
            let seperators = CharacterSet(charactersIn: "\n.")
            let sentences = self.textField.text.components(separatedBy: seperators)
            
            for sentence in sentences {
            
            }
            
        } else {
            
        }
        
        if let translateInto = selectedLanguage {
            SwiftGoogleTranslate.shared.translate(text, translateInto, lang) { text, error in

        
            
            print(text)
            
                if let t = text {

                    DispatchQueue.main.async {
                        self.textField.text += "\n \n" + t + " "
                        self.textField.text += "\n"
                    }
                } else {
                    print("error: \(String(describing: error))")
                }
        }
        }
    
    }
    
    
    @IBOutlet weak var textField: UITextView!
    
    var entry = ""
    var firstDate = ""
    var docId = ""
    var titleText = ""
    
    var selectedEntry : Entry? {
        didSet {
            loadItems()
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("imagePickerController")
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            print(ciImage)

            let request = VNRecognizeTextRequest { (request, error) in
                
                print(request)

                guard let observations = request.results as? [VNRecognizedTextObservation]
                else { return }
                
                var completedString = ""
                var lang = ""

                for observation in observations {
                    print("observations")

                    let topCandidate: [VNRecognizedText] = observation.topCandidates(1)

                    if let recognizedText: VNRecognizedText = topCandidate.first {
                        print(recognizedText.string)
                        completedString += recognizedText.string + " "
                        self.textField.text += recognizedText.string + " "
//                        self.textField.text +=
                        
                        SwiftGoogleTranslate.shared.detect(recognizedText.string) { detections, error in
                            if let detections = detections {
                                for detection in detections {
                                  lang = detection.language
//                                  let reliable = detection.isReliable
//                                  let confidence = detection.confidence
//                                  print("---")
                                
                        }
                    }
                }
                    }
                    
                                    }
                print(lang)
                SwiftGoogleTranslate.shared.translate(completedString, "es", lang) { text, error in
                    if let t = text {
                        
                        DispatchQueue.main.async {
                            print(completedString)
                            self.textField.text += t + " "
                        }
                    }
                }

                self.textField.text += "\n"
//            detect(image: ciImage)
        }
            
            print(request)
            
            request.recognitionLevel = VNRequestTextRecognitionLevel.accurate

            try? requestHandler.perform([request])
            // non-realtime asynchronous but accurate text recognition
//            request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//
//            try? requestHandler.perform([request])
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    }
    
    
    
    func loadItems() {
        
        if let entryText = selectedEntry?.entryText, let createdDate = selectedEntry?.dateCreated, let documentId = selectedEntry?.docId, let entryTitle = selectedEntry?.title {
            //            textField.text = entry
            entry = entryText
            firstDate = createdDate
            docId = documentId
            titleText = entryTitle
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = entry
//        navigationController?.title = firstDate
//        self.tabBarController?.navigationItem.title = "My Title"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        languagePicker.dataSource = self
        languagePicker.delegate = self
        
        let newBackButton = UIBarButtonItem(title: "Home", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        if titleText != "" {
            self.title = titleText
        } else {
            self.title = "New Entry"
        }
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (result : UIAlertAction) -> Void in
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdYYYY HH:mm:ss Z")
            
            if self.firstDate != "" {
//                if let entryText = self.textField.text {self.db.collection("entries").addDocument(data: ["dateCreated" : self.firstDate,  "entryText" : entryText]) { error in
//                    if let e = error {
//                        print("There was an issue saving data to firestore, \(e)")
//
//                    } else {
//                        print("Successfully saved data.")
//                    }
//                }
//                }
               
                let entryRef = self.db.collection("entries").document(self.docId)
                
                if let entryText = self.textField.text {
                
                    entryRef.updateData([
                        "entryText": entryText,
                        "title": self.titleText
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
                
                
                
            } else if self.textField.text == "" {
                
                // Nothing gets saved, nothing is performed
            }
            
            else {
                
                
                if let entryText = self.textField.text {self.db.collection("entries").addDocument(data: ["dateCreated" : dateFormatter.string(from: Date.init()),  "entryText" : entryText, "title" : entryText.components(separatedBy: "\n")[0]]) { error in
                    if let e = error {
                  
                      print("There was an issue saving data to firestore, \(e)")
                        
                    } else {
                        print("Successfully saved data.")
                    }
                }
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //
    //        if self.isMovingFromParent {
    //            // Your code...
    //            print("isMovingFromParent")
    //
    //            let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)
    //
    //            let okAction = UIAlertAction(title: "Ok", style: .default) { okAction in
    //
    //                }
    //
    //            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    //
    //            alertController.addAction(cancelAction)
    //            alertController.addAction(okAction)
    //            self.present(alertController, animated: true, completion: nil)
    //        }
    
    
    
    
}
