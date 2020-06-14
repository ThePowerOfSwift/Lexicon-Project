//
//  String.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 19.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import Foundation


extension StringProtocol {
    //capitalizing first character in [String]
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
