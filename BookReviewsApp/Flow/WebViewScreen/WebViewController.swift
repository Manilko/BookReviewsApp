//
//  WebViewController.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties
    var viewModel: WebViewViewModel?
    private let disposeBag = DisposeBag()
    private var webView: WKWebView!

    var urlString = ""

    // MARK: - Lifecycle
    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
           webView = WKWebView()
           webView.navigationDelegate = self
           view = self.webView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        guard let url = URL(string: urlString) else { return }
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true

    }

}

