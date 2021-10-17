//
//  RegisterViewController.swift
//  LinePerLine
//
//  Created by Jose Cantillo on 10/6/21.
//

import UIKit
import Foundation
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { AuthResultCallback, error in
                if let e = error {
                    print(e)
                } else {
                    //Navigate to Home
                    self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                }
            }
        }
    }
}
