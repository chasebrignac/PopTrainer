//
//  Conversation.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 12/2/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class Conversation: NSObject {

  var message: Message?
  var user : User?
  var chatMetaData: ChatMetaData?
  
  
  init(message: Message, user: User, chatMetaData: ChatMetaData? ) {
  
    self.message = message
    self.user = user
    self.chatMetaData = chatMetaData
  }
}


