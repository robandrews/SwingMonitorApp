//
//  Constants.swift
//  SwingWatch
//
//  Created by Rob Andrews on 3/3/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation

struct Constants{
    struct Urls{
        static let SWING_SERVICE_URL = "https://5mj1p216sd.execute-api.us-west-1.amazonaws.com/Production/swing"
    }
    
    struct NotificationTypes{
        static let UPDATE_SWING_COUNT = "UPDATE_SWING_COUNT"
        static let UPDATE_ACCELERATIONS = "UPDATE_ACCELERATIONS"
    }
}
