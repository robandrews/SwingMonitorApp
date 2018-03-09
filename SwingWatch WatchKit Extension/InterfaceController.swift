/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class is responsible for managing interactions with the interface.
 */

import WatchKit
import Foundation
import Dispatch

// MARK: TODO
// RAA:
// * prompt user for permission to do local notifications
//      https://developer.apple.com/documentation/usernotifications/unusernotificationcenter/1649527-requestauthorization
// * design a long look interface to ask user whether that was actually a golf shot
// * if so, send it to the server
// * record gps coordinates when a potential golf shot is registered, store w/ data


class InterfaceController: WKInterfaceController, WorkoutManagerDelegate {
    func swingWasDetectedAndAcknowledged(swingId: String) {
        print("swingWasDetectedAndAcknowledged")
    }
    
    // MARK: Properties

    let workoutManager = WorkoutManager()
    let communicationManager = CommunicationsManager()
    
    var active = false
    var forehandCount = 0
    var backhandCount = 0
    var lastAccelValue = 0
    var device = WKInterfaceDevice.current()
    var appState = [String: Any?]()
    
    // MARK: Interface Properties
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var forehandCountLabel: WKInterfaceLabel!
    @IBOutlet weak var accelLabel: WKInterfaceLabel!
    @IBOutlet var ackLabel: WKInterfaceLabel!
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        workoutManager.delegate = self
    }

    // MARK: WKInterfaceController
    
    override func willActivate() {
        super.willActivate()
        active = true

        // On re-activation, update with the cached values.
        updateLabels()
        
        print("Context in InterfaceController:")
        print(appState)
    }

    override func didDeactivate() {
        super.didDeactivate()
        active = false
    }

    // MARK: Interface Bindings
    
    @IBAction func start() {
        titleLabel.setText("Workout started")
        workoutManager.startWorkout()
    }

    @IBAction func stop() {
        titleLabel.setText("Workout stopped")
        workoutManager.stopWorkout()
    }

    // MARK: WorkoutManagerDelegate
    
    func didDetectSwing(_ manager: WorkoutManager, swingCount: Int) {
        /// Serialize the property access and UI updates on the main queue.
        DispatchQueue.main.async {
            self.forehandCount = swingCount
            self.updateLabels()
            self.device.play(WKHapticType.success)
        }
        self.presentController(withName: "SwingDetectedController", context: ["callback": handleAcknowledgedSwing])
    }
    

    func didUpdateAccelMagnitude(_ manager: WorkoutManager, lastAccel: Int) {
        /// Serialize the property access and UI updates on the main queue.
        DispatchQueue.main.async {
            self.lastAccelValue = lastAccel
            self.updateLabels()
        }
    }

    // MARK: Convenience
    
    func updateLabels() {
        if active {
            forehandCountLabel.setText("\(forehandCount)")
            accelLabel.setText("\(lastAccelValue)")
        }
    }
    
    func handleAcknowledgedSwing(swingId: String){
        print("handleAcknowledgedSwing:")
        print(swingId)
        self.ackLabel.setText("ACK")
        
        // This is where we should kick off communication
        // We should have a swingStore which stores swings by id.
        let swing = SwingStore.singleton.getSwingFromStore(cacheKey: swingId)
        guard let md = swing?.motionData else { return }
        let dict = motionDataToDict(md: md)
        print("in handleAcknowledgedSwing, sending:")
        print(dict)
        communicationManager.sendMessageToiOSDevice(msg: dict)
    }

}
