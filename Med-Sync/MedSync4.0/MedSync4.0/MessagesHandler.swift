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
    func messageReceived(senderID: String, senderName: String, text: String);
    func mediaReceived(senderID: String, senderName: String, url: String);
}

class MessagesHandler {
    private static let _instance = MessagesHandler();
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?;
    
    static var Instance: MessagesHandler {
        return _instance;
    }
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text];
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data);
        
    }
    
    func sendMediaMessage(senderID: String, senderName: String, url: String) {
        let data: Dictionary<String, Any> = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.URL: url];
        
        DBProvider.Instance.mediaMessagesRef.childByAutoId().setValue(data);
    }
    
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String) {
        
        if image != nil {
            
            DBProvider.Instance.imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // inform the user that there was a problem uploading his image
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!));
                }
                
            }
            
        } else {
            DBProvider.Instance.videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(video!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // inform the user that uploading the video has failed using delegation
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
                
            }
        }
        
    }
    
    func observeMessages() {
        DBProvider.Instance.messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text);
                        }
                    }
                }
            }
            
        }
    }
    
    func observeMediaMessages() {
        DBProvider.Instance.mediaMessagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let id = data[Constants.SENDER_ID] as? String {
                    if let name = data[Constants.SENDER_NAME] as? String {
                        if let fileURL = data[Constants.URL] as? String {
                            self.delegate?.mediaReceived(senderID: id, senderName: name, url: fileURL);
                        }
                    }
                }
            }
            
        }
    }
    
    
} // class




























