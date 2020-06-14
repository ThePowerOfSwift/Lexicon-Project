//
//  audioCell.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 13.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

protocol AudioCellDelegate: class{
    func playButtonTapped(Button: UIButton)
}


final class audioCell: UITableViewCell {
    
    weak var delegate:AudioCellDelegate?
    
    @IBAction func playButtonTap(_ sender: UIButton) {
        delegate?.playButtonTapped(Button: playButton)
    }
    
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.tintColor = UIColor.white
        }
    }
    
    
    @IBOutlet weak var playText: UILabel!{
        didSet{
            playText.text = "Tap to play"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
