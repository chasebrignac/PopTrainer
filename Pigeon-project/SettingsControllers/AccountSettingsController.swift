//
//  AccountSettingsController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/5/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import Firebase


class AccountSettingsController: UITableViewController {

  let userProfileContainerView = UserProfileContainerView()
  let userProfilePictureOpener = UserProfilePictureOpener()
  
  let accountSettingsCellId = "userProfileCell"

  var firstSection = [( icon: UIImage(named: "Notification") , title: "Notifications and sounds" ),
                      ( icon: UIImage(named: "ChangeNumber") , title: "Change number"),
                      ( icon: UIImage(named: "Storage") , title: "Data and storage")]
  
  var secondSection = [( icon: UIImage(named: "Legal") , title: "Legal"),
                       ( icon: UIImage(named: "Logout") , title: "Log out")]
  
  let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonPressed))
  let doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(doneBarButtonPressed))
  
  var currentName = String()
  var currentBio = String()
  
  override func viewDidLoad() {
     super.viewDidLoad()
    
    title = "Settings"
    extendedLayoutIncludesOpaqueBars = true
    edgesForExtendedLayout = UIRectEdge.top
    tableView = UITableView(frame: tableView.frame, style: .grouped)
    NotificationCenter.default.addObserver(self, selector:#selector(clearUserData),name:NSNotification.Name(rawValue: "clearUserData"), object: nil)
    
    configureTableView()
    configureContainerView()
    listenChanges()
    configureNavigationBarDefaultRightBarButton()
    setColorAccordingToTheme()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if userProfileContainerView.phone.text == "" {
      listenChanges()
    }
  }
  
  fileprivate func managePhotoPlaceholderLabelAppearance() {
    DispatchQueue.main.async {
      if self.userProfileContainerView.profileImageView.image != nil {
        self.userProfileContainerView.addPhotoLabel.isHidden = true
      } else {
        self.userProfileContainerView.addPhotoLabel.isHidden = false
      }
    }
  }
  
  func configureNavigationBarDefaultRightBarButton () {
    
    let nightMode = UIButton()
    nightMode.setImage(UIImage(named: "defaultTheme"), for: .normal)
    nightMode.setImage(UIImage(named: "darkTheme"), for: .selected)
    nightMode.imageView?.contentMode = .scaleAspectFit
    nightMode.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    nightMode.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    nightMode.addTarget(self, action: #selector(rightBarButtonDidTap(sender:)), for: .touchUpInside)
    nightMode.isSelected = Bool(ThemeManager.currentTheme().rawValue)
    
    let rightBarButton = UIBarButtonItem(customView: nightMode)
    self.navigationItem.setRightBarButton(rightBarButton, animated: false)
  }
  
  @objc fileprivate func rightBarButtonDidTap(sender: UIButton) {
  
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      let theme = Theme.Dark
      ThemeManager.applyTheme(theme: theme)
    } else {
      let theme = Theme.Default
      ThemeManager.applyTheme(theme: theme)
    }
    shouldReloadChatsControllerAfterChangingTheme = true
    shouldReloadContactsControllerAfterChangingTheme = true
    setColorAccordingToTheme()
    tableView.reloadData()
  }
  
  fileprivate func setColorAccordingToTheme() {
      view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
      tableView.backgroundColor = view.backgroundColor
      userProfileContainerView.backgroundColor = view.backgroundColor
      navigationController?.navigationBar.barStyle = ThemeManager.currentTheme().barStyle
      navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().barBackgroundColor
      tabBarController?.tabBar.barTintColor = ThemeManager.currentTheme().barBackgroundColor
      tabBarController?.tabBar.barStyle = ThemeManager.currentTheme().barStyle
      tableView.indicatorStyle = ThemeManager.currentTheme().scrollBarStyle
      userProfileContainerView.profileImageView.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
      userProfileContainerView.userData.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
      userProfileContainerView.name.textColor = ThemeManager.currentTheme().generalTitleColor
      userProfileContainerView.bio.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
      userProfileContainerView.bio.textColor = ThemeManager.currentTheme().generalTitleColor
      userProfileContainerView.bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
      userProfileContainerView.name.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
  }
  
  @objc func clearUserData() {
    userProfileContainerView.name.text = ""
    userProfileContainerView.phone.text = ""
    userProfileContainerView.profileImageView.image = nil
  }
  
  func listenChanges() {
    
    if let currentUser = Auth.auth().currentUser?.uid {
      
      let photoURLReference = Database.database().reference().child("users").child(currentUser).child("photoURL")
      photoURLReference.observe(.value, with: { (snapshot) in
        if let url = snapshot.value as? String {
          self.userProfileContainerView.profileImageView.sd_setImage(with: URL(string: url) , placeholderImage: nil, options: [.highPriority, .continueInBackground], completed: {(image, error, cacheType, url) in
            if error != nil {
              //basicErrorAlertWith(title: "Error loading profile picture", message: "It seems like you are not connected to the internet.", controller: self)
            }
             self.managePhotoPlaceholderLabelAppearance()
          })
        }
      })
      
      let nameReference = Database.database().reference().child("users").child(currentUser).child("name")
      nameReference.observe(.value, with: { (snapshot) in
        if let name = snapshot.value as? String {
          self.userProfileContainerView.name.text = name
          self.currentName = name
        }
      })
      
      let bioReference = Database.database().reference().child("users").child(currentUser).child("bio")
      bioReference.observe(.value, with: { (snapshot) in
        if let bio = snapshot.value as? String {
          self.userProfileContainerView.bio.text = bio
          self.userProfileContainerView.bioPlaceholderLabel.isHidden = !self.userProfileContainerView.bio.text.isEmpty
          self.currentBio = bio
        }
      })
      
      let phoneNumberReference = Database.database().reference().child("users").child(currentUser).child("phoneNumber")
      phoneNumberReference.observe(.value, with: { (snapshot) in
        if let phoneNumber = snapshot.value as? String {
          self.userProfileContainerView.phone.text = phoneNumber
        }
      })
    }
  }

  fileprivate func configureTableView() {
    tableView.separatorStyle = .none
    tableView.indicatorStyle = ThemeManager.currentTheme().scrollBarStyle
    tableView.tableHeaderView = userProfileContainerView
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(AccountSettingsTableViewCell.self, forCellReuseIdentifier: accountSettingsCellId)
  }
  
  fileprivate func configureContainerView() {
    
    userProfileContainerView.name.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingDidBegin)
    userProfileContainerView.name.addTarget(self, action: #selector(nameEditingChanged), for: .editingChanged)
    userProfileContainerView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfilePicture)))
    userProfileContainerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250)
    userProfileContainerView.bio.delegate = self
    userProfileContainerView.name.delegate = self
  }
  
  @objc fileprivate func openUserProfilePicture() {
    
    userProfilePictureOpener.userProfileContainerView = userProfileContainerView
    userProfilePictureOpener.controllerWithUserProfilePhoto = self
    cancelBarButtonPressed()
    userProfilePictureOpener.openUserProfilePicture()
  }
  
  func logoutButtonTapped () {
  
    let firebaseAuth = Auth.auth()
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard currentReachabilityStatus != .notReachable else {
      basicErrorAlertWith(title: "Error signing out", message: noInternetError, controller: self)
      return
      
    }
    ARSLineProgress.ars_showOnView(self.tableView)
  
    let userReference = Database.database().reference().child("users").child(uid).child("notificationTokens")
    userReference.removeValue { (error, reference) in
      
      if error != nil {
        ARSLineProgress.hide()
        basicErrorAlertWith(title: "Error signing out", message: "Try again later", controller: self)
        return
      }
      
      let onlineStatusReference = Database.database().reference().child("users").child(uid).child("OnlineStatus")
      onlineStatusReference.setValue(ServerValue.timestamp())
      
      do {
        try firebaseAuth.signOut()
        
      } catch let signOutError as NSError {
        ARSLineProgress.hide()
        basicErrorAlertWith(title: "Error signing out", message: signOutError.localizedDescription, controller: self)
        return
      }
      AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
      UIApplication.shared.applicationIconBadgeNumber = 0
      
      let destination = OnboardingController()
      
      let newNavigationController = UINavigationController(rootViewController: destination)
      newNavigationController.navigationBar.shadowImage = UIImage()
      newNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
      
      newNavigationController.navigationBar.isTranslucent = false
      newNavigationController.modalTransitionStyle = .crossDissolve
      ARSLineProgress.hide()
      self.present(newNavigationController, animated: true, completion: {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearUserData"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearContacts"), object: nil)
        
        self.tabBarController?.selectedIndex = tabs.chats.rawValue
        
      })
    }
  }
}

extension AccountSettingsController {
  
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: accountSettingsCellId, for: indexPath) as! AccountSettingsTableViewCell
    cell.accessoryType = .disclosureIndicator
  
    if indexPath.section == 0 {
      
      cell.icon.image = firstSection[indexPath.row].icon
      cell.title.text = firstSection[indexPath.row].title
    }
    
    if indexPath.section == 1 {
      
      cell.icon.image = secondSection[indexPath.row].icon
      cell.title.text = secondSection[indexPath.row].title
      
      if indexPath.row == 1 {
        cell.accessoryType = .none
      }
    }
    return cell
  }
  
 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == 0 {
      
      if indexPath.row == 0 {
        let destination = NotificationsAndSoundsTableViewController()
        destination.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destination, animated: true)
      }
      
      if indexPath.row == 1 {
         AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let destination = UINavigationController(rootViewController: ChangeNumberEnterPhoneNumberController())
      //  destination.navigationBar.barStyle = .default
        destination.hidesBottomBarWhenPushed = true
        destination.navigationBar.isTranslucent = false
        self.present(destination, animated: true, completion: nil)
      }
      
      if indexPath.row == 2 {
        let destination = StorageTableViewController()
        destination.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destination, animated: true)
      }
    }
      
      if indexPath.section == 1 {
        
        if indexPath.row == 0 {
          let destination = LegalTableViewController()
          destination.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(destination, animated: true)
        }
        
        if indexPath.row == 1 {
          logoutButtonTapped()
        }
      }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
   return 2
  }
  
  override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return firstSection.count
    }
    if section == 1 {
      return secondSection.count
    } else {
      
      return 0
    }
  }
}
