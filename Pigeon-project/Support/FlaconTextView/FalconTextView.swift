//
//  FalconTextView.swift
//  Pigeon-project
//
//  Created by Chase Brignac after 12/11/17.
//  Copyright © 2018 Chase Brignac. All rights reserved.
//

import UIKit

class FalconTextView: UITextView {
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let pos = closestPosition(to: point) else { return false }
    guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextLayoutDirection.left.rawValue) else { return false }
    let startIndex = offset(from: beginningOfDocument, to: range.start)
    
    return attributedText.attribute(NSAttributedStringKey.link, at: startIndex, effectiveRange: nil) != nil
  }
}
