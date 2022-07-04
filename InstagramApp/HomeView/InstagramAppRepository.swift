//
//  InstagramAppRepository.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import RxSwift
import Kingfisher
import RxSwiftExt

class InstagramAppRepository {
    private let instagramAPIService: InstagramAPIService
    private let schedulers: AppSchedulers
    private var userProfile: UserProfile? = nil
    
    init(instagramAPIService: InstagramAPIService, schedulers: AppSchedulers) {
        self.instagramAPIService = instagramAPIService
        self.schedulers = schedulers
    }
    
    func requestData(nextPage: URL?) -> Observable<Result> {
        return Observable.zip(requestMedia(nextPage: nextPage), requestUserProfile())
            .map({InstagramResult.homeResult(result: $0.0, userProfile: $0.1, reloadData: nextPage == nil)})
            .catch { (error) -> Observable<Result> in
                return .just(InstagramResult.error(error: error))
            }
    }
    
    private func requestMedia(nextPage: URL?) -> Observable<MediaResponse> {
        return instagramAPIService.requestMedia(nextPage: nextPage).asObservable()
            .flatMap { [weak self] mediaResponse -> Observable<MediaResponse>  in
                guard let self = self else { return .just(mediaResponse) }
                return Observable.from(mediaResponse.data ?? []).flatMap { media -> Observable<Media> in
                    guard let url = URL(string: media.mediaUrl ?? "") else {
                        return .just(media)
                    }
                    return self.getImageSize(url: url).map { imageSize -> Media in
                        var newMedia = media
                        newMedia.imageRatio = imageSize.height / imageSize.width
                        return newMedia
                    }.catch { (error) -> Observable<Media> in
                        return .just(media)
                    }
                }.toArray().map { media in
                    return MediaResponse(data: media, paging: mediaResponse.paging)
                }.asObservable()
            }
    }
    
    private func requestUserProfile() -> Observable<UserProfile> {
        guard let profile = userProfile else {
            return instagramAPIService.requestUserProfile().asObservable()
                .observe(on: schedulers.computation)
                .do(onNext: {[weak self] profile in
                    self?.userProfile = profile
                })
        }
        return .just(profile)
    }
    
    func getImageSize(url: URL) -> Observable<CGSize> {
        return Observable.create { (observer) -> Disposable in
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: { response in
                switch response {
                case let .success(data):
                    observer.onNext(data.image.size)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
