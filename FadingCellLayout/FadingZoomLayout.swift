//  FadingZoomLayout.swift
//  LayoutTest
//
//  Created by Alex Gibson on does it matter.
//  Copyright © 2016 AG. All rights reserved.
//

import UIKit

class FadingZoomLayout: UICollectionViewFlowLayout,UICollectionViewDelegateFlowLayout {
    
    //should be 0<scale<1
    private let scaleFactor: CGFloat = 0.7
    private let cellHeight : CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(scrollDirection:UICollectionViewScrollDirection) {
        super.init()
        self.scrollDirection = scrollDirection
     
    }
    
    override func prepare() {
        setupLayout()
        super.prepare()
    }
    
    func setupLayout() {
        self.itemSize = CGSize(width: self.collectionView!.bounds.size.width,height:cellHeight)
        self.minimumLineSpacing = 0
        // this should never happen but i don't trust Swift :)
        if collectionView != nil{
            self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
            self.sectionInset = UIEdgeInsetsMake(self.collectionView!.frame.size.height/2 - cellHeight/2, 0, self.collectionView!.frame.size.height/2 - cellHeight/2, 0)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func scrollDirectionOver() -> UICollectionViewScrollDirection {
        return UICollectionViewScrollDirection.vertical
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) as [UICollectionViewLayoutAttributes]!
        if let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes]{
            var visibleRect = CGRect()
            visibleRect.origin = collectionView!.contentOffset
            visibleRect.size = collectionView!.bounds.size
            for attrs in attributes {
                if attrs.frame.intersects(rect) {
                    let distance = visibleRect.midY - attrs.center.y
                    let normalizedDistance = abs(distance) / (visibleRect.height * scaleFactor)
                    let zoom = 1 - normalizedDistance
                    attrs.zIndex = 1
                    attrs.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attrs.alpha = zoom
                }
            }
            return attributes
        }else{
            return nil
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
        attributes.alpha = 0
        attributes.transform3D = CATransform3DMakeScale(0, 0, 1.0)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)! as UICollectionViewLayoutAttributes
        attributes.alpha = 0
        attributes.transform3D = CATransform3DMakeScale(0, 0, 1.0)
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.y  + (self.collectionView!.frame.height / 2.0)
        let targetRect = CGRect(x:proposedContentOffset.x, y: proposedContentOffset.y, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
      
        let array = super.layoutAttributesForElements(in: targetRect) as [UICollectionViewLayoutAttributes]!
        
        for layoutAttributes in array! {
            let distanceFromCenter = layoutAttributes.center.y - horizontalCenter
            if abs(distanceFromCenter) <= abs(offsetAdjustment) {
                offsetAdjustment = distanceFromCenter
            }
        }
        return CGPoint(x:proposedContentOffset.x, y:proposedContentOffset.y  + offsetAdjustment )
    }
}
