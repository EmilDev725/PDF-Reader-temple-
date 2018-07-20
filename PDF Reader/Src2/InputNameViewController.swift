//
//  InputNameViewController.swift
//  PDF Reader
//
//  Created by iDev on 19/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InputNameViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tfYourName: UITextField!
    
    // MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.hidesBackButton = true
       
        loadBanner()
        showInterstital()
    }
    
    func loadBanner() {
        bannerView.adUnitID = "ca-app-pub-3023134250340516/8951255542"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    func showInterstital()
    {
        if appDelegate.interstitial.isReady {
            appDelegate.interstitial.present(fromRootViewController: self)
            appDelegate.loadInterstitial()
        }else{
            print("Ad wasn't ready")
        }
    }

    // MARK: - Buttons' Action
    @IBAction func click_btn_Next(_ sender: UIButton) {
        if (tfYourName.text == "") {
            Notificator.show(errorMessage: "Enter your name")
        }else {
            self.performSegue(withIdentifier: "pushToInputPhoneNumber", sender: self)
        }
    }
    
    @IBAction func click_btn_Back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
