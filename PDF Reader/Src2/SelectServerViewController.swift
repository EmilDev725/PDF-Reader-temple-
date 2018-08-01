//
//  SelectServerViewController.swift
//  PDF Reader
//
//  Created by iDev on 20/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SelectServerViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tblList: UITableView!
    
    var interstitial: GADInterstitial!
    
    let arrServers = ["SERVER USA 1", "SERVER USA 2", "SERVER USA 3", "SERVER USA 4", "SERVER USA 5", "SERVER SPAIN", "SERVER FRANCE", "SERVER ITALY", "SERVER DENMARK", "SERVER SWEDEN", "SERVER RUSSIA", "SERVER CHINA", "SERVER CANADA", "SERVER PORTUGAL", "SERVER UK 1", "SERVER UK2", "SERVER UK 3", "SERVER UK 4", "SERVER UK 5"]
    
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
    @IBAction func click_btn_Back(_ sender: UIBarButtonItem) {
        showInterstital()
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectServerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrServers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServerTBCell = self.tblList.dequeueReusableCell(withIdentifier: "ServerCell") as! ServerTBCell
        cell.lblServerName.text = arrServers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: ServerTBCell = self.tblList.cellForRow(at: indexPath) as! ServerTBCell
        Notificator.show(infoMessage: "\(cell.lblServerName.text!) SELECTED!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            self.showInterstital()
            self.performSegue(withIdentifier: "pushToConnectServer", sender: self)
        }
    }
}
