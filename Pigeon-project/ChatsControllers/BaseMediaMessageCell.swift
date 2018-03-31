//
//  BaseMediaMessageCell.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 9/4/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class BaseMediaMessageCell: BaseMessageCell {
  
  lazy var playButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "play")
    button.isHidden = true
    button.setImage(image, for: .normal)
    button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    
    return button
  }()
  
  lazy var messageImageView: UIImageView = {
    let messageImageView = UIImageView()
    messageImageView.translatesAutoresizingMaskIntoConstraints = false
    messageImageView.layer.cornerRadius = 15
    messageImageView.layer.masksToBounds = true
    messageImageView.isUserInteractionEnabled = true
    messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(handleZoomTap)))
    
    return messageImageView
  }()
  
  var progressView: CircleProgress = {
    let progressView = CircleProgress()
    progressView.translatesAutoresizingMaskIntoConstraints = false
    
    return progressView
  }()
  
  
  @objc func handlePlay() {
    
    var url: URL! = nil
    
    if message?.localVideoUrl != nil {
      let videoUrlString = message?.localVideoUrl
      url = URL(string: videoUrlString!)
      self.chatLogController?.performZoomInForVideo( url: url)
      return
    }
    
    if message?.videoUrl != nil {
      let videoUrlString = message?.videoUrl
      url =  URL(string: videoUrlString!)
      self.chatLogController?.performZoomInForVideo( url: url)
      return
    }
  }
  
  
  @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
    if message?.videoUrl != nil || message?.localVideoUrl != nil {
      handlePlay()
      return
    }
    guard let indexPath = chatLogController?.collectionView?.indexPath(for: self) else { return }
    self.chatLogController?.openSelectedPhoto(at: indexPath)
  }    
}
