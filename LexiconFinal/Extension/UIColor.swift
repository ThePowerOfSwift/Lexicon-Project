//
//  UIColor.swift
//  Lexicon
//
//  Created by Alexi Kaland on 27.04.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue   = CGFloat(red)   / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue  = CGFloat(blue)  / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}



