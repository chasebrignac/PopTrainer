//
//  ChangeNumberEnterPhoneNumberController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/2/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import FirebaseAuth


class ChangeNumberEnterPhoneNumberController: UIViewController {
  
    let phoneNumberContainerView = ChangeNumberEnterPhoneNumberContainerView()
    let countries = Country().countries
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      configurePhoneNumberContainerView()
      configureNavigationBar()
      setCountry()
    }
  
    fileprivate func configurePhoneNumberContainerView() {
      view.addSubview(phoneNumberContainerView)
      phoneNumberContainerView.frame = view.bounds
    }
  
    fileprivate func setCountry() {
      for country in countries {
        if  country["code"] == countryCode {
          phoneNumberContainerView.countryCode.text = country["dial_code"]
          phoneNumberContainerView.selectCountry.setTitle(country["name"], for: .normal)
        }
      }
    }
  
    fileprivate func configureNavigationBar () {
      
      let leftBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(leftBarButtonDidTap))
      navigationItem.leftBarButtonItem = leftBarButton
    
      
      let rightBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(rightBarButtonDidTap))
      navigationItem.rightBarButtonItem = rightBarButton
      navigationItem.rightBarButtonItem?.isEnabled = false
    
      if #available(iOS 11.0, *) {
        self.navigationItem.largeTitleDisplayMode = .never
      }
    }
  
    @objc func openCountryCodesList () {
      let picker = ChangeNumberSelectCountryCodeController()
      picker.delegate = self
      navigationController?.pushViewController(picker, animated: true)
    }
  
    @objc func textFieldDidChange(_ textField: UITextField) {
      setRightBarButtonStatus()
    }
  
    @objc func leftBarButtonDidTap() {
      phoneNumberContainerView.phoneNumber.resignFirstResponder()
      self.dismiss(animated: true) {
         AppUtility.lockOrientation(.allButUpsideDown)
      }
    }
  
    func setRightBarButtonStatus() {
      if phoneNumberContainerView.phoneNumber.text!.count < 9 || phoneNumberContainerView.countryCode.text == " - " {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      } else {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      }
    }

  
    var isVerificationSent = false
  
    @objc func rightBarButtonDidTap () {
      
      if currentReachabilityStatus == .notReachable {
        basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
        return
      }
    
      let destination = ChangeNumberEnterVerificationCodeController()
    
      destination.enterVerificationContainerView.titleNumber.text = phoneNumberContainerView.countryCode.text! + phoneNumberContainerView.phoneNumber.text!
    
      navigationController?.pushViewController(destination, animated: true)
    
      if !isVerificationSent {
        sendSMSConfirmation()
      }
  }
  
  
  func sendSMSConfirmation () {
    
    print("tappped sms confirmation")
    
    let phoneNumberForVerification = phoneNumberContainerView.countryCode.text! + phoneNumberContainerView.phoneNumber.text!
    
    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberForVerification, uiDelegate: nil) { (verificationID, error) in
      if let error = error {
        basicErrorAlertWith(title: "Error", message: error.localizedDescription + "\nPlease try again later.", controller: self)
        return
      }
      
      print("verification sent")
      self.isVerificationSent = true
      UserDefaults.standard.set(verificationID, forKey: "ChangeNumberAuthVerificationID")
    }
  }
}

extension ChangeNumberEnterPhoneNumberController: ChangeNumberCountryPickerDelegate {
  
  func countryPicker(_ picker: ChangeNumberSelectCountryCodeController, didSelectCountryWithName name: String, code: String, dialCode: String) {
    phoneNumberContainerView.selectCountry.setTitle(name, for: .normal)
    phoneNumberContainerView.countryCode.text = dialCode
    setRightBarButtonStatus()
    picker.navigationController?.popViewController(animated: true)
  }
}
