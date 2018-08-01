//
//  AppRateViewController.swift
//  PDF Reader
//
//  Created by iDev on 20/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AppRateViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //      self.navigationItem.hidesBackButton = true
        
        loadBanner()
        loadInterstitial()
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
    
    // MARK: - Buttons' Action
    @IBAction func click_btn_Back(_ sender: UIBarButtonItem) {
        showInterstital()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func click_btn_AppRate(_ sender: UIButton) {
        if (AppControl.sharedInstance.Rating_Link != "") {
            let url: URL = URL(string: AppControl.sharedInstance.Rating_Link)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
