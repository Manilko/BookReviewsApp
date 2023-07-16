//
//  WebViewCoordinator.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//
import UIKit
import RxSwift

final class WebViewCoordinator: BaseCoordinator {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: WebViewViewModel!

    lazy var myViewController: WebViewController = {
        return WebViewController(viewModel: viewModel)
    }()

    // MARK: - Lifecycle
    init(router: Routable, url: String = "") {
        self.viewModel = WebViewViewModel()
        super.init()
        self.router = router
    }

    // MARK: - Actions
    override func start() {
    }
}

// MARK: - Extension Drawable
extension WebViewCoordinator : Drawable {
    var viewController: UIViewController? { return myViewController }
}

