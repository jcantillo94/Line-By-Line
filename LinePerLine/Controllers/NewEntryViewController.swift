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


class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var entry = ""
    var firstDate = ""
    var docId = ""
    var titleText = ""
    
    var selectedEntry : Entry? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextView!
    
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    
    var languages = LanguageManager()
    
    var googleT: () = SwiftGoogleTranslate.shared.start(with: K.googleTranslateAPIKey)
    
    var previousLang = ""
    
    var currentLang = ""
    
    var selectedLanguage : String?
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = entry
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLanguage = languages.languageArray[0].code
        
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
                        
                    }
                    
                    DispatchQueue.main.async {
                        if let range = self.textField.selectedTextRange {
                            
                            print(range)
                            
                            if let text = self.textField.text(in: range) {
                                
                                if text == "" {
                                    self.translate(text: originalText, lang: lang)

                                } else {
                                    self.translate(text: text, lang: lang)
                                }
                            }
                        }
                    }
                    
                    
                } else {
                    print("error: \(String(describing: error))")
                }
            }
        }
    }
    
    func translate (text : String, lang : String) {
        
        if let translateInto = self.selectedLanguage {
            print("inside translate" + translateInto)
            SwiftGoogleTranslate.shared.translate(text, translateInto, lang) { text, error in
                
                if let t = text {
                    
                    DispatchQueue.main.async {
                        self.textField.text += "\n" + t + " "
                    }
                } else {
                    print("error: \(String(describing: error))")
                }
            }
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            let request = VNRecognizeTextRequest { (request, error) in
                
                guard let observations = request.results as? [VNRecognizedTextObservation]
                else { return }
                
                var completedString = ""
                var lang = ""
                
                for observation in observations {
                    
                    let topCandidate: [VNRecognizedText] = observation.topCandidates(1)
                    
                    if let recognizedText: VNRecognizedText = topCandidate.first {

                        completedString += recognizedText.string + " "
                        self.textField.text += recognizedText.string + " "
                        
                        
                        SwiftGoogleTranslate.shared.detect(recognizedText.string) { detections, error in
                            if let detections = detections {
                                for detection in detections {
                                    lang = detection.language
                                }
                            }
                        }
                    }
                    
                }
                SwiftGoogleTranslate.shared.translate(completedString, "es", lang) { text, error in
                    if let t = text {
                        
                        DispatchQueue.main.async {
                            self.textField.text += t + " "
                        }
                    }
                }
                
                self.textField.text += "\n"
            }
            
            request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
            
            try? requestHandler.perform([request])
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadItems() {
        
        if let entryText = selectedEntry?.entryText, let createdDate = selectedEntry?.dateCreated, let documentId = selectedEntry?.docId, let entryTitle = selectedEntry?.title {
            
            entry = entryText
            firstDate = createdDate
            docId = documentId
            titleText = entryTitle
        }
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Save Entry?", message: "If entry is empty, no data will be saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (result : UIAlertAction) -> Void in
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdYYYY HH:mm:ss Z")
            
            if self.firstDate != "" {
                
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
}

//MARK: UIPickerView DataSource & Delegate

extension NewEntryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
}
