//
//  URModerationViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 28/10/15.
//  Copyright © 2015 ilhasoft. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class URModerationViewController: UITabBarController, UITabBarControllerDelegate {

    var appDelegate:AppDelegate!
    
    lazy var readerVC = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    let storyViewController:URStoriesTableViewController = URStoriesTableViewController(filterStoriesToModerate: true)
    let moderatorViewController:URModeratorTableViewController = URModeratorTableViewController()
    let missionTableViewController:URMissionTableViewController = URMissionTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.appDelegate.requestPermissionForPushNotification(UIApplication.sharedApplication())
        
        setupViewControllers()
        tabBarController(self, didSelectViewController: missionTableViewController)
        
    }

    //MARK: Class Methods
    
    func openQRCodeReader() {
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            
            self.readerVC.dismissViewControllerAnimated(true, completion: { })
            
            if result != nil {
                URBackendAuthManager.saveAuthToken(result!.value, completion: { (success) in
                })
            }
        }
        
        readerVC.modalPresentationStyle = .FormSheet
        self.presentViewController(readerVC, animated: true) { }
    }
    
    func setupViewControllers() {
        
        storyViewController.title = "main_stories".localized
        storyViewController.tabBarItem.image = UIImage(named: "icon_stories")
                
        moderatorViewController.title = "label_country_moderator".localized
        moderatorViewController.tabBarItem.image = UIImage(named: "manageMod")
        
        missionTableViewController.title = "Missions".localized
        missionTableViewController.tabBarItem.image = UIImage(named: "manageMod")
        
        if URUser.activeUser()!.masterModerator != nil && URUser.activeUser()!.masterModerator == true {
            self.viewControllers = [missionTableViewController,storyViewController,moderatorViewController]
        }else {
            self.viewControllers = [missionTableViewController,storyViewController]
        }
    }
    
    //MARK: TabBarControllerDelegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        let qrCodeBarButton = UIBarButtonItem(image: UIImage(named: "ic_qrcode"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(openQRCodeReader))
        
        if viewController is URStoriesTableViewController {
            self.title = viewController.title
            self.navigationItem.rightBarButtonItems = [qrCodeBarButton]
        }
        
        if viewController is URModeratorTableViewController {
            self.title = viewController.title
            self.navigationItem.rightBarButtonItems = [qrCodeBarButton]
        }
        
        if viewController is URMissionTableViewController {
            self.title = viewController.title
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(createMission))]
        }
        
    }
    
    func createMission() {
        let alertController = UIAlertController(title: nil, message: "new_mission_label".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "new_mission_code".localized
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "new_mission_name".localized
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
        }
        alertController.addAction(UIAlertAction(title: "cancel_dialog_button".localized, style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alertAction) in
            
            let mission = URMission()
            
            let textFieldCode = alertController.textFields![0]
            let textFieldName = alertController.textFields![1]
            
            mission.code = textFieldCode.text?.uppercaseString
            mission.name = textFieldName.text
            
            alertAction.enabled = false
            
            URMissionManager.updateMission(mission, isNew: true, completion: {})
        }))
        
        alertController.actions.last!.enabled = false
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: TextFieldDelegate
    
    func alertTextFieldDidChange(sender: UITextField) {
        let alertController = (self.presentedViewController as! UIAlertController)
        let txtCode = alertController.textFields!.first
        let txtName = alertController.textFields!.last
        let okAction = alertController.actions.last
        
        okAction!.enabled = txtCode?.text?.characters.count >= 3 && txtName?.text?.characters.count >= 3

    }
}
