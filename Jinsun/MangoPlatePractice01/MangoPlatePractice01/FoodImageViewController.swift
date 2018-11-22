//
//  FoodImageViewController.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 20/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

class FoodImageViewController: UIViewController {
    @IBOutlet weak var colletionView: UICollectionView!
    
    var cellImage = ["bear", "dog", "donkey", "giraffe", "koala", "lion", "pig", "whale"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewLayout = self.colletionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 2)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.itemSize = CGSize(width: self.colletionView.frame.size.width - 20 / 3, height: self.colletionView.frame.size.height / 3)

    }
    

   
}

extension FoodImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodImageCell", for: indexPath) as! FoodImageCollectionViewCell
        let data = cellImage[indexPath.row]
        cell.imageView?.image = UIImage(named: data)
        return cell
    }
    
    
}
