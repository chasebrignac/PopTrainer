//
//  LegalTableViewController.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 11/9/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit
import SafariServices

class LegalTableViewController: UITableViewController {

  let cellData = ["Privacy Policy", "Terms And Conditions", "Open Source Libraries"]
  let legalData = ["https://docs.google.com/document/d/17VAUgX3ad3llmNoy1j5SvWPd6LycXXcc4SOWhxMwU2c/edit?usp=sharing", /*PRIVACY POLICY*/
    "https://docs.google.com/document/d/1x1dQpEoXcCIuSohhs1nFKZq-jNZQQxU5wg6VFo62vpY/edit?usp=sharing", /*TERMS AND CONDITIONS*/
    "https://docs.google.com/document/d/1X4Ng8XS-kXnToiBK4z6QI7ttLisEInFfiyupLxAcLjo/edit?usp=sharing" /*OPEN SOURCE LIBRARIES*/]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureController()
  }
  
  fileprivate func configureController() {
    title = "Legal"
    tableView = UITableView(frame: self.tableView.frame, style: .grouped)
    tableView.separatorStyle = .none
    extendedLayoutIncludesOpaqueBars = true
    view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    tableView.backgroundColor = view.backgroundColor
  }
  
  deinit {
    print("About DID DEINIT")
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let identifier = "cell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
    cell.backgroundColor = view.backgroundColor
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = cellData[indexPath.row]
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
    cell.textLabel?.textColor = ThemeManager.currentTheme().generalTitleColor
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let svc = SFSafariViewController(url: URL(string: legalData[indexPath.row])!)
    if #available(iOS 11.0, *) {
      svc.configuration.entersReaderIfAvailable = true
    }
    self.present(svc, animated: true, completion: nil)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 65
  }
}
