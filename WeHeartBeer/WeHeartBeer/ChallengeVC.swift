//
//  ChallengeVC.swift
//  WeHeartBeer
//
//  Created by Matheus Santos Lopes on 22/10/15.
//  Copyright © 2015 Fernando H M Bastos. All rights reserved.
//

import UIKit

class ChallengeVC: UIViewController {

    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeDescription: UILabel!
    @IBOutlet weak var challengeProfile: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
