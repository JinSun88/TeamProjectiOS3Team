//
//  EatDealEndViewController.swift
//  MangoPractice
//
//  Created by yang on 20/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class EatDealEndViewController: UIViewController {
    
    @IBOutlet weak var eatDealView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eatDealView.image = UIImage(named: "ending")

        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
