//
//  ManagerItem.swift
//  Reasons
//
//  Created by Daniel Pan on 11/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Foundation


let managerData = ManagerData()

let invalidId = -1

class ManagerData {
    var io = IOJSON()
//    var currentItemId : Int = invalidId
    var items = [Item]()
    var latestItemId : Int = invalidId
    
    init() {
        // Read static item data
        io.input(file: "items"){ (array,error) in
            if let error = error {
                print("Input Data error: \(error.localizedDescription)")
            }
            else{
                do {
                    for dict in array {
                        if let item = try Item(dict){
                            items.append(item)
                        }
                        
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
        io.input(file: "answers", isBundle: false){ (array, error) in
            if let error = error {
                print("Input Answers error: \(error.localizedDescription)")

            }
            else{
                
                for dict in array {
                    guard let id = dict["id"] as? Int else{
                        print("Attempt Data format error")
                        continue
                    }
                    
                    let pass = dict["pass"] as? Bool
                    
                    guard let attempts = dict["attempts"] as? [String] else{
                        print("Attempt Data format error: (ID = \(id))")
                        continue
                    }
                    self.items[id].attmptedAnswers = attempts
                    
                    self.items[id].isPassed = (pass == nil) ? false: pass!
                }
            }
        }
        
        var r : Item? = nil
        for item in items {
            if !item.isPassed{
                break
            }
            else{
                r = item
            }
        }
        if let r = r {
            latestItemId = r.id
        }
        
    }
    
    func attempt(_ item:Item, with answer:String) -> Bool {
        let id = item.id
        items[id].attmptedAnswers.append(answer)
        if answer == items[id].answer{
            items[id].isPassed = true
            self.latestItemId = id
            return true
        }
        else{
            return false
        }
    }
    

    
    func latest() -> Item? {
        if latestItemId >= 0 && latestItemId < items.count{
            return items[latestItemId]
        }
        else{
            return nil
        }
    }
    
    func next() -> Item {
        if latestItemId >= items.count - 1 {
            return items.last!
        }
        else{
            return items[ latestItemId + 1]
        }
    }
    
    func save() {
        var d = [Dict]()
        
        for item in items {
            var i = Dict()
            let id = item.id
            i["id"] = id
            i["attempts"] = item.attmptedAnswers
            i["pass"] = item.isPassed
            d.append(i)
        }
        
        io.output(d, to: "answers.json"){ (error) in
            if error != nil {
                self.save()
            }
        }
    }
    

}
