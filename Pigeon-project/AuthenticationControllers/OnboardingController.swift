//
//  OnboardingController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 8/2/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController {

  let onboardingContainerView = OnboardingContainerView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
      view.addSubview(onboardingContainerView)
      onboardingContainerView.frame = view.bounds
      setColorsAccordingToTheme()
    }
  
  fileprivate func setColorsAccordingToTheme() {
    let theme = ThemeManager.currentTheme()
    ThemeManager.applyTheme(theme: theme)
    view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    onboardingContainerView.backgroundColor = view.backgroundColor
  }
  
  
  @objc func startMessagingDidTap () {
    let destination = EnterPhoneNumberController()
    navigationController?.pushViewController(destination, animated: true)
  }

}
