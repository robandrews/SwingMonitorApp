//
//  Utils.swift
//  SwingWatch WatchKit Extension
//
//  Created by Rob Andrews on 3/8/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

// Thank you SO:
// https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift

func randomAlphaNumericString(length: Int) -> String {
    
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}
