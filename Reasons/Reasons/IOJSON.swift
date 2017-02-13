//
//  JSONReader.swift
//  Reasons
//
//  Created by Daniel Pan on 11/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Foundation


func delay(_ sec: Double, completion: @escaping ()->()) {
    let when = DispatchTime.now() + sec
    DispatchQueue.main.asyncAfter(deadline: when){
        completion()
    }
}


typealias Object = Any
typealias Dict = [String: Object]
typealias HandlerInput = ([Dict], Error?) ->()
typealias HandlerOutput = (Error?)->()

class IOJSON {
    func input(file name:String, isBundle:Bool = true,handlerDict:HandlerInput) {
        var path : URL?
        if isBundle {
            path = Bundle.main.url(forResource: name, withExtension: "json")
            guard path != nil else {
                handlerDict([Dict](),Error(code: (101,"file not exist") ))
                return
            }
        }
        else{
            path = getDocumentsDirectory().appendingPathComponent("\(name).json")
        }
        
        
        if let path = path {
            do {
                let data = try Data(contentsOf:path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                var arr: [Dict] = [Dict]()
                
                if let dict = json as? Dict{
                    arr = [dict]
                }
                else if let a = json as? [Dict]{
                    arr = a
                }
                else{
                    handlerDict([Dict](),Error(code: (102,"Invalid input structure") ))
                }
                
                handlerDict(arr,nil)
            }catch{
                handlerDict([Dict](), error)
            }
        }
        else{
            handlerDict([Dict](),Error(code: (101,"file not exist") ))
        }
        
        
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func output(_ data: [Dict], to file: String, handler:HandlerOutput) {
        do{
            let json = try JSONSerialization.data(withJSONObject: data, options: [])
            
            
            let r = String(data:json, encoding:String.Encoding.utf8)
            let url = getDocumentsDirectory().appendingPathComponent(file)
            try r?.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            handler(error)
        }
        
        
    }
    
    
}
