//
//  PDFViewController.swift
//  PDF Reader
//
//  Created by Chintan Dave on 21/10/16.
//  Copyright © 2016 ILearniOS. All rights reserved.
//

import UIKit
import GoogleMobileAds
class PDFViewController: UIViewController,
    UIPageViewControllerDataSource,
    UIPageViewControllerDelegate,
    URLSessionDelegate,
    URLSessionDownloadDelegate
{
    var localPDFURL:URL?
    var remotePDFURL:URL?
    var PDFDocument:CGPDFDocument?

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var interstitial: GADInterstitial!

    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if remotePDFURL != nil
        {
            self.loadRemotePDF()
        }
        else if localPDFURL != nil
        {
            self.loadLocalPDF()
        }
            //Your code goes here
            self.loadInterstitial()
        
    }
    
    func loadLocalPDF()
    {
        progressView.isHidden = true;
        
        let PDFAsData = NSData(contentsOf: localPDFURL!)
        let dataProvider = CGDataProvider(data: PDFAsData!)
        
        self.PDFDocument = CGPDFDocument(dataProvider!)
        
        self.navigationItem.title = "Liste Des Chaines";
        self.preparePageViewController()
        self.navigationItem.hidesBackButton = false
        let newBackButton = UIBarButtonItem(title: "<Back ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PDFViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func back(sender: UIBarButtonItem) {
            //Your code goes here
            self.showInterstital()
        self.navigationController?.popViewController(animated: true)
    }

    func loadRemotePDF()
    {
        progressView.setProgress(0, animated: false)
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: remotePDFURL!)
        
        downloadTask.resume()
    }
    
    func preparePageViewController()
    {
        pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        pageController.dataSource = self
        pageController.delegate = self
        
        self.addChildViewController(pageController)

        pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(pageController.view)
        
        let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFPageViewController") as! PDFPageViewController
        
        pageVC.PDFDocument = PDFDocument
        pageVC.pageNumber  = 1
        
        DispatchQueue.main.async {
            self.pageController.setViewControllers([pageVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageVC = viewController as! PDFPageViewController
        
        if pageVC.pageNumber! > 1
        {
            let previousPageVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFPageViewController") as! PDFPageViewController
            
            previousPageVC.PDFDocument = PDFDocument
            previousPageVC.pageNumber  = pageVC.pageNumber! - 1
            
            return previousPageVC
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageVC = viewController as! PDFPageViewController
        
        let previousPageVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFPageViewController") as! PDFPageViewController
        
        previousPageVC.PDFDocument = PDFDocument
        previousPageVC.pageNumber  = pageVC.pageNumber! + 1
        
        return previousPageVC
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        self.localPDFURL = location
        
        self.loadLocalPDF()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async
        {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        dump(error)
    }
    func loadInterstitial()
    {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3023134250340516/7390761864")
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
