//
//  CategoriesTableViewCell.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/14/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: DefaultImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var categoryID: Int?
    var featureID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
