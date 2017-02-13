//
//  Item.swift
//  Reasons
//
//  Created by Daniel Pan on 11/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Foundation


class Item {
    var id: Int
    var idDisplay: Int {
        get{
            return id + 1
        }
    }
    var question: String
    var tip: String?
    var answer: String
    var reason: String
    var isPassed: Bool = false
    var attmptedAnswers = [String]()
    
    init?(_ data: [String:Object]) throws{
        guard let id = data["id"] as? Int else {
            throw Error(code: (104,"JSON structure misses field: id"))
        }
        self.id = id
        
        
        
        guard let quest = data ["question"] as? String else {
            throw Error(code: (104,"JSON structure misses field: Question for ID(\(id))"))
        }
        self.question = quest
        
        guard let an = data ["answer"] as? String else {
            throw Error(code: (104,"JSON structure misses field: Answer for ID(\(id))"))
        }
        self.answer = an
        
        self.tip = data["tip"] as? String
        
        guard let reason = data ["reason"] as? String else {
            throw Error(code: (104,"JSON structure misses field: Reason for ID(\(id))"))
        }
        self.reason = reason
    }
    
}
