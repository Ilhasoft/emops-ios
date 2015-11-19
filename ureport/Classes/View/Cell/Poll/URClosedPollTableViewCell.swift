//
//  URPollTextTableViewCell.swift
//  ureport
//
//  Created by Daniel Amaral on 13/08/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class URClosedPollTableViewCell: UITableViewCell {

    @IBOutlet weak var lbCategoryName: UILabel!
    @IBOutlet weak var lbDescr: UILabel!
    @IBOutlet weak var lbClosedDate: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var poll:URPoll!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the view for the selected state
    }
    
    //MARK: Class Methods
    
    func setupCellWithData(poll:URPoll) {
        self.poll = poll
        self.lbCategoryName.text = poll.category.name
        self.lbDescr.text = poll.title
        self.lbClosedDate.text = poll.expiration_date
        self.viewTop.backgroundColor = poll.category.color
    }
    
}
