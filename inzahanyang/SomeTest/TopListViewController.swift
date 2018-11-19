//
//  TopListViewController.swift
//  SomeTest
//
//  Created by yang on 12/11/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import UIKit

class TopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var arrayOfCellData: [cellData] = [
//        cellData(image: <#T##UIImage#>, name: <#T##String#>, price: <#T##String#>)
//    ]
//
    
    let imageItem = [UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang")]
    let items = ["게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피"]
    let priceItem = ["9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListCell", for: indexPath) as! TableViewCell
        
        cell.heightAnchor.constraint(equalToConstant: 330).isActive = true
        cell.topListView.image = imageItem[indexPath.item]
        cell.titleLabel.text = items[indexPath.item]
        cell.subLabel.text = priceItem[indexPath.item]
        
        return cell
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
