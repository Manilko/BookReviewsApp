//
//  CategoryController.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class CategoryController: BaseViewController {

    // MARK: - Properties
    
    let viewModel: CategoryViewModel?
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = CategoriesView()
        
        guard let viewModel = viewModel else { return }
        AppLogger.log(level: .info, " internet connection isConnected ==>  \(isConnected)")
        viewModel.input.connectedObserver.onNext(isConnected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories of books".localized
        bind()
    }

    // MARK: Binding
    private func bind() {
        guard let viewModel = viewModel else { return }

        let dataSourse = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
            ds, tv, ip, item in
            self.view().castomTabeleView.register(CategoryCell.self, forCellReuseIdentifier: "SearchHistoryCell".localized)
            let cell: CategoryCell = self.view().castomTabeleView.dequeueReusableCell(withIdentifier: "SearchHistoryCell".localized, for: ip) as! CategoryCell
            cell.configure(with: item)
            return cell
        })

        viewModel.output.tabelViewItems.asObservable()
            .bind(to: view().castomTabeleView.rx.items(dataSource: dataSourse))
            .disposed(by: disposeBag)

        view().castomTabeleView.rx
            .modelSelected(Category.self)
            .subscribe(onNext: { categoryObject in
//                AppLogger.log(level: .debug, categoryObject.listName)
                viewModel.input.categoryObjectObserver.onNext(categoryObject.listName ?? "")
            }).disposed(by: disposeBag)
    }
}
// MARK: - ViewSeparatable
extension CategoryController: ViewSeparatable {
    typealias RootView = CategoriesView
}

