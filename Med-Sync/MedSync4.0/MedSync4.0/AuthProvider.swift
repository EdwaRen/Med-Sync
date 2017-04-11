//
//  AuthProvider.swift
//  MedSync4.0
//
//  Created by - on 2017/03/27.
//  Copyright © 2017 Danth. All rights reserved.
//

import Foundation
import FirebaseAuth
typealias LoginHandler = (_ msg:String?) -> Void;

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid email address, please provide another";
    static let WRONG_PASSWORD = "Wrong password, please enter the correct password";
    static let PROBLEM_CONNECTING = "Problem connecting to databse";
    static let USER_NOT_FOUND = "User not found, please register";
    static let EMAIL_ALREADY_IN_USE = "Email already in use, please use another email";
    static let WEAK_PASSWORD = "Password should be at least 6 characters long";
    
}

class AuthProvider {
    private static let _instance = AuthProvider();
    static var Instance: AuthProvider {
        return _instance;
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handlerError(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
            }
            
            
            
        })
    } // login func
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handlerError(err: error as! NSError, loginHandler: loginHandler);
                
            } else {
                if user?.uid != nil {
                    //store user to database
                    
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password);
                    
                    //log in the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler);
                    
                    
                }
            }
            
            
        })
        
    }//signup function
    func isLoggedIn() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            return true;
        }
        return true;
    }
    
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut();
                return true;
            } catch  {
                return false;
            }
        }
        return true;
    }
    
    private func handlerError(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errCode {
            case .errorCodeWrongPassword:
                loginHandler!(LoginErrorCode.WRONG_PASSWORD);
                break;
                
            case .errorCodeInvalidEmail:
                loginHandler!(LoginErrorCode.INVALID_EMAIL);
                break;
                
            case .errorCodeUserNotFound:
                loginHandler!(LoginErrorCode.USER_NOT_FOUND);
                break;
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler!(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
                
            case .errorCodeWeakPassword:
                loginHandler!(LoginErrorCode.WEAK_PASSWORD);
                break;
            default:
                loginHandler!(LoginErrorCode.PROBLEM_CONNECTING);

                break;
                
            }
            
        }
        
    }
    
}
