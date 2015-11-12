//
//  User.swift
//  WeHeartBeer
//
//  Created by Matheus Santos Lopes on 06/11/15.
//  Copyright © 2015 Fernando H M Bastos. All rights reserved.
//

import Foundation
import Parse

class User : PFUser {
    //My variables
    
    @NSManaged var name: String
    @NSManaged var birthDate: NSDate
    @NSManaged var photo: PFFile
    
    
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
            
            
            
        }
    }
    
}


