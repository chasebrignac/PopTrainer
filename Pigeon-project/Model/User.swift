//
//  User.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/6/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class User: NSObject {

  var id: String?
  var name: String?
  var bio: String?
  var photoURL: String?
  var thumbnailPhotoURL: String?
  var phoneNumber: String?
  var onlineStatus: AnyObject?
  
  init(dictionary: [String: AnyObject]) {
    self.id = dictionary["id"] as? String
    self.name = dictionary["name"] as? String
    self.bio = dictionary["bio"] as? String
    self.photoURL = dictionary["photoURL"] as? String
    self.thumbnailPhotoURL = dictionary["thumbnailPhotoURL"] as? String
    self.phoneNumber = dictionary["phoneNumber"] as? String
    self.onlineStatus = dictionary["OnlineStatus"]// as? AnyObject
  }
}
