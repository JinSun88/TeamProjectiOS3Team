//
//  MapViewFlowLayout.swift
//  MangoPractice
//
//  Created by jinsunkim on 05/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit

class MapViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard
            let collectionView = self.collectionView
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let attributes = self.layoutAttributesForElements(in: collectionView.bounds)!
        
        let centerX = collectionView.bounds.width / 2
        
        let proposedCenterX = proposedContentOffset.x + centerX
        
        let closet = attributes.sorted { abs($0.center.x - proposedCenterX) < abs($1.center.x - proposedCenterX) }.first!
        
        return CGPoint(x: floor(closet.center.x - centerX), y: proposedContentOffset.y)
        
    }
}
