//
//  Models.swift
//  SwingWatch
//
//  Created by Rob Andrews on 3/3/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

struct AccelerometerData : Codable {
    let accelX: [Double]
    let accelY: [Double]
    let accelZ: [Double]
    let userId: String
    let origin: String?
}
