//
//  wordBookCell.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 22.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

protocol savedAudioCellDelegate: class{
    func playButtonTapped(cell: wordBookCell, Button: UIButton)
}

final class wordBookCell: UITableViewCell {
    
    weak var delegate: savedAudioCellDelegate?
    
    @IBOutlet weak var word: UILabel!{
        didSet{
            word.font  = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var audioButtonOutlet: UIButton!
    
    
    @IBAction func Tapped(_ sender: UIButton) {
        self.delegate?.playButtonTapped(cell: self, Button: audioButtonOutlet)
        
    }
    
}
