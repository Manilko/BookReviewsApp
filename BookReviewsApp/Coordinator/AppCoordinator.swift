//
//  AppCoordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit

final class AppCoordinator : BaseCoordinator {

    // MARK: - Properties
    private let window : UIWindow

    // MARK: - Lifecycle
    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    // MARK: - Actions
    override func start() {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        start(with: router)
    }

    private func start(with router: Router) {
        startWithMainMenu(with: router)
    }
}

// MARK: - AppCoordinator start points
extension AppCoordinator {
    private func startWithMainMenu(with router: Router) {
        let viewModel = CategoryViewModel()
        let coordinator = CategoryCoordinator(router: router, viewModel: viewModel)
        self.store(coordinator: coordinator)
        coordinator.start()
        router.push(coordinator, isAnimated: true) { [weak self, weak coordinator] in
            guard let self = self,
                  let mainMenuCoordinator = coordinator else { return }
            self.free(coordinator: mainMenuCoordinator)
        }
    }

    func dismissAnyAlertControllerIfPresent() {
        guard let window: UIWindow = UIApplication.shared.keyWindow,
                var topVC = window.rootViewController?.presentedViewController else { return }

        while let top = topVC.presentedViewController {
            topVC = top
        }

        if topVC.isKind(of: UIAlertController.self) {
            topVC.dismiss(animated: false, completion: nil)
        }
    }
}


