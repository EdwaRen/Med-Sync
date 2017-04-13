//
//  Contact.swift
//  MedSync4.0
//
//  Created by - on 2017/04/12.
//  Copyright © 2017 Danth. All rights reserved.
//

import Foundation

class Contact {
    
    private var _name = "";
    private var _id = "";
    
    init(id: String, name:String) {
        
        _id = id;
        _name = name;
        
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    var id: String {
        return _id;
    }
    
}





























