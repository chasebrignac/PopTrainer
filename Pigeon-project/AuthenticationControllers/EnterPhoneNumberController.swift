//
//  EnterPhoneNumberController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/2/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import FirebaseAuth
import SafariServices


class EnterPhoneNumberController: UIViewController {
  
  let phoneNumberContainerView = EnterPhoneNumberContainerView()
  let countries = Country().countries
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
      configurePhoneNumberContainerView()
      configureNavigationBar()
      setCountry()
    }
  
 fileprivate func configurePhoneNumberContainerView() {
    view.addSubview(phoneNumberContainerView)
    phoneNumberContainerView.frame = view.bounds
    phoneNumberContainerView.termsAndPrivacy.delegate = self
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
    let rightBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(rightBarButtonDidTap))
    self.navigationItem.rightBarButtonItem = rightBarButton
    self.navigationItem.rightBarButtonItem?.isEnabled = false
  }
  
  
  @objc func openCountryCodesList () {
    let picker = SelectCountryCodeController()
    picker.delegate = self
    navigationController?.pushViewController(picker, animated: true)
  }
  
  
  @objc func textFieldDidChange(_ textField: UITextField) {
      setRightBarButtonStatus()
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
    
    let destination = EnterVerificationCodeController()
    
    destination.enterVerificationContainerView.titleNumber.text = phoneNumberContainerView.countryCode.text! + phoneNumberContainerView.phoneNumber.text!
    
    navigationController?.pushViewController(destination, animated: true)
    
    if !isVerificationSent {
      sendSMSConfirmation()
    } else {
      print("verification has already been sent once")
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
      UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
    }
  }
}

extension EnterPhoneNumberController: CountryPickerDelegate {
  
  func countryPicker(_ picker: SelectCountryCodeController, didSelectCountryWithName name: String, code: String, dialCode: String) {
    phoneNumberContainerView.selectCountry.setTitle(name, for: .normal)
    phoneNumberContainerView.countryCode.text = dialCode
    setRightBarButtonStatus()
    picker.navigationController?.popViewController(animated: true)
  }
}

extension EnterPhoneNumberController : UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    let safariVC = SFSafariViewController(url: URL)
    present(safariVC, animated: true, completion: nil)
    
    return false
  }
}

