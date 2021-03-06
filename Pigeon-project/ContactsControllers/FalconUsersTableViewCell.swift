//
//  FalconUsersTableViewCell.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/8/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class FalconUsersTableViewCell: UITableViewCell {

  var icon: UIImageView = {
    var icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.contentMode = .scaleAspectFill
    
    icon.layer.cornerRadius = 22
    icon.layer.masksToBounds = true
    icon.image = UIImage(named: "UserpicIcon")
    
    return icon
  }()
  
  var title: UILabel = {
    var title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
    title.textColor = ThemeManager.currentTheme().generalTitleColor
    
    return title
  }()
  
  var subtitle: UILabel = {
    var subtitle = UILabel()
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    subtitle.font = UIFont.systemFont(ofSize: 13)
    subtitle.textColor = ThemeManager.currentTheme().generalSubtitleColor
    
    return subtitle
  }()

  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    title.backgroundColor = backgroundColor
    icon.backgroundColor = backgroundColor
    
    contentView.addSubview(icon)
    icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
    icon.widthAnchor.constraint(equalToConstant: 46).isActive = true
    icon.heightAnchor.constraint(equalToConstant: 46).isActive = true
    
    contentView.addSubview(title)
    title.topAnchor.constraint(equalTo: icon.topAnchor, constant: 0).isActive = true
    title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15).isActive = true
    title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    title.heightAnchor.constraint(equalToConstant: 23).isActive = true
    
    contentView.addSubview(subtitle)
    subtitle.bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 0).isActive = true
    subtitle.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15).isActive = true
    subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    subtitle.heightAnchor.constraint(equalToConstant: 23).isActive = true
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
   
    icon.image = UIImage(named: "UserpicIcon")
    title.text = ""
    subtitle.text = ""
    title.textColor = ThemeManager.currentTheme().generalTitleColor
    subtitle.textColor = ThemeManager.currentTheme().generalSubtitleColor
  }

}
