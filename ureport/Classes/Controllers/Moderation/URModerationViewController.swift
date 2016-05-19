//
//  URModerationViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 28/10/15.
//  Copyright © 2015 ilhasoft. All rights reserved.
//

import UIKit

class URModerationViewController: UITabBarController, UITabBarControllerDelegate {

    var appDelegate:AppDelegate!
    
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
        if viewController is URStoriesTableViewController {
            self.title = viewController.title
        }
        
        if viewController is URModeratorTableViewController {
            self.title = viewController.title
            self.navigationItem.rightBarButtonItems = nil
        }
        
        if viewController is URMissionTableViewController {
            self.title = viewController.title
            self.navigationItem.rightBarButtonItems = nil
        }
        
    }
    
}
