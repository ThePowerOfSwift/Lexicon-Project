//
//  SearchWordValidity.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 23.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit


struct ValidationService {
    
    static func ValidateWord(SearchField: UITextField, WarningLabel: UILabel) -> Bool {
        
        //support words like "set-up"
        let customSet: CharacterSet = ["-", " "]
        let finalSet = CharacterSet.letters.union(customSet)
        
        //to prevent crash when copy pasting non-english characters
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        //Checking searched word
        if SearchField.text == ""{
            Animations.warningAnimation(Label: WarningLabel, Text: "Please insert the word")
            return false
        }else if SearchField.text!.contains(" ") && finalSet.isSuperset(of: CharacterSet(charactersIn: SearchField.text!)) == false {
            Animations.warningAnimation(Label: WarningLabel, Text: "No spaces and letters only!")
            return false
        }else if SearchField.text!.contains(" ") {
            Animations.warningAnimation(Label: WarningLabel, Text: "No spaces!")
            return false
        }else if finalSet.isSuperset(of: CharacterSet(charactersIn: SearchField.text!)) == false {
            Animations.warningAnimation(Label: WarningLabel, Text: "Please enter only letters")
            return false
        }else if SearchField.text!.rangeOfCharacter(from: characterset.inverted) != nil{
            Animations.warningAnimation(Label: WarningLabel, Text: "Please enter alphabetical letters")
            return false
        }else{
            return true
        }
    }
}
