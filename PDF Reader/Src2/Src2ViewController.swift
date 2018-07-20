//
//  Src2ViewController.swift
//  PDF Reader
//
//  Created by iDev on 20/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds

class Src2ViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBanner()
        loadInterstitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProgress()
    }
    
    func loadProgress(){
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
            SVProgressHUD.popActivity()
            self.showInterstital()
            self.performSegue(withIdentifier: "pushToInputName", sender: self)
        }
    }
    
    func loadBanner() {
        bannerView.adUnitID = AppControl.sharedInstance.BANNER
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: AppControl.sharedInstance.INTERSTITIAL)
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func showInterstital()
    {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            self.loadInterstitial()
        } else {
            print("Ad wasn't ready")
        }
    }
}
