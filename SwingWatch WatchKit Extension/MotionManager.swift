/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the CoreMotion interactions and 
         provides a delegate to indicate changes in data.
 */

import Foundation
import CoreMotion
import WatchKit

/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
 These contexts can be used to enable application specific behavior.
 */
protocol MotionManagerDelegate: class {
    func didUpdateForehandSwingCount(_ manager: MotionManager, forehandCount: Int)
    func didUpdateAccelMagnitude(_ manager: MotionManager, lastAccel: Int)
}

class MotionManager {
    // MARK: Properties
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    let communicationMgr = CommunicationsManager()
    
    // MARK: Application Specific Constants
    
    let accelerationMagnitudeThreshold = 70
    let resetThreshold = 10.0
    
    // The app is using 50hz data and the buffer is going to hold 2s worth of data.
    let sampleInterval = 1.0 / 50
    let accelMagnitudeBuffer = RunningBuffer(size: 100)
    let accelX = RunningBuffer(size:100)
    let accelY = RunningBuffer(size:100)
    let accelZ = RunningBuffer(size:100)
    let rotX = RunningBuffer(size:100)
    let rotY = RunningBuffer(size:100)
    let rotZ = RunningBuffer(size:100)
    
    weak var delegate: MotionManagerDelegate?
    
    /// Swing counts.
    var forehandCount = 0
    var lastAccelMagnitude = 0
    var swingData = Data()
    var recentDetection = false
    
    
    
//
//    let recurringCounter = () -> Void {
//        counter += 1
//        communicationMgr.sendSwingCountToiOSDevice(count: counter)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            recurringCounter()
//        })
//    }
    
    // MARK: Initialization
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }

    // MARK: Motion Manager

    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }

        // Reset everything when we start.
        resetAllState()

        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }

            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
        }
    }

    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }

    // MARK: Motion Processing
    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        let a_x = deviceMotion.userAcceleration.x
        let a_y = deviceMotion.userAcceleration.y
        let a_z = deviceMotion.userAcceleration.z
        let r_x = deviceMotion.rotationRate.x
        let r_y = deviceMotion.rotationRate.y
        let r_z = deviceMotion.rotationRate.z
        
        accelX.addSample(a_x)
        accelY.addSample(a_y)
        accelZ.addSample(a_z)
        rotX.addSample(r_x)
        rotY.addSample(r_y)
        rotZ.addSample(r_z)
        
        let magnitudeAcceleration = sqrt(pow(a_x, 2) + pow(a_y, 2) + pow(a_z, 2))
        accelMagnitudeBuffer.addSample(magnitudeAcceleration)
        
        let peakAcceleration = Int(accelMagnitudeBuffer.max() * 9.81)
        setLastAccelValueAndUpdate(lastVal: peakAcceleration)
        
        if !accelMagnitudeBuffer.isFull() {
            return
        }

        if (peakAcceleration > accelerationMagnitudeThreshold && recentDetection == false) {
            recentDetection = true
            incrementSwingCountAndUpdateDelegate()
            packageAndSendCount()
        }

        if (recentDetection && (abs(accelMagnitudeBuffer.recentMean()) * 9.8 < resetThreshold)) {
            recentDetection = false
            sendBuffers()
            flushBuffers()
        }
    }

    // MARK: Data and Delegate Management
    func sendBuffers(){
        let dx = accelX.buffer
        let dy = accelY.buffer
        let dz = accelZ.buffer
        let rx = rotX.buffer
        let ry = rotY.buffer
        let rz = rotZ.buffer
        
        // Create a class to hold this
        let dict = ["accelX": dx, "accelY": dy, "accelZ": dz, "rotX": rx, "rotY": ry, "rotZ": rz, "_msgType": "accelerations"] as [String : Any]
        communicationMgr.sendMessageToiOSDevice(msg: dict)
    }
    
    func flushBuffers() {
        accelX.reset()
        accelY.reset()
        accelZ.reset()
        accelMagnitudeBuffer.reset()
    }
    
    func resetAllState() {
        accelMagnitudeBuffer.reset()

        forehandCount = 0
        lastAccelMagnitude = 0
        recentDetection = false

        updateForehandSwingDelegate()
        didUpdateAccelMagnitude()
    }

    func incrementSwingCountAndUpdateDelegate() {
        forehandCount += 1
        updateForehandSwingDelegate()
    }

    func setLastAccelValueAndUpdate(lastVal: Int) {
        lastAccelMagnitude = lastVal
        didUpdateAccelMagnitude()
    }
    
    func updateForehandSwingDelegate() {
        delegate?.didUpdateForehandSwingCount(self, forehandCount:forehandCount)
    }

    func didUpdateAccelMagnitude() {
        delegate?.didUpdateAccelMagnitude(self, lastAccel:lastAccelMagnitude)
    }
    
    func packageAndSendCount() {
        self.communicationMgr.sendSwingCountToiOSDevice(count: forehandCount)
    }
}
