//
//  LoginViewController.swift
//  LinePerLine
//
//  Created by Jose Cantillo on 10/6/21.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { AuthResultCallback, Error in
                if let e = Error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
            }
        }
    }
}
