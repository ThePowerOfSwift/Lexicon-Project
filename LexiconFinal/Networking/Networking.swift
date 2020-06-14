//
//  Networking.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 14.06.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit

//MARK: Networking API/JSON
final class Networking {
    
    // Keeping track of the flow in api Call and updating UI accordingly
    static var apiCallFlow:Bool?
    
    class func apiCall(Word:String, completed: @escaping ([[String]]?) -> ()) {
       
        //Call details
        let appId       =  "Your App ID"  //preferably stored using Obfuscator
        let appKey      =  "Your API Key" //preferably stored using Obfuscator
        let language    =  "en-gb"
        let fields      =  "definitions,examples,pronunciations"
        let word_id     =  Word.lowercased()
        guard let url   =  URL(string: "https://od-api.oxforddictionaries.com:443/api/v2/entries/\(language)/\(word_id)?fields=\(fields)&strictMatch=false") else{return}
        
        var request     =  URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        _ = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let _ = response,
                let data = data,
                let jsonData = try? JSONDecoder().decode(JsonModel.self, from: data) {
                
                Networking.apiCallFlow = true
                var Audio      = [String]()
                var Definition = [String]()
                var Example    = [String]()
                
                //Reaching for nested JSON
                for item1 in jsonData.results{
                    for item2 in item1.lexicalEntries{
                        for item3 in item2.entries!{
                            //audio
                            if let audio = item3.pronunciations{
                                for audioItem in audio{
                                    //mp3 link
                                    if let audio = audioItem.audioFile{
                                        Audio.append(audio)
                                    }
                                }
                            }
                            for item4 in item3.senses!{
                                if item4.definitions != nil{
                                    //Definition
                                    for strings in item4.definitions!{
                                        //Capitalize and corrupt oxford texts
                                        let a = funcString.capitalizeFirstLetter(str: strings)
                                        Definition.append(contentsOf: a)
                                    }
                                }
                                if item4.examples != nil{
                                    //Examples in a sentence
                                    for item5 in item4.examples! {
                                        // Capitalize and corrupt oxford texts
                                        let b = funcString.capitalizeFirstLetter(str: item5.text)
                                        Example.append(contentsOf: b)

                                    }
                                }
                            }
                        }
                    }
                }
                completed([Definition, Example, Audio])
            } else {
                Networking.apiCallFlow = false
                completed(nil)
            }
        }).resume()
    }
}
