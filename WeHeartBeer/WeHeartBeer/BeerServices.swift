//
//  BreweryServices.swift
//  WeHeartBeer
//
//  Created by Fernando H M Bastos on 11/9/15.
//  Copyright © 2015 Fernando H M Bastos. All rights reserved.
//

import Foundation
import Parse
import UIKit



class BeerServices {
    
    typealias BooleanCompletionHandler = (success:Bool) -> Void
    typealias FindObjectsCompletionHandler = (beer:[Beer]?,success:Bool) -> Void
    typealias CreateCompletionHaldler = (success:Bool) -> Void
    typealias FindBeerCompletionHandler = (beer:[Beer]?,success:Bool) -> Void
    
    
    
    static func saveNewBeer(name:String!, abv:String!, brewery:Brewery!, style:String!, ibu:String!,  completionHandler: CreateCompletionHaldler){
        
    BeerDAO.createBeer(name, abv: abv, style: style, ibu: ibu, brewery: brewery) { (success) -> Void in
        if success {
            
            completionHandler(success:true)

        } else {
            completionHandler(success:false)

        }
        }
    }
    
    //find beer using name and completionHandler
    static func findBeerName(beer:String,completionHandler:FindBeerCompletionHandler){
        
        // call BeerDAO
        
        
        BeerDAO.findBeer(beer) { (beerCH, success) -> Void in
            
            if success {
                
                completionHandler(beer: beerCH,success: true)
                
            } else {
                // alertar o usuario
                print("erooo serivice")
                completionHandler(beer: nil,success: false)
                
            }
  
        }
        
    }
    
    
    static func findBeerFromBrewery(breweryID: String!, completionHandler:FindBeerCompletionHandler){
        BeerDAO.findBeerfromBrewery(breweryID) { (beer, success) -> Void in
            
            if success{
                completionHandler(beer: beer, success: true)
                
            }else{
                // alertar o usuario
                print("erooo serivice")
                completionHandler(beer: nil,success: false)
                
            }
        }

    }
    
}

