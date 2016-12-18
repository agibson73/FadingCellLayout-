//
//  PlainCollectionViewCell.swift
//  FadingCellLayout
//
//  Created by Alex Gibson on 12/17/16.
//  Copyright © 2016 Alex Gibson. All rights reserved.
//

import UIKit

class PlainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    
}
