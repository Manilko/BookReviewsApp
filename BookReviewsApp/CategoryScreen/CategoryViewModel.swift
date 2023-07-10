//
//  CategoryViewModel.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import RxSwift
import RxCocoa

final class CategoryViewModel {
    // MARK: - Properties
    let input: Input
    let output: Output

    // MARK: - Input
    struct Input {
        let categoryObjectObservr: AnyObserver<String>
    }

    // MARK: - Output
    struct Output {
        let categoryObjectObservable: Observable<String>
        var tabelViewItems: BehaviorRelay<[SectionModel]>
    }

    // MARK: - Private Properties
    private let service: CategoryAPIProtocol = APIService()
    private let categoryObjectSubect = PublishSubject<String>()
    private var tabelViewItemsSectioned: BehaviorRelay<[SectionModel]> = BehaviorRelay.init(value: [])

    init() {

        self.input = Input( categoryObjectObservr: categoryObjectSubect.asObserver())

        self.output = Output( categoryObjectObservable: categoryObjectSubect,
                              tabelViewItems: tabelViewItemsSectioned )

        Task {
            do {
                let category = try await service.fetchCategory()
                tabelViewItemsSectioned.accept([SectionModel(hesder: "", items: category?.results ?? [])])
                AppLogger.log(level: .info, "downloaded: \(String(describing: category?.results.count)) category")
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
    }
}

