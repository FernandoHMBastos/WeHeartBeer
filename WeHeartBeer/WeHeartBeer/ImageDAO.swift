//
//  ImageDAO.swift
//  BeerLove
//
//  Created by Paulo César Morandi Massuci on 25/01/16.
//  Copyright © 2016 Fernando H M Bastos. All rights reserved.
//

import Foundation

class ImageDAO {
     typealias CompletionHaldler = (image:UIImage?,success:Bool) -> Void
    
    static func getImageFromParse(imagePF:PFFile?, ch:CompletionHaldler) {
        if imagePF != nil{
            
            let imageFile = imagePF
            
                imageFile!.getDataInBackgroundWithBlock {
                
                (imageData: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        ch(image: image, success: true)
                        
                    }else{
                        
                        ch(image: nil, success: true)
                    }
                }
            }
            
        }else{
            // error to get image
            ch(image: nil, success: false)
        }
    }
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}