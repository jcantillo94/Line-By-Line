//
//  EntryViewController.swift
//  LinePerLine
//
//  Created by Jose Cantillo on 10/6/21.
//

import Foundation
import UIKit
import Firebase

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var entries : [Entry] = []
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.allowsSelection = true
        
        self.title = "Previous Entries"
        
        loadEntries()
    }
    
    func loadEntries() {
        db.collection("entries")
            .order(by: "dateCreated", descending: true)
            .addSnapshotListener { querySnapshot, error in
                
                self.entries = []
                if let e = error {
                    print("There was an issue retrieveing data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let entryText = data["entryText"] as? String, let dateCreated = data["dateCreated"] as? String, let docId = doc.documentID as? String {
                            
                                let entryTitle = entryText.components(separatedBy: "\n")

                                let newEntry = Entry(title: entryTitle[0], dateCreated: dateCreated, entryText: entryText, docId: docId)
                                
                                self.entries.append(newEntry)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.entries.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let entry = entries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let entryDateParsed = entry.dateCreated.components(separatedBy: ",")

        cell.textLabel?.text = entryDateParsed[0] + "," + entryDateParsed[1] + " - " + entry.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows")
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow")
        performSegue(withIdentifier: "goToEntry", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewEntryViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedEntry = entries[indexPath.row]
        }
    }
}
