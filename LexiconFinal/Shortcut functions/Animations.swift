//
//  Animations.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 19.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import Foundation
import UIKit

struct Animations {
    
    static func warningAnimation(Label: UILabel, Text: String){
        DispatchQueue.main.async {
            Label.alpha         = 1
            Label.text          = Text
            let moveUpTransform = CGAffineTransform.init(translationX: -500, y: 0)
            Label.transform     = moveUpTransform
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                Label.transform = .identity
            }, completion: nil)
        }
    }  
    
}
