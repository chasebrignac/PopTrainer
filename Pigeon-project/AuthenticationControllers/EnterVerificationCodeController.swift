//
//  EnterVerificationCodeController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/2/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import FirebaseAuth


class EnterVerificationCodeController: UIViewController {

  let enterVerificationContainerView = EnterVerificationContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
      view.addSubview(enterVerificationContainerView)
      enterVerificationContainerView.frame = view.bounds
      enterVerificationContainerView.resend.addTarget(self, action: #selector(sendSMSConfirmation), for: .touchUpInside)
      enterVerificationContainerView.enterVerificationCodeController = self
      configureNavigationBar()
  }
  

  fileprivate func configureNavigationBar () {
    let rightBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(rightBarButtonDidTap))
    self.navigationItem.rightBarButtonItem = rightBarButton
    self.navigationItem.hidesBackButton = true
  }
  
  
  @objc fileprivate func sendSMSConfirmation () {
    
    if currentReachabilityStatus == .notReachable {
      basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
      return
    }
    
    enterVerificationContainerView.resend.isEnabled = false
    print("tappped sms confirmation")
    
    let phoneNumberForVerification = enterVerificationContainerView.titleNumber.text!
    
    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberForVerification, uiDelegate: nil) { (verificationID, error) in
      if let error = error {
        basicErrorAlertWith(title: "Error", message: error.localizedDescription + "\nPlease try again later.", controller: self)
       
        return
      }
      
      print("verification sent")
      self.enterVerificationContainerView.resend.isEnabled = false
      
      UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
      self.enterVerificationContainerView.runTimer()
    }
  }
  
  @objc func rightBarButtonDidTap () {
    print("tapped")
    enterVerificationContainerView.verificationCode.resignFirstResponder()
    if currentReachabilityStatus == .notReachable {
      basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
      return
    }
   
   
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let verificationCode = enterVerificationContainerView.verificationCode.text

    if verificationID == nil {
      ARSLineProgress.showFail()
      self.enterVerificationContainerView.verificationCode.shake()
      return
    }
    
    if currentReachabilityStatus == .notReachable {
      basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
    }
    
     ARSLineProgress.ars_showOnView(self.view)
    
      let credential = PhoneAuthProvider.provider().credential (
        withVerificationID: verificationID!,
        verificationCode: verificationCode!)
      
      Auth.auth().signIn(with: credential) { (user, error) in
        
        if error != nil {
          ARSLineProgress.hide()
          basicErrorAlertWith(title: "Error", message: error?.localizedDescription ?? "Oops! Something happened, try again later.", controller: self)
          return
        }
      
        let destination = UserProfileController()
        AppUtility.lockOrientation(.portrait)
        destination.userProfileContainerView.phone.text = self.enterVerificationContainerView.titleNumber.text
        destination.checkIfUserDataExists(completionHandler: { (isCompleted) in
          if isCompleted {
            ARSLineProgress.hide()
            if self.navigationController != nil {
              if !(self.navigationController!.topViewController!.isKind(of: UserProfileController.self)) {
                self.navigationController?.pushViewController(destination, animated: true)
              }
            }
            print("code is correct")
          }
        })
      }
  }
}
