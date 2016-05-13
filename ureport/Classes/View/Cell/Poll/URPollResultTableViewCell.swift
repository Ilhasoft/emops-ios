//
//  URPollResultTableViewCell.swift
//  ureport
//
//  Created by Daniel Amaral on 22/09/15.
//  Copyright © 2015 ilhasoft. All rights reserved.
//

import UIKit
import TagListView
import DBSphereTagCloud

class URPollResultTableViewCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDetails: UILabel!
    @IBOutlet var sphereView: DBSphereView!
    @IBOutlet var viewSeparator: UIView!
    @IBOutlet var choiceView: UIView!
    @IBOutlet var containerView: UIView!
    
    var poll:URPoll!
    var pollResult:URPollResult!
    
    var viewChoiceHeight = 61
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewSeparator.layer.cornerRadius = 5
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.containerView.layer.borderWidth = 0.5
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.selectionStyle = UITableViewCellSelectionStyle.None
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
    
    //MARK: Class Methods
    
    func setupCellWithData(pollResult:URPollResult) {
        self.pollResult = pollResult
        self.lbDate.text = pollResult.date
        self.lbDetails.text = String(format: "polls_responded_info".localized, arguments: [pollResult.responded,pollResult.polled])
        self.lbTitle.text = pollResult.title
        
        self.sphereView.frame = CGRect(x: self.sphereView.bounds.origin.x, y: self.sphereView.bounds.origin.y, width: self.contentView.bounds.size.width, height: 300)
        self.sphereView.backgroundColor = UIColor.grayColor()
        
        if pollResult.type == "Keywords" {
            var indexKeywords = 1
            self.sphereView.hidden = false
            self.choiceView.hidden = true
            var tagList = [UIButton]()
            var results = pollResult.results
            
            if results.count > 10 {
                results.removeRange(Range(start: 10, end: pollResult.results.count))
            }
            
            for view in self.sphereView.subviews {
                view.removeFromSuperview()
            }
            
            for dictionary in results {
                let tag = dictionary.objectForKey("keyword") as! String
                let btnTag = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                btnTag.layer.cornerRadius = 40
                btnTag.backgroundColor = URConstant.Color.PRIMARY
                let buttonTitle = "\(indexKeywords). \(tag)"
                btnTag.setTitle(buttonTitle, forState: UIControlState.Normal)
                tagList.append(btnTag)
                self.sphereView.addSubview(btnTag)
                indexKeywords += 1
            }
            
            self.sphereView.setCloudTags(tagList)
            
        } else if pollResult.type == "Choices"{
            var indexChoices = 0
            self.sphereView.hidden = true
            self.choiceView.hidden = false
            
            let array = self.choiceView.subviews as [UIView];

            for view in array {
                view.removeFromSuperview()
            }
            
                for dictionary in pollResult.results {
                    let choiceResultView = NSBundle.mainBundle().loadNibNamed("URChoiceResultView", owner: 0, options: nil)[0] as? URChoiceResultView

                    choiceResultView!.frame = CGRectMake(0, CGFloat(indexChoices * viewChoiceHeight), UIScreen.mainScreen().bounds.width, CGFloat(viewChoiceHeight))
                    
                    let percent = dictionary.objectForKey("value") as? String
                    let title = dictionary.objectForKey("title") as? String
                    var color:UIColor!
                    
                    choiceResultView!.lbChoice.text = title
                    choiceResultView!.lbPercent.text = "\(percent!)%"
                    
                    if indexChoices > URPollManager.getColors().count {
                        color = UIColor.yellowColor()
                    }else {
                        color = UIColor(rgba:URPollManager.getColors()[indexChoices])
                    }
                    
                    choiceResultView!.viewPercent.backgroundColor = color
                    
                    let maxWidth = self.contentView.frame.size.width
                    var widthCell:CGFloat = self.contentView.frame.size.width   
                    
                    if Int(percent!) > 80 {
                        widthCell = maxWidth - 70
                    }
                    
                    let percentValue = Float(percent!)
                    
                    self.choiceView.addSubview(choiceResultView!)
                    choiceResultView!.viewPercentWidth.constant = (CGFloat(percentValue!/100)) * widthCell
                    
                    indexChoices++                
                }
        }
        
    }
    
}
