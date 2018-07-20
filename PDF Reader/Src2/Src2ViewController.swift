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

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showInterstital()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProgress()
    }
    
    func loadProgress(){
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            SVProgressHUD.popActivity()
            self.showInterstital()
            self.performSegue(withIdentifier: "pushToInputName", sender: self)
        }
    }
    
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3023134250340516/7390761864")
        let request = GADRequest()
        interstitial.load(request)
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
}
