//
//  HomeViewModel.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import RxSwiftExt
import RxSwift
import RxCocoa

class HomeViewModel {
    public enum HomeError {
        case internetError(String)
    }
    
    let homeUIItems = BehaviorRelay<[HomeUIElement]>(value: [])
    let uiEvents: PublishSubject<UIEvent> = PublishSubject<UIEvent>()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<HomeError> = PublishSubject()
    
    private let shopRepository: InstagramAppRepository
    private let schedulers: AppSchedulers
    private let disposable = DisposeBag()
    private var currentResponse: MediaResponse? = nil
    
    init(shopRepository: InstagramAppRepository, schedulers: AppSchedulers) {
        self.schedulers = schedulers
        self.shopRepository = shopRepository
    }
    
    func requestData() {
        uiEvents.ofType(LoadHomeUIElements.self)
            .startWith(LoadHomeUIElements())
            .do(onNext: { [weak self] (event) in
                self?.loading.onNext(true)
            })
            .observe(on: schedulers.computation)
            .flatMapLatest { [weak self] event -> Observable<Result> in
                guard let self = self else {
                    return Observable.just(InstagramResult.error(error: nil))
                }
                return self.shopRepository.requestData(nextPage: event.nextPage)
            }
            .observe(on: schedulers.computation)
            .do(onNext: { [weak self] (result) in
                guard let self = self else { return }
                self.loading.onNext(false)
                switch result {
                case InstagramResult.homeResult(let mediaResponse, let user, let reloadData):
                    let newElements = (mediaResponse.data ?? []).map { HomeUIElement(media: $0, userName: user.username) }
                    let elements = (reloadData ? [] : self.homeUIItems.value) +  newElements
                    self.homeUIItems.accept(elements.sorted(by: {$0.media?.timestamp ?? Date() > $1.media?.timestamp ?? Date()}))
                    self.currentResponse = mediaResponse
                case InstagramResult.error(let error):
                    print(error)
                    self.error.onNext(.internetError("Something went wrong"))
                default: break
                }
            })
            .subscribe()
            .disposed(by: disposable)
    }
    
    func retry(){
        uiEvents.onNext(LoadHomeUIElements())
    }
    
    func loadNextPage() {
        guard let nextPage = currentResponse?.paging?.next, let url = URL(string: nextPage) else {
            return
        }
        uiEvents.onNext(LoadHomeUIElements(nextPage: url))
    }
}
