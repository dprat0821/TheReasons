//
//  Error.swift
//  Reasons
//
//  Created by Daniel Pan on 11/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Foundation


let domainNameDefault = "Default"

struct ErrorCode {
    
    
    static func FormatterMaskSourceNA(path:String) ->(Int,String){ return (301,"File '\(path)' does not exist.")}
    static func FormatterMaskSourceFailedToRead(path:String)->(Int,String) {return (302,"Failed to Read FormatterMask rule file '\(path)'")}
    static let ForrmtterMaskSourceNotXML = (303,"The format of FormatterMask is not XML. Failed to retrieve")
    static func FormatterMaskFormatError(key:String,reason:String = "Unkown")->(Int,String) { return (304,"Failed to retrieve the value of '\(key)' since it has format issue: \(reason)")}
    static func FormatterMaskDuplicatedKey(key:String)->(Int,String){return (305, "The key '\(key)' is duplicated.")}
    
}


extension NSError{
    static func create(_ domain:String = domainNameDefault, code:(Int,String)) -> NSError{
        let d = ["NSLocalizedDescriptionKey" : code.1]
        return NSError(domain: domain, code: code.0, userInfo: d)
    }
}

func Error(domain:String = domainNameDefault, code:(Int,String)) -> NSError {
    return NSError.create(domain,code:code)
}
