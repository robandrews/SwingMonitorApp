//
//  CommunicationsManager.swift
//  SwingWatch WatchKit Extension
//
//  Created by Rob Andrews on 2/28/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol CommunicationsManagerDelegate {
    func sendDataToiOSDevice(data: Data)
    func sendStringToiOSDevice(str: String)
}

class CommunicationsManager : NSObject, WCSessionDelegate
{
    // the reference to the delegator
    weak var delegate: WorkoutManagerDelegate?
    var active : Bool
    var wcSession : WCSession?
    
    override init() {
        if WCSession.isSupported() {
            let session = WCSession.default()
            self.wcSession = session
            self.active = true
            super.init() // can't use self until super.init() call
            self.wcSession!.delegate = self
            self.wcSession!.activate()
            print("WatchConnectivity session activated.")
        } else{
            self.active = false
            self.wcSession = nil
            super.init()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("In session method")
        if(activationState == WCSessionActivationState.activated){
            self.active = true
            self.wcSession = session
            print("In session method, activation stat is ")
        }else{
            self.active = false
        }
    }
    
    let replyHandlerBlockData: (Data) -> Void = { retData in
        print("Reply from iOS: \(retData)")
    }
    let replyHandlerBlockMsg: ([String:Any]) -> Void = { retData in
        print("Reply from iOS: \(retData)")
    }
    
    let errorHandlerBlock: (Error) -> Void = { retErr in
        print("Error from iOS \(retErr)")
    }
    
    func sendDataToiOSDevice(data: Data){
        self.wcSession!.sendMessageData(data, replyHandler: replyHandlerBlockData, errorHandler: errorHandlerBlock)
    }
    
    func sendMessageToiOSDevice(msg: [String: Any]){
        self.wcSession!.sendMessage(msg, replyHandler: replyHandlerBlockMsg, errorHandler: errorHandlerBlock)
    }
    
    func sendSwingCountToiOSDevice(count: Int){
        print("Sending swing count")
        let msg = ["swingCount": count, "_msgType": "swingCount"] as [String : Any]
        self.wcSession!.sendMessage(msg, replyHandler: replyHandlerBlockMsg, errorHandler: errorHandlerBlock)
    }
}
