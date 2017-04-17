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
    //@IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
               // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            performSegue(withIdentifier: self.CONTACT_SEGUE, sender: nil);
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        //performSegue(withIdentifier: CONTACT_SEGUE, sender: nil)
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            //performSegue(withIdentifier: "ContactsSegue", sender: nil);
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";
                    
                    print("LOGIN COMPLETE")
                    self.performSegue(withIdentifier: self.CONTACT_SEGUE, sender: nil);
                    
                }
                
            })
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }

    }
    @IBAction func signUp(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";
                    self.performSegue(withIdentifier: self.CONTACT_SEGUE, sender: nil);
                    
                    print("CREATED USER");
                }
                
            })
            
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
    }
    /*
    @IBAction func login(_ sender: Any) {
        //performSegue(withIdentifier: CONTACT_SEGUE, sender: nil)

        if emailTextField.text != "" && passwordTextField.text != "" {
            //performSegue(withIdentifier: "ContactsSegue", sender: nil);

            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";

                    print("LOGIN COMPLETE")
                    self.performSegue(withIdentifier: self.CONTACT_SEGUE, sender: nil);

                }
                
            })
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {
                    self.emailTextField.text = "";
                    self.passwordTextField.text = "";
                    self.performSegue(withIdentifier: self.CONTACT_SEGUE, sender: nil);
                    
                    print("CREATED USER");
                }
                
            })
            
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
        
        
    }
 */
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}





















