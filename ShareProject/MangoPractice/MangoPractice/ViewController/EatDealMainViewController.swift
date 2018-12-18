//
//  ViewController.swift
//  final
//
//  Created by yang on 03/12/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import UIKit

class EatDealMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nextViewImage: UIImage?
    var urls = [String]()
    var result : [Result] = []
    var images : [Eatdealimage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getdata()
    }
    
    func getdata() {
        
        let url = URL(string: "https://fastplate.xyz/api/eatdeals/list/")!
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let jsonObject =  try! JSONDecoder().decode(EatDealData.self, from: data)
            self.result = jsonObject.results
            
            for i in jsonObject.results.makeIterator() {
                self.images.append(contentsOf: i.eatdealimages)
            }
            
            for i in self.images.makeIterator() {
                self.urls.append(i.image)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
    
    @IBAction func unwindToEatDealMainView(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! EatDealMainCell
        
        cell.mainTitlelabel.text = result[indexPath.row].dealName
        cell.subTitleLabel.text = result[indexPath.row].subName
        cell.beforePriceLabel.attributedText = "￦\(result[indexPath.row].basePrice.withComma)".strikeThrough()
        cell.priceLabel.text = "￦\(result[indexPath.row].discountPrice.withComma)"
        cell.saleLabel.text = "   \(result[indexPath.row].discountRate)%"
        
        guard let url = URL(string: urls[indexPath.row]) else { return cell }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                cell.mainImage.image = image
            }
        }
        task.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = URL(string: urls[indexPath.row]) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.nextViewImage = image

        }
        task.resume()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eatSelectedViewController = storyboard.instantiateViewController(withIdentifier: "EatSelectedViewController") as! EatSelectedViewController
        
        DispatchQueue.main.async {
            
            eatSelectedViewController.mainImages = self.nextViewImage!
            eatSelectedViewController.dealName = self.result[indexPath.row].dealName
            eatSelectedViewController.subName = self.result[indexPath.row].subName
            eatSelectedViewController.startDate = self.result[indexPath.row].startDate
            eatSelectedViewController.endDate = self.result[indexPath.row].endDate
            eatSelectedViewController.basePrice = self.result[indexPath.row].basePrice
            eatSelectedViewController.discountRate = self.result[indexPath.row].discountRate
            eatSelectedViewController.discountPrice = self.result[indexPath.row].discountPrice
            eatSelectedViewController.introduceRes = self.result[indexPath.row].introduceRes
            eatSelectedViewController.introduceMenu = self.result[indexPath.row].introduceMenu
            eatSelectedViewController.caution = self.result[indexPath.row].caution
            eatSelectedViewController.howToUse = self.result[indexPath.row].howToUse
            eatSelectedViewController.refund = self.result[indexPath.row].refund
            eatSelectedViewController.inquiry = self.result[indexPath.row].inquiry
        }
        
        present(eatSelectedViewController, animated: true, completion: nil)
    }
}
