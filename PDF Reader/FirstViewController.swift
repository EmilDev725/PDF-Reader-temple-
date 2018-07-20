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

class FirstViewController: UIViewController {
    let API_URL = "http://betafind.com/tv/api.json"
    
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
                let flag: Bool = jsonObject["App2"].boolValue
                if (flag == false) {
                    self.performSegue(withIdentifier: "pushToSRC1", sender: self)
                }else {
                    self.performSegue(withIdentifier: "pushToSRC2", sender: self)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
