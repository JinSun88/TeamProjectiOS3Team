//
//  TapBarViewController.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 16/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

class TapBarViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.backgroundColor = .lightGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


}
