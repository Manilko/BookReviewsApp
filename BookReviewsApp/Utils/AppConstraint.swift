//
//  AppConstraint.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import Foundation

struct AppConstraint {

    struct General {
        static let leading          : CGFloat = 24.0
        static let trailing         : CGFloat = -24.0
        static let smallLeading     : CGFloat = 16.0
        static let smallTrailing    : CGFloat = -16.0
        static let ten              : CGFloat = 10.0
        static let eight            : CGFloat = 8.0
    }

    struct Button {
        static let cornerRadius : CGFloat = 16.0
        static let basicHeight  : CGFloat = 48.0
        static let bigHeight    : CGFloat = 56.0
        static let smallHeight  : CGFloat = 24.0
    }
}
