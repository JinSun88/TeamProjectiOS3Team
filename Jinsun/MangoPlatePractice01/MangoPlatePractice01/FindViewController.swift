//
//  FindViewController.swift
//  MangoPlatePractice01
//
//  Created by jinsunkim on 16/11/2018.
//  Copyright © 2018 kr.jinsunkim. All rights reserved.
//

import UIKit

struct CellData {
    let restaurantName: String
    let foodImage: String
    let ID: String
}

class FindViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let pageController = UIPageControl()
    private let scrollView = UIScrollView()
    
    private var cellDataItem: [CellData] = [
        CellData(restaurantName: "bear", foodImage: "bear", ID: "1"),
        CellData(restaurantName: "dog", foodImage: "dog", ID: "2"),
        CellData(restaurantName: "donkey", foodImage: "donkey", ID: "1"),
        CellData(restaurantName: "giraffe", foodImage: "giraffe", ID: "2"),
        CellData(restaurantName: "koala", foodImage: "koala", ID: "1"),
        CellData(restaurantName: "lion", foodImage: "lion", ID: "2"),
        CellData(restaurantName: "pig", foodImage: "pig", ID: "1"),
        CellData(restaurantName: "whale", foodImage: "whale", ID: "2")
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewUISetup()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2, height: self.collectionView.frame.size.height / 2)
        
    }
    
    
    private func pageViewUISetup() {
        scrollView.frame = CGRect(x: 0, y: view.frame.height * 0.1, width: view.frame.width, height: view.frame.height * 0.2)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let pageColors: [UIColor] = [.red, .blue, .gray, .magenta]
        for pageColor in pageColors {
            addViewforPageView(with: pageColor)
        }
        
        pageController.frame = CGRect(x: view.frame.midX, y: scrollView.frame.height + 60, width: 0, height: 0)
        view.addSubview(pageController)
    }
    
    private func addViewforPageView(with color: UIColor) {
        let pageFrame = CGRect(origin: CGPoint(x: scrollView.contentSize.width, y: 0), size: scrollView.frame.size)
        let colorView = UIView(frame: pageFrame)
        colorView.backgroundColor = color.withAlphaComponent(0.6)
        scrollView.addSubview(colorView)
        scrollView.contentSize.width += view.frame.width
        pageController.numberOfPages += 1
        
    }
    
    


}

extension FindViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageController.currentPage = page
    }
}

extension FindViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderColor = UIColor.gray.cgColor
//        cell?.layer.borderWidth = 2
//        let cell = cellDataItem[indexPath.row]
//        let viewController1 = storyboard?.instantiateViewController(withIdentifier: "1")
//        let viewController2 = storyboard?.instantiateViewController(withIdentifier: "2")
//
//        if cell.ID == "1" {
//        self.navigationController?.pushViewController(viewController1!, animated: true)
//        } else if cell.ID == "2" {
//        self.navigationController?.pushViewController(viewController2!, animated: true)
//        }
    }
    
    @IBAction func unwindToFindViewController(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
}

extension FindViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FindCollectionViewCell
        let cellData = cellDataItem[indexPath.row]
        cell.textLabel?.text = cellData.restaurantName
        cell.imageView?.image = UIImage(named: cellData.foodImage)
        
        
        
        return cell
    }
}
