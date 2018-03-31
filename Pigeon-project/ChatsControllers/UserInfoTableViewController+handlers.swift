//
//  UserInfoTableViewController+handlers.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 10/18/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit


extension UserInfoTableViewController {
  
 @objc func openPhoto() {

    let imageView = UIImageView()
    
    let attributedCaptionSummary = NSMutableAttributedString(string: contactName + "\n", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
  
    imageView.sd_setImage(with: contactPhoto! as URL) { (image, error, cacheType, url) in
      let photo = INSPhoto(image: image, thumbnailImage: nil, messageUID: nil)
      photo.attributedTitle = attributedCaptionSummary
      
      let photos: [INSPhotoViewable] = [photo]
      
      let indexPath = IndexPath(row: 0, section: 0)
      let cell = self.tableView.cellForRow(at: indexPath) as! UserinfoHeaderTableViewCell
      let currentPhoto = photos[indexPath.row]
      let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell.icon)
        
      galleryPreview.referenceViewForPhotoWhenDismissingHandler = {  photo in
          return cell.icon
      }
      galleryPreview.modalPresentationStyle = .overFullScreen
      galleryPreview.modalPresentationCapturesStatusBarAppearance = true
      self.present(galleryPreview, animated: true, completion: nil)
    }
  }
}
