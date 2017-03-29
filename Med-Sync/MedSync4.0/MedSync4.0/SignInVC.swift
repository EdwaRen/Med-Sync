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
        //performSegue(withIdentifier: CONTACT_SEGUE, sender: nil)
        if emailTextField.text != "" && passwordTextField.text != "" {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error1) in
                        if error1 != nil {
                            
                        } else{
                            if user?.uid != nil {
                                
                            }
                        }
                    })
                } else {
                    //performSegue(withIdentifier: CONTACT_SEGUE, sender: nil)
                    print("We are logged in");
                }
            })
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
    }


}





















