//
//  InputPhoneViewController.swift
//  PDF Reader
//
//  Created by iDev on 20/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InputPhoneViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tfYourPhoneNumber: UITextField!
    
    var interstitial: GADInterstitial!
    
    // MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.hidesBackButton = true
        
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
    @IBAction func click_btn_Next(_ sender: UIButton) {
        if (tfYourPhoneNumber.text == "") {
            Notificator.show(errorMessage: "Enter your phone number")
        }else {
            showInterstital()
            self.performSegue(withIdentifier: "pushToSelectServer", sender: self)
        }
    }

    @IBAction func click_btn_Back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
