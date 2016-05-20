//
//  URMissionManager.swift
//  ureport
//
//  Created by Daniel Amaral on 09/09/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

protocol URMissionManagerDelegate {
    func newMissionReceived(mission:URMission)
    func missionDidRemove(mission:URMission)
    func missionDidChange(mission:URMission)
}

class URMissionManager: NSObject {
   
    static var missions:[URMission]!
    var delegate: URMissionManagerDelegate?
    
    func getAvailableMissions() {
        
        URMissionManager.missions = []
        
        URMissionManager.missions.append(URMission(code: "GLOBAL", themeColor: URConstant.Color.PRIMARY, org:13, name: "Global Reporting",twitter:nil,  facebook:nil,rapidProHostAPI: URConstant.RapidPro.API_URL, ureportHostAPI: URConstant.RapidPro.API_NEWS, groupName: "U-Reporters"))
        
            URFireBaseManager.sharedInstance()
                .childByAppendingPath(URInformation.path())
                .observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
                    
                    let mission = URMission(code: snapshot.key, themeColor: URConstant.Color.PRIMARY, org: 0, name: (snapshot.value as! NSDictionary).objectForKey("name") as! String, twitter: nil, facebook: nil, rapidProHostAPI: URConstant.RapidPro.API_URL, ureportHostAPI: URConstant.RapidPro.API_NEWS, groupName: "U-Reporters")
                    
                    if URMissionManager.missions.count == 1 && URMissionManager.missions[0].code == "GLOBAL" {
                        URMissionManager.missions.removeFirst()
                    }
                    
                    URMissionManager.missions.append(mission)
                    
                    if let delegate = self.delegate {
                        delegate.newMissionReceived(mission)
                    }
                })
        
    }
    
    func getRemovedMissions() {
        URFireBaseManager.sharedInstance()
            .childByAppendingPath(URInformation.path())
            .observeEventType(FEventType.ChildRemoved, withBlock: { (snapshot) in
                
                let mission = URMission(code: snapshot.key, themeColor: URConstant.Color.PRIMARY, org: 0, name: (snapshot.value as! NSDictionary).objectForKey("name") as! String, twitter: nil, facebook: nil, rapidProHostAPI: URConstant.RapidPro.API_URL, ureportHostAPI: URConstant.RapidPro.API_NEWS, groupName: "U-Reporters")
                
                if let delegate = self.delegate {
                    delegate.missionDidRemove(mission)
                }
            })
    }
    
    func getChangedMissions() {
        URFireBaseManager.sharedInstance()
            .childByAppendingPath(URInformation.path())
            .observeEventType(FEventType.ChildChanged, withBlock: { (snapshot) in
                
                let mission = URMission(code: snapshot.key, themeColor: URConstant.Color.PRIMARY, org: 0, name: (snapshot.value as! NSDictionary).objectForKey("name") as! String, twitter: nil, facebook: nil, rapidProHostAPI: URConstant.RapidPro.API_URL, ureportHostAPI: URConstant.RapidPro.API_NEWS, groupName: "U-Reporters")
                
                if let delegate = self.delegate {
                    delegate.missionDidChange(mission)
                }
            })
    }
    
    class func getChannelOfMission(mission:URMission) -> String?{
        
        var myDict: NSDictionary?
        var channel:String?
        
        if let path = NSBundle.mainBundle().pathForResource(URFireBaseManager.Properties, ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = myDict {
            
            if dict["\(URConstant.Key.MISSION_CHANNEL)\(mission.code)"] != nil {
                channel = dict["\(URConstant.Key.MISSION_CHANNEL)\(mission.code)"] as? String
            }else {
                channel = dict["\(URConstant.Key.MISSION_CHANNEL)\(URConstant.RapidPro.GLOBAL)"] as? String
            }
            
        }
        
        return channel
        
    }
    
    class func getToken() -> String? {
        
        var rootDictionary: NSDictionary?
        var token:String?
        
        if let path = NSBundle.mainBundle().pathForResource(URFireBaseManager.Properties, ofType: "plist") {
            rootDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = rootDictionary {
            
            print(missions[0])
            
            if dict["\(URConstant.Key.MISSION_TOKEN)\(missions[0].code)"] != nil {
                token = dict["\(URConstant.Key.MISSION_TOKEN)\(missions[0].code)"] as? String
            }else {
                token = dict["\(URConstant.Key.MISSION_TOKEN)\(URConstant.RapidPro.GLOBAL)"] as? String
            }
            
        }
        
        return token
        
    }
    
    class func getTokenOfMission(mission:URMission) -> String? {
        
        var rootDictionary: NSDictionary?
        var token:String?

        if let path = NSBundle.mainBundle().pathForResource(URFireBaseManager.Properties, ofType: "plist") {
            rootDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = rootDictionary {
            
            if dict["\(URConstant.Key.MISSION_TOKEN)\(mission.code)"] != nil {
                token = dict["\(URConstant.Key.MISSION_TOKEN)\(mission.code)"] as? String
            }else {
                token = dict["\(URConstant.Key.MISSION_TOKEN)\(URConstant.RapidPro.GLOBAL)"] as? String
            }
            
        }
        
        return token
        
    }
    
    class func getChannelOfCurrentMission() -> String {
        return URMissionManager.getChannelOfMission(URMissionManager.activeMission()!)!
    }

    class func activeMission() -> URMission? {
        
        if let mission = URMissionManager.activeSwitchMission() {
            return mission
        }
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData: NSData?
        
        encodedData = defaults.objectForKey("mission") as? NSData
        
        if encodedData != nil {
            let mission = URMission(jsonDict: NSKeyedUnarchiver.unarchiveObjectWithData(encodedData!) as? NSDictionary)
            return mission
        }else{
            return missions[0]
        }
        
    }
    
    class func setActiveMission(mission: URMission!) {
        self.deactivateMission()
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let encodedObject: NSData = NSKeyedArchiver.archivedDataWithRootObject(mission.toDictionary())
        defaults.setObject(encodedObject, forKey: "mission")
        defaults.synchronize()
    }
    
    class func deactivateMission() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("mission")
        defaults.synchronize()
    }
    
    class func setSwitchActiveMission(mission: URMission!) {
        self.deactivateSwitchMission()
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let encodedObject: NSData = NSKeyedArchiver.archivedDataWithRootObject(mission.toDictionary())
        defaults.setObject(encodedObject, forKey: "mission_switch")
        defaults.synchronize()
    }
    
    class func deactivateSwitchMission() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("mission_switch")
        defaults.synchronize()
    }

    class func activeSwitchMission() -> URMission? {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var encodedData: NSData?
        
        encodedData = defaults.objectForKey("mission_switch") as? NSData
        
        if encodedData != nil {
            let mission = URMission(jsonDict: NSKeyedUnarchiver.unarchiveObjectWithData(encodedData!) as? NSDictionary)
            return mission
        }else{
            return nil
        }
        
    }
    
    class func updateMission(mission:URMission,isNew:Bool,completion:() -> Void) {
        URFireBaseManager.sharedInstance()
            .childByAppendingPath(URInformation.path())
            .childByAppendingPath(mission.code)
            .childByAppendingPath("name")
            .setValue(mission.name, withCompletionBlock: { (error:NSError!, firebase: Firebase!) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                }else {
                    if isNew == true {
                        
                    }
                    completion()
                }
            })
    }
    
    class func removeMission(mission:URMission) {
        URFireBaseManager.sharedInstance()
            .childByAppendingPath(URInformation.path())
            .childByAppendingPath(mission.code)
            .removeValueWithCompletionBlock { (error:NSError!, firebase:Firebase!) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    URMissionManager.missions.removeAtIndex(URMissionManager.missions.indexOf({$0.code == mission.code})!)
                }
        }
    }
    
}
