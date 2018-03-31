//
//  CreateProfileController+keyboardHandlers.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/4/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit


extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
