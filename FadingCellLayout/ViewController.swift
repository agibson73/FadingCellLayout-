//
//  ViewController.swift
//  FadingCellLayout
//
//  Created by Alex Gibson on 12/17/16.
//  Copyright © 2016 Alex Gibson. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout = FadingZoomLayout(scrollDirection: .vertical)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plainCell", for: indexPath) as! PlainCollectionViewCell
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }


}

