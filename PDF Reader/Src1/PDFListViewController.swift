//
//  PDFListViewController.swift
//  PDF Reader
//
//  Created by Chintan Dave on 20/10/16.
//  Copyright © 2016 ILearniOS. All rights reserved.
//


import UIKit
import GoogleMobileAds

class PDFListViewController: UITableViewController
{
    var localPDFURLs:[URL] = []
    var remotePDFURLs:[URL] = []
    @IBOutlet weak var bannerView: GADBannerView!
    var interstitial: GADInterstitial!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        bannerView.adUnitID = AppControl.sharedInstance.BANNER
        self.loadInterstitial()
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        localPDFURLs.append(Bundle.main.url(forResource: "Liste_des_chaines", withExtension: "pdf")!)

        
        remotePDFURLs.append(URL(string: "http://cas.ee.ic.ac.uk/people/dario/files/E418/SL_410_apps.pdf")!)

    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let PDFVC:PDFViewController = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        self.showInterstital()
        if indexPath.section == 0
        {
            PDFVC.localPDFURL = localPDFURLs[indexPath.row]
        }
        else
        {
            PDFVC.localPDFURL = localPDFURLs[indexPath.row]
        }
        
        self.navigationController?.pushViewController(PDFVC, animated: true)
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
