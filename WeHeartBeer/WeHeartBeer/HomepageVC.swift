//
//  Homepage.swift
//  WeHeartBeer
//
//  Created by Júlio César Garavelli on 23/10/15.
//  Copyright © 2015 Fernando H M Bastos. All rights reserved.
//

import UIKit

class HomepageVC: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet var challengeLink: UIImageView!
    //@IBOutlet weak var backgroundImageview: UIImageView!
    
    // MARK: - UICollectionViewDataSource
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 3.0/255.0, alpha: 1.0)
        
        let gesture = UITapGestureRecognizer(target: self, action: "challengeLinkClicked")
        
        self.challengeLink.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view.
        
    }
    
    
        
    
    // MARK: - ChallengeLink
    func challengeLinkClicked(){
        performSegueWithIdentifier("challengeSegue", sender: nil)
    }
}


