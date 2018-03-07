/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the HealthKit interactions and provides a delegate 
         to indicate changes in data.
 */

import Foundation
import HealthKit

/**
 `WorkoutManagerDelegate` exists to inform delegates of swing data changes.
 These updates can be used to populate the user interface.
 */
protocol WorkoutManagerDelegate: class {
    func didUpdateForehandSwingCount(_ manager: WorkoutManager, forehandCount: Int)
    func didUpdateAccelMagnitude(_ manager: WorkoutManager, lastAccel: Int)
}

class WorkoutManager: MotionManagerDelegate {
    // MARK: Properties
    let motionManager = MotionManager()
    let healthStore = HKHealthStore()

    weak var delegate: WorkoutManagerDelegate?
    var session: HKWorkoutSession?

    // MARK: Initialization
    
    init() {
        motionManager.delegate = self
    }

    // MARK: WorkoutManager
    
    func startWorkout() {
        print("Starting swing session.")
        
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .golf
        workoutConfiguration.locationType = .outdoor

        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }

        // Start the workout session and device motion updates.
        healthStore.start(session!)
        motionManager.startUpdates()
    }

    func stopWorkout() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }

        // Stop the device motion updates and workout session.
        motionManager.stopUpdates()
        healthStore.end(session!)

        // Clear the workout session.
        session = nil
    }

    // MARK: MotionManagerDelegate
    
    func didUpdateForehandSwingCount(_ manager: MotionManager, forehandCount: Int) {
        delegate?.didUpdateForehandSwingCount(self, forehandCount: forehandCount)
    }

    func didUpdateAccelMagnitude(_ manager: MotionManager, lastAccel: Int) {
        delegate?.didUpdateAccelMagnitude(self, lastAccel: lastAccel)
    }
}
