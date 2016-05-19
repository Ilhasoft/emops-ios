//
//  URInformation.swift
//  e-report
//
//  Created by Daniel Amaral on 18/05/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit

class URInformation: NSObject {

    var code: String!
    var name: String!
    
    //MARK: FireBase Methods
    class func path() -> String {
        return "information"
    }
    
}
