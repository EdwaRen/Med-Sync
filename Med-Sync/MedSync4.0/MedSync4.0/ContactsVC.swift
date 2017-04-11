//
//  ContactsVC.swift
//  MedSync4.0
//
//  Created by - on 2017/03/21.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
        } else {
            alertTheUser(title: "Could Not Log Out", message: "We could not log out at the moment. Please try again.");
        }
        
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }


}
