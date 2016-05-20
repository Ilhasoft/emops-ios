//
//  URMarkerTableViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 14/08/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class URMissionTableViewController: UITableViewController, URMissionManagerDelegate {
    
    var missionManager = URMissionManager()
    var missionList = [URMission]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionManager.delegate = self
        missionManager.getAvailableMissions()
        setupTableView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = "Mission"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Poll Contribution")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    //MARK: URMissionManagerDelegate
    
    func newMessionReceived(mission: URMission) {
        missionList.append(mission)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: missionList.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! URSimpleCellTableViewCell
        let mission = cell.mission
        
        var alertController:UIAlertController!
        
        let edit = UITableViewRowAction(style: .Normal, title: "label_edit".localized) { action, index in
            alertController = UIAlertController(title: nil, message: "label_edit".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler({ (textField) in
                textField.text = mission.name
            })
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) in
               let textField = alertController.textFields![0]
                mission.name = textField.text?.uppercaseString
                
                self.missionList.removeAtIndex(indexPath.row)
                self.missionList.insert(mission, atIndex: index.row)
                
               URMissionManager.updateMission(mission, isNew: false, completion: {})
                
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        edit.backgroundColor = UIColor.lightGrayColor()
        
        let remove = UITableViewRowAction(style: .Normal, title: "label_remove".localized) { action, index in
            URMissionManager.removeMission(mission)
            self.missionList.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
        }
        remove.backgroundColor = UIColor.redColor()
        
        return [remove,edit]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 63
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(URSimpleCellTableViewCell.self), forIndexPath: indexPath) as! URSimpleCellTableViewCell
        
        cell.setupCellWith(missionList[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    //MARK: Class Methods
    
    func setupTableView() {
        
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.registerNib(UINib(nibName: "URSimpleCellTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(URSimpleCellTableViewCell.self))
        
    }
    
}
