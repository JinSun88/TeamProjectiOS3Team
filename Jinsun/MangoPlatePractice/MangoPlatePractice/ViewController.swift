//
//
//  MangoPlatePractice
//
//  Created by jinsunkim on 08/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let name = ["bear", "dog", "donkey", "giraffe", "koala", "lion", "pig", "whale"]
    
    let foodImage: [UIImage] = [
        UIImage(named: "bear")!, UIImage(named: "dog")!, UIImage(named: "donkey")!, UIImage(named: "giraffe")!, UIImage(named: "koala")!, UIImage(named: "lion")!, UIImage(named: "pig")!, UIImage(named: "whale")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2, height: self.collectionView.frame.size.height / 3)
        
        
    }
    


}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.nameLabel?.text = name[indexPath.item]
        cell.foodImageView?.image = foodImage[indexPath.item]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let cellName = name[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: cellName)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.6
        self.navigationController?.pushViewController(viewController!, animated: true)

    }
    
}


