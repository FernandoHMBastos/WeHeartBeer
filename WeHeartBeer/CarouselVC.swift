//
//  CarouselVC.swift
//  BeerLove
//
//  Created by Júlio César Garavelli on 05/01/16.
//  Copyright © 2016 Fernando H M Bastos. All rights reserved.
//

import UIKit
import MVCarouselCollectionView
import Foundation


typealias FindObjectsCompletionHandler = (beer:[PFObject]?,success:Bool) -> Void
typealias FindObjectCompletionHandler = (obj:PFObject?,success:Bool) -> Void


class CarouselVC: UIViewController, MVCarouselCollectionViewDelegate {
    
    // Local images
    //let imagePaths = [ "beer1", "beer2", "beer3" ]
    
    var images : [UIImage] = []
    
    
    // Closure to load local images with UIImage.named
    let imageLoader: ((imageView: UIImageView, image : UIImage, completion: (newImage: Bool) -> ()) -> ()) = {
        (imageView: UIImageView, image : UIImage, completion: (newImage: Bool) -> ()) in
        
        imageView.image = image
        completion(newImage: imageView.image != nil)
    }
    
    
    //IBOutlets
    @IBOutlet var collectionView : MVCarouselCollectionView!
    @IBOutlet var pageControl : MVCarouselPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.numberOfPages = images.count
        
    }
    
    // Function CollectionView
    func configureCollectionView(parseLoad:Bool) {
        
        // NOTE: the collectionView IBOutlet class must be declared as MVCarouselCollectionView in Interface Builder, otherwise this will crash.
        collectionView.selectDelegate = self
        if parseLoad {
            collectionView.images = self.images
        }else{
            collectionView.images = self.images
        }
        collectionView.commonImageLoader = self.imageLoader
    
        self.collectionView.reloadData()
        
        
    }
    
    
    // MARK:  MVCarouselCollectionViewDelegate
    func carousel(carousel: MVCarouselCollectionView, didSelectCellAtIndexPath indexPath: NSIndexPath) {
        
        // Do something with cell selection
        // Send indexPath.row as index to use
        //
        //self.performSegueWithIdentifier("FullScreenSegue", sender:indexPath);
    }
    
    func carousel(carousel: MVCarouselCollectionView, didScrollToCellAtIndex cellIndex : NSInteger) {
        
        // Page changed, can use this to update page control
        self.pageControl.currentPage = cellIndex
    }
    
    // MARK: IBActions
    @IBAction func pageControlEventChanged(sender: UIPageControl) {
        
        self.collectionView.setCurrentPageIndex(sender.currentPage, animated: true)
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.queryCarousel()
        
        
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if segue.identifier == "FullScreenSegue" {
    //
    //            let nc = segue.destinationViewController as? UINavigationController
    //            let vc = nc?.viewControllers[0] as? MVFullScreenCarouselViewController
    //
    //            if let vc = vc {
    //                vc.imageLoader = self.imageLoader
    //                vc.imagePaths = self.imagePaths
    //                vc.delegate = self
    //                vc.title = self.parentViewController?.navigationItem.title
    //                if let indexPath = sender as? NSIndexPath {
    //                    vc.initialViewIndex = indexPath.row
    //                }
    //            }
    //        }
    //    }
    
}

//Query Carousel
extension CarouselVC {
    
    // Query return if Featured Beer.
    func queryCarousel () {
        
        let query = PFQuery(className:"Featured")
        query.whereKey("active", equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Sucesso ao recuperar \(objects!.count) pontuação.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        
                        print(object.valueForKey("beer")?.objectId)
                        
                        self.queryBeer((object.valueForKey("beer")?.objectId)!)
                        
                    }
                    //self.configureCollectionView(true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    //Query Beer
    func queryBeer (featuredId: String) {
        
        let query = PFQuery(className:"Beer")
        query.whereKey("objectId", equalTo: featuredId  )
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object)
                        
                        //print(object.valueForKey("Photo"))
                        self.updateData(object)
                    }
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    //Query updateData
    func updateData(beer: PFObject?){
        
        // pegando a foto do parse
        if beer!.objectForKey("Photo") != nil{
            let userImageFile = beer!.objectForKey("Photo") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)!
                        self.images.append(image)
                        print("Imagem Foiiii !!!", self.images)
                        self.configureCollectionView(true)
                        
                    }else{
                        print("sem imagem")
                    }
                }
                
            }
        }else{
            print("erro na imagem")
        }
    }
}
