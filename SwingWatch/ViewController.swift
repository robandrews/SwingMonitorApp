/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This application's view controller.
 */

import UIKit
import NotificationCenter

class ViewController: UIViewController {
    
    @IBOutlet weak var swingCountLabel: UILabel!
    @IBOutlet weak var meanAccelXLabel: UILabel!
    @IBOutlet weak var meanAccelYLabel: UILabel!
    @IBOutlet weak var meanAccelZLabel: UILabel!
    
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View loaded.")
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.setSwingCountLabel(notty:)), name: Notification.Name.init(Constants.NotificationTypes.UPDATE_SWING_COUNT), object: nil)
        nc.addObserver(self, selector: #selector(self.setMeanAccelLabels(notty:)), name: Notification.Name.init(Constants.NotificationTypes.UPDATE_ACCELERATIONS), object: nil)
    }
    
    func setSwingCountLabel(notty: Notification){
        print("setting Swing Count Label")
        swingCountLabel.text = notty.object as! String
    }

    //     TODO: Prove the buffer data is coming over properly.
    func setMeanAccelLabels(notty: Notification){
        var accels = notty.object as! [[Double]]
        var means = [Double]()
        means.append(accels[0].reduce(0, +) / Double(accels[0].count))
        means.append(accels[1].reduce(0, +) / Double(accels[1].count))
        means.append(accels[2].reduce(0, +) / Double(accels[2].count))
        
        meanAccelXLabel.text = String(means[0])
        meanAccelYLabel.text = String(means[1])
        meanAccelZLabel.text = String(means[2])
    }
}

