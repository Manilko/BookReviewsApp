//
//  CategoryViewModel.swift
//  BookReviewsApp
//
//  Created by Yevhenii Manilko on 10.07.2023.
//

import RxSwift
import RxCocoa
import RealmSwift

final class CategoryViewModel {
    // MARK: - Properties
    let input: Input
    let output: Output
    private let disposeBag = DisposeBag()

    // MARK: - Input
    struct Input {
        let categoryObjectObserver: AnyObserver<String>
        let connectedObserver: AnyObserver<Bool>
    }

    // MARK: - Output
    struct Output {
        let categoryObjectObservable: Observable<String>
        var tabelViewItems: BehaviorRelay<[SectionModel]>
    }

    // MARK: - Private Properties
    private let service: CategoryAPIProtocol = APIService()
    private let categoryObjectSubect = PublishSubject<String>()
    private let isConnectedSubect = PublishSubject<Bool>()
    private var tabelViewItemsSectioned: BehaviorRelay<[SectionModel]> = BehaviorRelay.init(value: [])

    init() {
        let objects = RealmManager.shared.getObjects(CategorysData.self)

        self.input = Input( categoryObjectObserver: categoryObjectSubect.asObserver(),
                            connectedObserver: isConnectedSubect.asObserver())

        self.output = Output( categoryObjectObservable: categoryObjectSubect,
                              tabelViewItems: tabelViewItemsSectioned )
        
        isConnectedSubect.subscribe { [self] connected in
            
            switch connected {
            case .next(true):
                Task {
                    do {
                        let category = try await service.fetchCategory()
                        
                        guard let category = category else { return }
                        AppLogger.log(level: .info, "downloaded: \(String(describing: category.results.count)) category")
                        tabelViewItemsSectioned.accept([SectionModel(hesder: "", items: Array(category.results) )])
                        
                        DispatchQueue.main.async {
                            if objects.isEmpty{
                                AppLogger.log(level: .info, "category added to Database")
                                RealmManager.shared.add(category, update: true)
                            } else{
                                AppLogger.log(level: .info, "Database doesn't Empty")
                            }
                        }
                        
                    } catch {
                        AppLogger.log(level: .error, error)
                    }
                }
            case .next(false):
                AppLogger.log(level: .info, "no internet connection")
                guard !objects.isEmpty else {
                    tabelViewItemsSectioned.accept([SectionModel(hesder: "", items: [])])   // mock some data
                    return
                }
                tabelViewItemsSectioned.accept([SectionModel(hesder: "", items: Array( _immutableCocoaArray: objects.first?.results ?? List<Category>()) )])
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
}

