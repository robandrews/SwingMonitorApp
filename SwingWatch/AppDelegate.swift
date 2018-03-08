/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This application delegate.
 */

import UIKit
import WatchConnectivity
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    

    var window: UIWindow?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sendAccelerationToServer(accels: [[Double]]) -> Void{
        let endpointUrl = URL(string: Constants.Urls.SWING_SERVICE_URL)
        
        var dataToEncode = MotionData(accelX: accels[0], accelY: accels[1], accelZ: accels[2], rotX: accels[3], rotY: accels[4], rotZ: accels[5], userId: "1", origin: "iOS")
//        <<async>>.
        do {
            print("Trying createSwing request.")
            guard let data = try? JSONEncoder().encode(dataToEncode) else {
                return
            }
            
            var request = URLRequest(url: endpointUrl!)
            print(endpointUrl!)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = data
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request){ data, response, error in
                print("In return block.")
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }
                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("got data: \(dataString)")
                }
            }
            task.resume()
        }catch{
            print("In error block for url request.")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let msgType = message["_msgType"] as! String
        if msgType == "swingCount"{
            let countInt = message["swingCount"] as! NSNumber
            let countString = "\(countInt)"
            
            print("Got swingCount.")
            let nc = NotificationCenter.default
            let notty = Notification.init(name: Notification.Name.init(Constants.NotificationTypes.UPDATE_SWING_COUNT), object: countString)
            nc.post(notty)
        } else if msgType == "accelerations"
        {
            let accelX = message["accelX"] as! [Double]
            let accelY = message["accelY"] as! [Double]
            let accelZ = message["accelZ"] as! [Double]
            let rotX = message["rotX"] as! [Double]
            let rotY = message["rotY"] as! [Double]
            let rotZ = message["rotZ"] as! [Double]
            let accels = [accelX, accelY, accelZ, rotX, rotY, rotZ]
            
            
            sendAccelerationToServer(accels: accels)
            
            let nc = NotificationCenter.default
            let notty = Notification.init(name: Notification.Name.init(Constants.NotificationTypes.UPDATE_ACCELERATIONS), object: accels)
            nc.post(notty)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("Trying to create WCSession...")
        if WCSession.isSupported() {
            print("WCSession is supported, creating...")
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        print("Getting notification center")
        let nc = NotificationCenter.default
        
        print("Putting on dispatch queue.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Executing inside dispatch queue.")
            let notty = Notification.init(name: Notification.Name.init(Constants.NotificationTypes.UPDATE_SWING_COUNT), object: "99")
            nc.post(notty)
        }
        
        return true
    }
}

