//
//  MopubMediationControllerSwift.swift
//  VIMopubSample
//
//  Created by Vitalii Cherepakha on 10/20/17.
//  Copyright © 2017 Vitalii Cherepakha. All rights reserved.
//

import UIKit
import VISDK

class MopubMediationControllerSwift: UIViewController {

    fileprivate lazy var ad:VIInterstitialAd? = {
		// FIXME: use your placementId.
        let placement = VIPlacement("plt59gczn8crjr99us7", options: nil)
        let result = VISDK.sharedInstance().createInterstitialAd(for: placement)
        result?.delegate = self
		
		// FIXME: use your placementId.
        let adapter = MopubVIInterstitialAdapter(placementID: "e90aa8b06e3c473aa0ba70ebfc8c5c89")
        result?.registerMediation?(adapter)
        return result
    }()
    
    @IBOutlet var statusLabel:UILabel?
    @IBOutlet var playButton:UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.playButton?.isEnabled = false
        self.statusLabel?.text = "Idling"
    }
    
    
    @IBAction func playButtonTouched(_ sender:UIButton)
    {
        ad?.show(from: self)
    }
    
    @IBAction func loadButtonTouched(_ sender:UIButton)
    {
        ad?.load()
        statusLabel?.text = "Loading..."
    }

}

extension MopubMediationControllerSwift : VIAdDelegate
{
    
    func adDidReceiveError(_ error: Error)
    {
        let controller = UIAlertController(title: "Error",
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close",
                                           style: .cancel,
                                           handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func adDidReceive(_ event: VIAdEvent)
    {
        switch event.type {
        case .loaded:
            self.playButton?.isEnabled = true
            self.statusLabel?.text = "Loaded"
            print("Ad loaded")
        case .started:
            print("Ad started")
        case .closed:
            print("Ad closed")
            playButton?.isEnabled = false;
            statusLabel?.text = "Idling";
        case .clicked:
            print("Ad clicked")
        case .paused:
            print("Ad paused")
        case .resumed:
            print("Ad resumed")
        case .expired:
            print("Ad expired")
        case .completed:
            print("Ad completed")
            playButton?.isEnabled = false;
            statusLabel?.text = "Idling";
            ad = nil;
        }
    }
}
