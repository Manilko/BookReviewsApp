//
//  ViewSeparatable.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit

protocol ViewSeparatable {
    associatedtype RootView: UIView
}

extension ViewSeparatable where Self: UIViewController {
    func view() -> RootView {
        guard let view = self.view as? RootView else {
            return RootView()
        }
        return view
    }
}

