//
//  HomeViewController.swift
//  LinePerLine
//
//  Created by Jose Cantillo on 10/6/21.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
