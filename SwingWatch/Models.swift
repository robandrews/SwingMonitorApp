//
//  Models.swift
//  SwingWatch
//
//  Created by Rob Andrews on 3/3/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

struct MotionData : Codable {
    let accelX: [Double]
    let accelY: [Double]
    let accelZ: [Double]
    let rotX:   [Double]
    let rotY:   [Double]
    let rotZ:   [Double]
    let userId: String
    let origin: String?
}
