//
//  BaseMessageCell+CellDeletionHandlers.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 12/12/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import Firebase

struct ContextMenuItems {
  static let copyItem = "Copy"
  static let copyPreviewItem = "Copy image preview"
  static let deleteItem = "Delete for myself"
}


extension BaseMessageCell {
  
  @objc func handleLongTap(_ longPressGesture: UILongPressGestureRecognizer) {
    
    var contextMenuItems = [ContextMenuItems.copyItem, ContextMenuItems.deleteItem]
    let config = FTConfiguration.shared
    let expandedMenuWidth: CGFloat = 150
    let defaultMenuWidth: CGFloat = 100
    config.menuWidth = expandedMenuWidth
  
    guard let indexPath = self.chatLogController?.collectionView?.indexPath(for: self) else { return }
    
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? OutgoingVoiceMessageCell {
      if self.message?.status == messageStatusSending { return }
      cell.bubbleView.image = BaseMessageCell.selectedOutgoingBubble
      contextMenuItems = [ContextMenuItems.deleteItem]
    }
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? IncomingVoiceMessageCell {
      if self.message?.status == messageStatusSending { return }
      contextMenuItems = [ContextMenuItems.deleteItem]
      cell.bubbleView.image = BaseMessageCell.selectedIncomingBubble
    }
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? PhotoMessageCell {
      cell.bubbleView.image = BaseMessageCell.selectedOutgoingBubble
      if !cell.playButton.isHidden {
        contextMenuItems = [ContextMenuItems.copyPreviewItem, ContextMenuItems.deleteItem]
        config.menuWidth = expandedMenuWidth
      }
    }
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? IncomingPhotoMessageCell {
      cell.bubbleView.image = BaseMessageCell.selectedIncomingBubble
      if !cell.playButton.isHidden {
        contextMenuItems = [ContextMenuItems.copyPreviewItem, ContextMenuItems.deleteItem]
        config.menuWidth = expandedMenuWidth
      }
    }
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? OutgoingTextMessageCell {
      cell.bubbleView.image = BaseMessageCell.selectedOutgoingBubble
    }
    if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? IncomingTextMessageCell {
      cell.bubbleView.image = BaseMessageCell.selectedIncomingBubble
    }
    
    if self.message?.messageUID == nil || self.message?.status == messageStatusSending {
      config.menuWidth = defaultMenuWidth
      contextMenuItems = [ContextMenuItems.copyItem]
    }
    
    FTPopOverMenu.showForSender(sender: bubbleView, with: contextMenuItems, done: { (selectedIndex) in
      
      if contextMenuItems[selectedIndex] == ContextMenuItems.copyItem ||
        contextMenuItems[selectedIndex] == ContextMenuItems.copyPreviewItem {
        self.chatLogController?.collectionView?.reloadItems(at: [indexPath])
        if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? PhotoMessageCell {
          if cell.messageImageView.image == nil {
            guard let controllerToDisplayOn = self.chatLogController else { return }
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: copyingImageError, controller: controllerToDisplayOn)
            return
          }
          UIPasteboard.general.image = cell.messageImageView.image
        } else if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? IncomingPhotoMessageCell {
          if cell.messageImageView.image == nil {
            guard let controllerToDisplayOn = self.chatLogController else { return }
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: copyingImageError, controller: controllerToDisplayOn)
            return
          }

          UIPasteboard.general.image = cell.messageImageView.image
        } else if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? OutgoingTextMessageCell {
          UIPasteboard.general.string = cell.textView.text
        } else if let cell = self.chatLogController?.collectionView?.cellForItem(at: indexPath) as? IncomingTextMessageCell {
          UIPasteboard.general.string = cell.textView.text
        } else {
          return
        }
      } else {
        self.chatLogController?.deletedMessagesNumber += 1
        guard let uid = Auth.auth().currentUser?.uid, let partnerID = self.message?.chatPartnerId(), let messageID = self.message?.messageUID, self.currentReachabilityStatus != .notReachable else {
            self.chatLogController?.collectionView?.reloadItems(at: [indexPath])
            guard let controllerToDisplayOn = self.chatLogController else { return }
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: noInternetError, controller: controllerToDisplayOn)
            return
        }
        
       
        let deletionReference = Database.database().reference().child("user-messages").child(uid).child(partnerID).child("userMessages").child(messageID)
        deletionReference.removeValue(completionBlock: { (error, reference) in
          if error != nil {
            self.chatLogController?.deletedMessagesNumber -= 1
            return
          }
          let shouldReloadMessageStatus = self.shouldReloadMessageSatus()
          self.chatLogController?.collectionView?.performBatchUpdates ({
            
            self.chatLogController?.messages.remove(at: indexPath.item)
            self.chatLogController?.collectionView?.deleteItems(at: [indexPath])
            
          }, completion: { (isCompleted) in
            
            if self.chatLogController?.messages.count == 0 {
              print("CHAT LOG IS EMPTY")
              self.chatLogController?.allMessagesRemovedDelegate?.allMessagesRemoved(for: partnerID, state: true)
              
              self.chatLogController?.navigationController?.popViewController(animated: true)
            } else {
              guard shouldReloadMessageStatus, let lastMessage = self.chatLogController?.messages.last else { return }
              self.chatLogController?.updateMessageStatusUIAfterDeletion(sentMessage: lastMessage)
            }
            print("\ncell deletion completed\n")
          })
        })
      }
    }) { //completeion
      self.chatLogController?.collectionView?.reloadItems(at: [indexPath])
    }
  }
  
  func shouldReloadMessageSatus() -> Bool {
    guard self.message == self.chatLogController?.messages.last, self.chatLogController!.messages.count > 0 else { return false }
      return true
  }
}
