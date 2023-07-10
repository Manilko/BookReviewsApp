//
//  CategoryCoordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit
import RxSwift

final class CategoryCoordinator: BaseCoordinator {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let viewModel: CategoryViewModel!

    lazy var myViewController: CategoryController = {
        return CategoryController(viewModel: viewModel)
    }()

    // MARK: - Lifecycle
    init(router: Routable, viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init()
        self.router = router
    }

    // MARK: - Actions
    override func start() {
        goToBookScreen()
    }
}

// MARK: - Extension Drawable
extension CategoryCoordinator : Drawable {
    var viewController: UIViewController? { return myViewController }
}

// MARK: - Private Extensions
private extension CategoryCoordinator {
    func goToBookScreen() {
        myViewController.viewModel?.output.categoryObjectObservable
            .subscribe(onNext: { [weak self, weak router] categoryName in
                guard let self = self, let router = router else { return }
                let coordinator = BookCoordinator(router: router, category: categoryName)
                self.move(to: coordinator, by: .push)
            })
            .disposed(by: self.disposeBag)
    }
}


