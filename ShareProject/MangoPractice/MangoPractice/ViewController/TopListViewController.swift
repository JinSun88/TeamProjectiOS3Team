//
//  TopListViewController.swift
//  MangoPractice
//
//  Created by Bernard Hur on 19/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import SafariServices
import SnapKit

class TopListViewController: UITabBarController, SFSafariViewControllerDelegate {

    let SafariScrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()

   openSafari()
    }
   
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
//        view.addSubview(SafariScrollView)
//        SafariScrollView.snp.makeConstraints { (m) in
//            m.top.bottom.leading.trailing.equalTo(view)
//        }

        
        

        
    }
    
    func openSafari() {
    guard let url = URL(string: "https://www.mangoplate.com/eat_deals") else { return }
    let safariController = SFSafariViewController(url: url)
    self.present(safariController, animated: true, completion: nil)
    safariController.delegate = self
    }
}
