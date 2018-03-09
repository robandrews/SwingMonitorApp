//
//  SwingDetectedController.swift
//  SwingWatch WatchKit Extension
//
//  Created by Rob Andrews on 3/8/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import WatchKit
import Foundation
import Dispatch

class SwingDetectedController: WKInterfaceController {
    // MARK: Properties
    var saveSwingActionCallback : (String) -> Void

    // MARK: Interface Properties

    
    // MARK: Initialization
    
    init(context: Any?) {
        print("Initting SwingDetectedController")
        let c = context as! [String: Any?]
        self.saveSwingActionCallback = c["callback"] as! (String) -> Void
        super.init()
    }
    
    // MARK: WKInterfaceController
    
    @IBAction func SwingSaveAction() {
        let lastId = SwingStore.singleton._lastId
        self.saveSwingActionCallback(lastId)
        self.dismiss()
    }
    
    @IBAction func SwingIgnoreAction() {
        self.dismiss()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}

