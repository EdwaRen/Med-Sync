//
//  MessagesHandler.swift
//  MedSync4.0
//
//  Created by - on 2017/04/18.
//  Copyright © 2017 Danth. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    func messageReceived(senderID: String, senderName: String,  text: String);
}

class MessagesHandler {
    
    private static let _instance = MessagesHandler();
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?;
    
    static var Instance: MessagesHandler {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME:senderName, Constants.TEXT: text];
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data);
        
    }
    
    func observeMessages() {
        DBProvider.Instance.messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String{
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName,  text: text);
                        }
                    }
                    /*
                    if let text = data[Constants.TEXT] as? String{
                        self.delegate?.messageReceived(senderID: senderID, text: text);
                    }
                    */
                }
            }
            
            
        }
    }
    
    
} //class






















