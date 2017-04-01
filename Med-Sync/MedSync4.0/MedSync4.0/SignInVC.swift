//
//  SignInVC.swift
//  MedSync4.0
//
//  Created by - on 2017/03/20.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {

    private let CONTACT_SEGUE = "ContactsSegue";
    
  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: CONTACT_SEGUE, sender: nil)

        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";

                    print("LOGIN COMPLETE")
                    //performSegue(withIdentifier: "ContactsSegue", sender: nil);

                }
                
            })
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }


}





















