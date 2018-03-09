//
//  Models.swift
//  SwingWatch
//
//  Created by Rob Andrews on 3/3/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

struct MotionData : Codable {
    let accelX   : [Double]
    let accelY   : [Double]
    let accelZ   : [Double]
    let rotX     : [Double]
    let rotY     : [Double]
    let rotZ     : [Double]
    let userId   : String
    let origin   : String?
}

// TODO: convert this into a class, figure out how to keep it codable
struct Swing : Codable {
    let motionData  : MotionData
    let ts          : String
    let userId      : String
}

func motionDataToDict(md: MotionData) -> [String: Any?]
{
    var retDict = [String: Any?]()
    retDict["accelX"] = md.accelX
    retDict["accelY"] = md.accelY
    retDict["accelZ"] = md.accelZ
    retDict["rotX"] = md.rotX
    retDict["rotY"] = md.rotY
    retDict["rotZ"] = md.rotZ
    retDict["userId"] = md.userId
    retDict["origin"] = md.origin
    retDict["_msgType"] = "accelerations"
    return retDict
}

