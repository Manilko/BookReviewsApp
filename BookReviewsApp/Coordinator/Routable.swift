//
//  Routable.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var viewcontrollers = viewControllers
        viewcontrollers[viewcontrollers.count - 1] = viewController
        setViewControllers(viewcontrollers, animated: animated)
    }
}

typealias NavigationBackClosure = (() -> Void)

protocol Routable: AnyObject {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func present(_ drawable: Drawable, isAnimated: Bool, presentetionType: UIModalPresentationStyle, onDismissed closure: NavigationBackClosure?)
    func pop(_ drawable: Drawable, _ isAnimated: Bool, onDismissed closure: NavigationBackClosure?)

}


