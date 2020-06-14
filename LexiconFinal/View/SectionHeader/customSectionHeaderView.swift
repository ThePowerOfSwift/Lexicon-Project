//
//  customSectionHeaderView.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 20.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

class customSectionHeaderView: UITableViewCell {
    
    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!{
        didSet{
            sectionLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet var Backk: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
