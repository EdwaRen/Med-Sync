//
//  ContactsVC.swift
//  MedSync4.0
//
//  Created by - on 2017/03/21.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {

    //@IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var myTable: UITableView!
    
    private let CELL_ID  = "Cell";
    private let CHAT_SEGUE = "ChatSegue";

    private var contacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
    }
    
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts;
        
        myTable.reloadData();
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        cell.textLabel?.text = contacts[indexPath.row].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil);
        
        
        
    }

    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
        } else {
            alertTheUser(title: "Could Not Log Out", message: "We could not log out at the moment. Please try again.");
        }
    }
    /*
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
        } else {
            alertTheUser(title: "Could Not Log Out", message: "We could not log out at the moment. Please try again.");
        }
        
    }
    */
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }


}
