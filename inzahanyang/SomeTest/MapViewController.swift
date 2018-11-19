//
//  MapViewController.swift
//  SomeTest
//
//  Created by yang on 11/11/2018.
//  Copyright © 2018 inzahan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

final class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let imageItem = [UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang"), UIImage(named: "bok"), UIImage(named: "er"), UIImage(named: "gong"), UIImage(named: "hae"), UIImage(named: "jja"), UIImage(named: "jjam"), UIImage(named: "k"), UIImage(named: "ma"), UIImage(named: "oh"), UIImage(named: "sa"), UIImage(named: "tang"), UIImage(named: "yang")]
    let items = ["게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피", "게살볶음밥", "어향가지", "공부탕면", "해물누룽지탕", "짜장면", "짬뽕", "크림새우", "마파두부", "오향장육", "사천탕수육", "탕수육",  "양장피"]
    let priceItem = ["9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원", "9,500원", "32,000원", "9,500원", "30,000원", "7,500원", "9,500원", "28,000원", "10,000원", "33,000원", "25,000원", "23,000원", "30,000원"]
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        checkAuthorizationStatus()
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
    }
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            startUpdatingLocation()
        }
    }
    
    private func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedAlways || status == .authorizedWhenInUse, CLLocationManager.locationServicesEnabled() else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func mornitoringHeading(_ sender: Any) {
        guard CLLocationManager.headingAvailable() else { return }
        locationManager.startUpdatingLocation()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as! BottomCollectionViewCell
        
        cell.bottomImageCell.image = imageItem[indexPath.item]
        cell.bottomCellLabel.text = items[indexPath.item]
        cell.bottomCellSubLabel.text = priceItem[indexPath.item]
        
        return cell
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        let coordinate = current.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        addAnnotation(location: current)
        
    }
    func addAnnotation(location: CLLocation) {
        let annotation = Annotation(title: "Mylocation", coordinate: location.coordinate)
        mapView.addAnnotation(annotation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.trueHeading)
    }
}
