//
//  BookController.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class BookController: BaseViewController {

    // MARK: - Properties
    var viewModel: BookViewModel?
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    init(viewModel: BookViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    deinit {
        AppLogger.log(level: .debug, "____________BookController deinit")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = BookView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book list".localized

        bind()
    }
    // MARK: Binding
    private func bind() {
        guard let viewModel = viewModel else { return }

        let dataSourse = RxTableViewSectionedReloadDataSource<SectionBookModel>(configureCell: { [weak self]
            ds, tv, ip, item in
            guard let self = self else { return UITableViewCell() }
            self.view().booksTabele.register(BookCell.self, forCellReuseIdentifier: "HistoryCell".localized)
            let cell: BookCell = self.view().booksTabele.dequeueReusableCell(withIdentifier: "HistoryCell".localized, for: ip) as! BookCell
            cell.configure(with: item, closure: { urlObject in
                viewModel.input.bookObjectObservrr.onNext(urlObject)
            })
            return cell
        })

        viewModel.output.tabelViewItems.asObservable()
            .bind(to: view().booksTabele.rx.items(dataSource: dataSourse))
            .disposed(by: disposeBag)
    }
}
// MARK: - ViewSeparatable
extension BookController: ViewSeparatable {
    typealias RootView = BookView
}



