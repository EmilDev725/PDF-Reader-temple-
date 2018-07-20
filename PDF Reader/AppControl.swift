//
//  AppControl.swift
//  PDF Reader
//
//  Created by iDev on 20/07/2018.
//  Copyright © 2018 ILearniOS. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppControl: NSObject {
    class var sharedInstance: AppControl{
        struct Singleton{ static let instance = AppControl() }
        return Singleton.instance
    }
    
    var INTERSTITIAL: String = ""
    var BANNER: String = ""
    var APP_ID: String = ""
    var Rating: Bool = false
    var Rate_Text: String = ""
    var Rate_Poupup_Text: String = ""
    var Rating_Link: String = ""
    var App2: Bool = false
    
    override init() {
        INTERSTITIAL = ""
        BANNER = ""
        APP_ID = ""
        Rating = false
        Rate_Text = ""
        Rate_Poupup_Text = ""
        Rating_Link = ""
        App2 = false
    }
    
    func initWithJSON(json: JSON) {
        INTERSTITIAL =      json["INTERSTITIAL"].stringValue
        BANNER =            json["BANNER"].stringValue
        APP_ID =            json["APP_ID"].stringValue
        Rating =            json["Rating"].boolValue
        Rate_Text =         json["Rate_Text"].stringValue
        Rate_Poupup_Text =  json["Rate_Poupup_Text"].stringValue
        Rating_Link =       json["Rating_Link"].stringValue
        App2 =              json["App2"].boolValue
    }
    
    
}
