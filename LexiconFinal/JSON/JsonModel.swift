//
//  JsonModel.swift
//  Lexicon
//
//  Created by Alexi Kaland on 03.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import Foundation

struct JsonModel:Decodable {
    var results:[Response]
}

struct Response:Decodable {
    var lexicalEntries:[entry]
}

struct entry:Decodable {
    var entries:[sense]?
}

struct audio:Decodable{
    var audioFile:String?
}

struct sense:Decodable{
    var senses:[definition]?
    var pronunciations:[audio]?
}

struct definition:Decodable{
    var definitions:[String]?
    var subsenses:[subDefinitions]?
    var examples:[InUseExamples]?
}

struct subDefinitions:Decodable{
    var definitions:[String]?
}

struct InUseExamples:Decodable {
    var text:String
}

