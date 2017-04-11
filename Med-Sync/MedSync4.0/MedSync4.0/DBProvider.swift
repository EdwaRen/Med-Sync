//
//  DBProvider.swift
//  MedSync4.0
//
//  Created by - on 2017/04/10.
//  Copyright © 2017 Danth. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider {
    
    private static let _instance = DBProvider();
    private init() {}
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
    var contactsRef : FIRDatabaseReference {
        return dbRef.child(Constants.MESSAGES);
    }
    
    var messagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://myawesomechat-c4734.appspot.com");
    }
    
    var imageStorageRef: FIRStorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE);
    }
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE);
    }
    
    func saveUser(withID: String, email: String, password: String) {
        let data:Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        contactsRef.child(withID).setValue(data);
    }
    
}






























