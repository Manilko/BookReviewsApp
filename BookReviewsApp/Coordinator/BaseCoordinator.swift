//
//  BaseCoordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

enum MoveMethod {
    case push
    case present
    case pop
}

class BaseCoordinator : Coordinator {
    var router: Routable?
    var childCoordinators : [Coordinator] = []

    func start() {
        fatalError("Children should implement `start`.")
    }
}

extension BaseCoordinator {
    typealias CoordinatorDrawable = Coordinator & Drawable
    func move(to coordinator: CoordinatorDrawable, by method: MoveMethod, closure: (() -> Void)? = nil) {
        self.store(coordinator: coordinator)
        coordinator.start()

        switch method {
        case .push:
            self.router?.push(coordinator, isAnimated: true) { [weak self, weak coordinator] in
                guard let self = self, let coordinator = coordinator else { return }
                self.free(coordinator: coordinator)
                closure?()
            }
        case .present:
            self.router?.present(coordinator, isAnimated: true, presentetionType: .overFullScreen) { [weak self, weak coordinator] in
                guard let self = self, let coordinator = coordinator else { return }
                self.free(coordinator: coordinator)
            }
        case .pop:
            self.router?.pop(coordinator, true) { [weak self, weak coordinator] in
                guard let self = self, let coordinator = coordinator else { return }
                self.free(coordinator: coordinator)
            }
        }
    }
}


