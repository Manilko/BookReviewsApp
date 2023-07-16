//
//  BookViewModel.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import RxSwift
import RxCocoa
import RealmSwift

final class BookViewModel {

    // MARK: - Properties
    let input: Input
    let output: Output

    // MARK: - Input
    struct Input {
        let bookObjectObservrr: AnyObserver<String>
    }

    // MARK: - Output
    struct Output {
        let bookObjectObservable: Observable<String>
        var tabelViewItems: BehaviorRelay<[SectionBookModel]>
    }

    // MARK: - Private Properties
    private let service: BookAPIProtocol = APIService()
    private let bookObjectSubect = PublishSubject<String>()
    private var tabelViewItemsSectioned: BehaviorRelay<[SectionBookModel]> = BehaviorRelay.init(value: [])

    init(category: String) {

        self.input = Input( bookObjectObservrr: bookObjectSubect.asObserver())

        self.output = Output( bookObjectObservable: bookObjectSubect,
                              tabelViewItems: tabelViewItemsSectioned )

        Task {
            do {
                let category = try await service.fetchBook(with: category)
                tabelViewItemsSectioned.accept([SectionBookModel(hesder: "", items: Array(category?.results ?? List<Book>()))])
                AppLogger.log(level: .info, "downloaded: \(String(describing: category?.results.count)) category")
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
    }
}


