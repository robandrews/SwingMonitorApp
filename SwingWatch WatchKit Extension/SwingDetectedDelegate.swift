//
//  SwingDetectedDelegate.swift
//  SwingWatch WatchKit Extension
//
//  Created by Rob Andrews on 3/8/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

protocol SwingDetectedDelegate {
    func swingWasDetectedAndAcknowledged(swingId: String)
}
