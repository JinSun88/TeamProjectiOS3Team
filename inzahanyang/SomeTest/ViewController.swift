import UIKit

final class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let imageItem = [UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang")]
    let items = ["게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피"]
    let priceItem = ["9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원"]

    private let pageControl = UIPageControl()
    private let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    private func setupUI() {
        scrollView.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: 150)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
        let pageColors: [UIColor] = [.red, .blue, .gray, .magenta]
        for pageColor in pageColors {
            addPageToScrollView(with: pageColor)
        }
        
        pageControl.frame = CGRect(x: view.frame.midX, y: scrollView.frame.height + 40, width: 0, height: 0)
        view.addSubview(pageControl)
    }
    
    private func addPageToScrollView(with color: UIColor) {
        let pageFrame = CGRect(origin: CGPoint(x: scrollView.contentSize.width, y: 0), size: scrollView.frame.size)
        let colorView = UIView(frame: pageFrame)
        colorView.backgroundColor = color.withAlphaComponent(0.6)
        scrollView.addSubview(colorView)
        scrollView.contentSize.width += view.frame.width
        pageControl.numberOfPages += 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.cellLabel.text = items[indexPath.item]
        cell.cellImage.image = imageItem[indexPath.item]
        cell.cellSubLabel.text = priceItem[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
    
    @IBAction func unwindToViewController(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}
