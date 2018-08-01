//
//  FirstViewController.swift
//  PDF Reader
//
//  Created by iDev on 19/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleMobileAds
import FBSDKLoginKit

class FirstViewController: UIViewController {
    let API_URL = "http://betafind.com/tv/api.json"
    
    var interstitial: GADInterstitial!
    
    // MARK: - Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        checkAPI()
    }
    
    func checkAPI() {
        SVProgressHUD.show()
        Alamofire.request(API_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) .responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(_):
                let jsonObject = JSON(response.result.value!)
                AppControl.sharedInstance.initWithJSON(json: jsonObject)
                
                GADMobileAds.configure(withApplicationID: AppControl.sharedInstance.APP_ID)
                
                let flag: Bool = AppControl.sharedInstance.App2
                if (flag == false) {
                    self.performSegue(withIdentifier: "pushToSRC1", sender: self)
                }else {
                    self.loadInterstitial()
                    self.showInterstital()
                    self.performSegue(withIdentifier: "pushToSRC2", sender: self)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
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
