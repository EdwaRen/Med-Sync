//
//  SignInVC.swift
//  MedSync4.0
//
//  Created by - on 2017/03/20.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    private let CONTACT_SEGUE = "ContactsSegue";
    
  
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UIImageView!
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
        
    }
    
    @IBAction func signUp(_ sender: Any) {
    }


}





















