//
//  Notificator.swift
//  Pennybox
//
//  Created by Dmitry Terekhov on 5/25/17.
//  Copyright © 2017 PennyLabs. All rights reserved.
//

import BRYXBanner

class Notificator {
    
    // MARK: - Private API
    private struct Constants {
        static let infoMessageBgColor = UIColor(red:0.03, green:0.71, blue:0.31, alpha:1.00)
        static let errorMessageBgColor = UIColor(red:0.98, green:0.22, blue:0.26, alpha:1.00)
        static let showingTime: TimeInterval = 2.0
    }
    
    private static var banners: [Banner] = []
    
    private class func show(message: String, backgroundColor: UIColor, didTapBlock: (() -> Void)?) {
        // Dismiss old banner
        Notificator.banners.forEach { $0.dismiss() }
        
        // Show new banner
        let banner = Banner(title: message, backgroundColor: backgroundColor)
        banner.titleLabel.textAlignment = .center
        banner.dismissesOnTap = didTapBlock == nil
        banner.didTapBlock = didTapBlock
        banner.didDismissBlock = { [weak banner] in
            if let banner = banner, let index = banners.index(of: banner) {
                banners.remove(at: index)
            }
        }
        Notificator.banners.append(banner)
        banner.show(duration: Constants.showingTime)
    }
    
    // MARK: - Public API
    class func show(infoMessage: String, didTapBlock: (() -> Void)? = nil) {
        show(message: infoMessage, backgroundColor: Constants.infoMessageBgColor, didTapBlock: didTapBlock)
    }
    
    class func show(errorMessage: String) {
        show(message: errorMessage, backgroundColor: Constants.errorMessageBgColor, didTapBlock: nil)
    }
    
}
