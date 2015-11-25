//
//  URPollResultTableViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 22/09/15.
//  Copyright © 2015 ilhasoft. All rights reserved.
//

import UIKit

class URPollResultTableViewController: UITableViewController, URPollManagerDelegate {

    let pollManager = URPollManager()
    var pollResultList:[URPollResult] = []
    
    var poll:URPoll!
    
    init(poll:URPoll) {
        self.poll = poll
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = "Poll Result".localized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pollManager.delegate = self
        pollManager.getPollsResults(poll.key)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pollResultList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(URPollResultTableViewCell.self), forIndexPath: indexPath) as! URPollResultTableViewCell
        
        cell.setupCellWithData(self.pollResultList[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as? URPollResultTableViewCell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let pollResult = pollResultList[indexPath.row]
        
        if pollResult.type == "Choices" {
            return 189 + CGFloat(pollResult.results.count * 61)
        }else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    //MARK: PollManager Delegate
    
    func newPollReceived(poll: URPoll) {
        
    }
    
    func newPollResultReceived(pollResult: URPollResult) {
        pollResultList.insert(pollResult, atIndex: 0)
        self.tableView.reloadData()
    }
    
    //MARK: Class Methods
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.tableView.backgroundColor = URConstant.Color.WINDOW_BACKGROUND
        self.tableView.registerNib(UINib(nibName: "URPollResultTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(URPollResultTableViewCell.self))
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 189;
    }
}