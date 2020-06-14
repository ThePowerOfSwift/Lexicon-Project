//
//  DefinitionCell.swift
//  Lexicon
//
//  Created by Alexi Kaland on 28.04.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

final class DefinitionCell: UITableViewCell {
    
    
    @IBOutlet weak var MainTextLabel: UILabel!    
    @IBOutlet weak var bookMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
