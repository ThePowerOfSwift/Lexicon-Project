//
//  funcString.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 19.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import Foundation

struct funcString {
    
    static func capitalizeFirstLetter(str: String) -> [String] {
        var capitalized:[String] = []
        let a = str.trimmingCharacters(in: .whitespacesAndNewlines) //corrupt oxford texts
        capitalized.append(a.firstUppercased)
        return capitalized
    }
    
}
