//
//  InstagramAPIService.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import Foundation

import RxSwift
import Moya

class InstagramAPIService {
    
    private let endpoint: MoyaProvider<InstagramApi>
    private let appSchedulers: AppSchedulers
    private lazy var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    init(appSchedulers: AppSchedulers) {
        self.appSchedulers = appSchedulers
        self.endpoint = MoyaProvider<InstagramApi>()
    }
    
    func requestMedia(nextPage: URL?) -> Single<MediaResponse>{
        let jsonDecoder = decoder
        return endpoint.rx.request(nextPage == nil ? .getMedia : .nextPage(url: nextPage!))
            .subscribe(on: appSchedulers.network)
            .observe(on: appSchedulers.computation)
            .catch({ (error) -> PrimitiveSequence<SingleTrait, Response> in
                throw CoreError.network(statusCode: -1)
            })
            .map { (response) -> MediaResponse in
                guard response.statusCode == 200 && !response.data.isEmpty else {
                    throw CoreError.network(statusCode: response.statusCode)
                }
                do {
                    return try jsonDecoder.decode(MediaResponse.self, from: response.data)
                } catch (let error) {
                    throw CoreError.decodingResponse(error: error)
                }
        }
    }
    
    func requestUserProfile() -> Single<UserProfile>{
        let jsonDecoder = decoder
        return endpoint.rx.request(.getUserProfile)
            .subscribe(on: appSchedulers.network)
            .observe(on: appSchedulers.computation)
            .catch({ (error) -> PrimitiveSequence<SingleTrait, Response> in
                throw CoreError.network(statusCode: -1)
            })
            .map { (response) -> UserProfile in
                guard response.statusCode == 200 && !response.data.isEmpty else {
                    throw CoreError.network(statusCode: response.statusCode)
                }
                do {
                    return try jsonDecoder.decode(UserProfile.self, from: response.data)
                } catch (let error) {
                    throw CoreError.decodingResponse(error: error)
                }
        }
    }
}

