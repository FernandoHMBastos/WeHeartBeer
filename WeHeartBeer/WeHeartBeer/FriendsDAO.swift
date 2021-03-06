//
//  FriendsDAO.swift
//  BeerLove
//
//  Created by Paulo César Morandi Massuci on 20/01/16.
//  Copyright © 2016 Fernando H M Bastos. All rights reserved.
//

import UIKit
import Foundation
import Parse

class FriendsDAO {
  
    
    typealias FindObjectsCompletionHandler = (requests:[PFObject]?, waitingFriends:[PFObject]?, myFriends:[PFObject]? ,success:Bool) -> Void
    
    typealias FindObjsCH = (object:[PFObject]?, success: Bool) -> Void
    typealias FindObjCH = (object:PFObject?, success: Bool) -> Void
    
    typealias CompleteCH =  (success:Bool) -> Void
    
    static func findUser(currentFriend:String, ch:FindObjCH){
        
                let query = PFQuery(className: "_User")
                query.whereKey("faceID", equalTo: currentFriend)
                query.getFirstObjectInBackgroundWithBlock({ (obj: PFObject?, error: NSError?) -> Void in
                    if error == nil{
                        if obj != nil{
                            print(obj)
                            ch(object: obj, success: true)
                            
                        } else {
                            print("erro Step 1")
                            //"error, user not found
                            ch(object: nil, success: false)
                           
                        }
                        
                    }else{
                        print("erroStep 2")
                        //"error to request friend"

                        ch(object: nil, success: false)
                    }
                })
    }



        
            
        
    
    static func friendQuery(user1:PFObject, user2:PFObject,check:Bool,ch:FindObjCH){
        let query = PFQuery(className: "Friends")
        query.whereKey("user1", equalTo:user1)
        query.whereKey("user2", equalTo:user2)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil{
              ch(object: object, success: true)
            }else{
                if check{
                    self.friendQuery(user2, user2: user1, check: false, ch: { (object, success) -> Void in
                        if success{
                           ch(object: object, success: true)
                        }else{
                          ch(object: nil, success: false)
                        }
                    })
                }else{
                    ch(object: nil, success: false)
                }
            }
        }
    }
//    print("a")
    static func friendsQuery(user:PFObject, ch:FindObjsCH){
        print("entrouuuu ")
       
        let query = PFQuery(className: "Friends")
        query.whereKey("user1", equalTo:user)
        query.whereKey("accepted", equalTo:true)
        query.findObjectsInBackgroundWithBlock { (friend1, error) -> Void in
            if error == nil {
                var friend = friend1
                self.friendsQuery2(user, ch: { (object, success) -> Void in
                   if success{
                        if object != nil{
                            for obj in object!{
                                friend?.append(obj)
                            }
                            print("friend")
                            print(friend)
                            ch(object: friend, success: true)
                    }
                   }else{
                        print("tem coisa errada")
                        ch(object: friend, success: true)
                    }
                })
            }else{
                self.friendsQuery2(user, ch: { (object, success) -> Void in
                    print("object")
                    print(object)
                    ch(object: object, success: success)
                })
            
            }
        }
    }
  private  static func friendsQuery2(user:PFObject, ch:FindObjsCH){
        let query = PFQuery(className: "Friends")
        query.whereKey("user2", equalTo:user)
        query.whereKey("accepted", equalTo:true)
        query.findObjectsInBackgroundWithBlock { (friend2, error) -> Void in
            if error == nil {
                print("friend2")
                print(friend2)
                ch(object: friend2, success: true)
              
                
            }else{
                print("friend23")
                print(error)
                print(friend2)
                ch(object: nil, success: false )
              
            }
            
        }
        
        
    }
    
    
    
    
    static func friendReques(friend:PFObject?, currentRequest: PFObject?, ch: CompleteCH){
        if currentRequest == nil {
            let user = User.currentUser()
            let friendList = PFObject(className:"Friends")
            friendList["user1"] = user
            friendList["name1"] = user?.name
            friendList["id1"] = user?.faceID
            friendList["accepted"] = false
            friendList["user2"] = friend!
            friendList["name2"] = friend!.objectForKey("name")
            friendList["id2"] = friend?.valueForKey("faceID")
            friendList.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    //print("PEDIDO deu Certo")
                    ch(success: true)
                    // The object has been saved.
                } else {
                    ch(success: false)
                    //print("PEDIDO DEU ERRADO")
                    // There was a problem, check error.description
                }
            }
            
        }
        
    }
    
    
    
    static func queryFriends(completionHandler:FindObjectsCompletionHandler) {
        print("entrou no dao")
        var requests:[PFObject]? = [PFObject]()
        var myFriends: [PFObject]? = [PFObject]()
        var waitingFriends:[PFObject]? = [PFObject]()
        let user = User.currentUser()
        self.queryId1((user?.faceID)!) { (object, success) -> Void in
            if success{
                for obj in object!{
                    let id = obj.objectForKey("id1") as! String
                    let accepted = obj.objectForKey("accepted")as! Bool
                    if accepted{
                        myFriends?.append(obj)
                    }else{
                        if id == user?.faceID{
                            waitingFriends?.append(obj)
                        }else{
                            requests?.append(obj)
                            
                        }
                    }
                }
                completionHandler(requests: requests, waitingFriends: waitingFriends, myFriends: myFriends, success: true)
            }else{
                completionHandler(requests: nil, waitingFriends: nil, myFriends: nil, success:
                    false)
                
            }
            
        }
    }
    
    
    private  static func queryId1(userFBID:String,ch:FindObjsCH){
        let query = PFQuery(className: "Friends")
        query.whereKey("id1", equalTo: userFBID)
        query.findObjectsInBackgroundWithBlock {
            (var objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) f1 scores.")
                self.queryId2(userFBID, ch: { (object, success) -> Void in
                    if success == true {
                        for obj in object!{
                            objects?.append(obj)
                        }
                        ch(object: objects, success: true)
                        //success
                    }else{
                        ch(object: nil, success: false)
                    }
                })
            }else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                ch(object: nil, success: false)
            }//fim checagem de erro
        }//fim da query
        
        
    }
    
    
    private static func queryId2(userFBID:String, ch:FindObjsCH){
        
        let query = PFQuery(className: "Friends")
        query.whereKey("id2", equalTo: userFBID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) f1 scores.")
                ch(object: objects!, success: true)
            }else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                ch(object:nil, success: false)
            }//fim checagem de erro
        }
        
    }
    
    
    
    
    
    
    
}