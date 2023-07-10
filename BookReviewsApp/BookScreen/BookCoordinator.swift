//
//  BookCoordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//
import UIKit
import RxSwift

final class BookCoordinator: BaseCoordinator {

    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: BookViewModel!

    lazy var myViewController: BookController = {
        return BookController(viewModel: viewModel)
    }()

    // MARK: - Lifecycle
    init(router: Routable, category: String) {
        self.viewModel = BookViewModel(category: category)
        super.init()
        self.router = router
    }

    // MARK: - Actions
    override func start() {
        goToWebViewScreen()
    }
}

// MARK: - Extension Drawable
extension BookCoordinator : Drawable {
    var viewController: UIViewController? { return myViewController }
}

// MARK: - Private Extension
private extension BookCoordinator {
    func goToWebViewScreen() {
        myViewController.viewModel?.output.bookObjectObservable
            .subscribe(onNext: { [weak self, weak router] urlString in
                guard let self = self, let router = router else { return }
                let coordinator = WebViewCoordinator(router: router, url: urlString)
                coordinator.myViewController.urlString = urlString
                self.move(to: coordinator, by: .push)
            })
            .disposed(by: self.disposeBag)
    }

}



