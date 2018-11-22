//
//  DetailPageViewController.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 20/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    var cellImage = ["bear", "dog", "donkey", "giraffe", "koala", "lion", "pig", "whale"]

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func unwindToDetailPageViewController(_ unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func doPhoneCall(_ sender: Any) {
        let phoneCallURL = URL(string: "tel://010-1234-5678")!
        if UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL)
        }
        
    }
    

}

extension DetailPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailPageCollectionViewCell
        let data = cellImage[indexPath.row]
        cell.imageView?.image = UIImage(named: data)
        
        return cell
    }
    

    
}

extension DetailPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            performSegue(withIdentifier: "ShowFoodImageVIew", sender: self)
        } else { return }
    }
}
