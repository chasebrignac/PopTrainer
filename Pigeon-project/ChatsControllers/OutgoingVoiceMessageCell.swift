//
//  OutgoingVoiceMessageCell.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 11/26/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import AVFoundation

class OutgoingVoiceMessageCell: BaseMessageCell {
  
  var playerView: PlayerCellView = {
    var playerView = PlayerCellView()
    playerView.alpha = 1
    playerView.backgroundColor = .clear
    playerView.play.setImage(UIImage(named: "pause"), for: .selected)
    playerView.play.setImage(UIImage(named: "playWhite"), for: .normal)
    playerView.play.isSelected = false
    playerView.timerLabel.text = "00:00:00"
    playerView.startingTime = 0
    playerView.seconds = 0
    
    return playerView
  }()
    
  override func setupViews() {
    bubbleView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:))) )
    contentView.addSubview(bubbleView)
    bubbleView.addSubview(playerView)
    contentView.addSubview(deliveryStatus)
    bubbleView.image = blueBubbleImage
    bubbleView.frame.size.width = 150
    playerView.playLeadingAnchor.constant = 12
    playerView.playWidthAnchor.constant = 20
    playerView.playHeightAnchor.constant = -5
    playerView.timelabelLeadingAnchor.constant = playerView.playWidthAnchor.constant + playerView.playLeadingAnchor.constant
    playerView.timerLabel.font = UIFont.systemFont(ofSize: 12)
  }
  
  override func prepareViewsForReuse() {
    playerView.timerLabel.text = "00:00:00"
    playerView.seconds = 0
    playerView.startingTime = 0
    playerView.play.isSelected = false
    bubbleView.image = blueBubbleImage
  }
}
