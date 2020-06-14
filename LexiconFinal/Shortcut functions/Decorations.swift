//
//  Visual.swift
//  Lexicon
//
//  Created by Alexi Kaland on 27.04.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

struct Decorations {
    
    static func styleTextField (_ textfield:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 1, green:1 , blue: 1, alpha: 1).cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleHollowButton(_ button: UIButton){
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleFilledButton(_ button:UIButton) {
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func textsBackgroundShadow(for Text: UILabel){
        Text.layer.shadowOffset =  CGSize(width: 5, height: 5)
        Text.layer.shadowOpacity = 1
        Text.layer.shadowRadius = 2
        let black = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        Text.layer.shadowColor = black.cgColor
    }
    
}

