//
//  URLoginAlertView.swift
//  ureport
//
//  Created by Daniel Amaral on 20/09/15.
//  Copyright © 2015 ilhasoft. All rights reserved.
//

import UIKit

class URLoginAlertController: UIAlertController {
    
    class func show(viewController:UIViewController) {
        let alertController: UIAlertController = UIAlertController(title: "login_required".localized, message: "login_msg".localized, preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel_dialog_button".localized, style: .Cancel) { action -> Void in

        }
        
        
        let loginAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            URNavigationManager.setupNavigationControllerWithLoginViewController()
        }
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
