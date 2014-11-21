//
//  SummariesTableViewCell.swift
//  cclt
//
//  Created by Kohei Iwasaki on 11/17/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit

class SummariesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var chocoLabel: UILabel!
    
    var summaryID:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
