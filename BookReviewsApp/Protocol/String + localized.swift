//
//  String + localized.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation

extension String {
  var localized : String {
    return NSLocalizedString(self, comment: "")
  }

  func localized(with variable: CVarArg) -> String {
    return String.localizedStringWithFormat(NSLocalizedString(self, comment: ""), variable)
  }
}
