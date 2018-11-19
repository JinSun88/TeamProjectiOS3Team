//
//  PickViewController.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 16/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

struct PickCellData {
    let restaurantName: String
    let foodImage: String
    let ID: String
}

class PickViewController: UIViewController {
    private var cellDataItem: [PickCellData] = [
        PickCellData(restaurantName: "bear", foodImage: "bear", ID: "1"),
        PickCellData(restaurantName: "dog", foodImage: "dog", ID: "2"),
        PickCellData(restaurantName: "donkey", foodImage: "donkey", ID: "1"),
        PickCellData(restaurantName: "giraffe", foodImage: "giraffe", ID: "2"),
        PickCellData(restaurantName: "koala", foodImage: "koala", ID: "1"),
        PickCellData(restaurantName: "lion", foodImage: "lion", ID: "2"),
        PickCellData(restaurantName: "pig", foodImage: "pig", ID: "1"),
        PickCellData(restaurantName: "whale", foodImage: "whale", ID: "2")
        
    ]
    
    @IBOutlet weak var pickCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickCollectionView.dataSource = self
        pickCollectionView.delegate = self
        
        let collectionViewLayout = self.pickCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.itemSize = CGSize(width: self.pickCollectionView.frame.size.width, height: self.pickCollectionView.frame.size.height / 1.5 )
    }
    


}

extension PickViewController: UICollectionViewDelegate {


    
}

extension PickViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pickCollectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! PickCollectionViewCell
        let cellData = cellDataItem[indexPath.row]
        
        cell.imageVIew?.image = UIImage(named: cellData.foodImage)
        cell.textLabel?.text = cellData.restaurantName
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    
}
