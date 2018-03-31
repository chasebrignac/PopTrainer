//
//  ChatMetaData.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/30/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class ChatMetaData:  NSObject  {
  
  var badge: Int?
  var pinned: Bool?
  var muted: Bool?
  
  init(dictionary: [String: AnyObject]?) {
    super.init()
    
    badge = dictionary?["badge"] as? Int
    pinned = dictionary?["pinned"] as? Bool
    muted = dictionary?["muted"] as? Bool
  }
}
