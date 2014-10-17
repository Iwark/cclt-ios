//
//  SummaryCollectionViewCell.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/16/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
//        
//        if self.shouldBeHidden(layoutAttributes) {
//            layoutAttributes.hidden = true
//        } else if self.selected {
//            layoutAttributes.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
//        }
        
        return layoutAttributes
    }

    
}
