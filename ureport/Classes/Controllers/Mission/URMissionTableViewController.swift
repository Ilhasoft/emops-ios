//
//  URMarkerTableViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 14/08/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class URMissionTableViewController: UITableViewController, URMissionManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        URMissionManager.missions.append(mission)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
        }
        edit.backgroundColor = UIColor.lightGrayColor()
        
        let remove = UITableViewRowAction(style: .Normal, title: "Remove") { action, index in
            
        }
        remove.backgroundColor = UIColor.redColor()
        
        return [remove,edit]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 63
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URMissionManager.missions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(URSimpleCellTableViewCell.self), forIndexPath: indexPath) as! URSimpleCellTableViewCell
        
        cell.setupCellWith(URMissionManager.missions[indexPath.row])
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
