//
//  Router.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit

final class Router: NSObject, Routable {

    let navigationController: UINavigationController
    private var closures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    public func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: isAnimated)
    }

    public func present(_ drawable: Drawable, isAnimated: Bool, presentetionType: UIModalPresentationStyle = .fullScreen, onDismissed closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }

        navigationController.present(viewController, animated: isAnimated)
    }

    public func pop(_ drawable: Drawable, _ isAnimated: Bool, onDismissed closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }

        navigationController.popViewController(animated: isAnimated)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(previousController)
    }
}



