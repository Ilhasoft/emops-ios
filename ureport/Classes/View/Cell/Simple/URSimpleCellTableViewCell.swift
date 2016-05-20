//
//  URSimpleCellTableViewCell.swift
//  ereport
//
//  Created by Daniel Amaral on 19/05/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit

class URSimpleCellTableViewCell: UITableViewCell {

    var mission:URMission!
    
    @IBOutlet var lbName:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the view for the selected state
    }
    
    //MARK: Class Methods
    
    func setupCellWith(mission:URMission) {
        self.mission = mission
        self.lbName.text = mission.name
    }
    
}
