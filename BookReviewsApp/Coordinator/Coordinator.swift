//
//  Coordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

protocol Coordinator : AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

