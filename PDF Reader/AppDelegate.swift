//
//  AppDelegate.swift
//  PDF Reader
//
//  Created by Chintan Dave on 23/09/16.
//  Copyright © 2016 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var interstitial: GADInterstitial!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3023134250340516~4054152080")
        
        loadInterstitial()
        return true
    }
    
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3023134250340516/7390761864")
        let request = GADRequest()
        interstitial.load(request)
    }
}
