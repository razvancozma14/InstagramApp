//
//  InstagramResult.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import Foundation

protocol Result {}

enum InstagramResult: Result {
    case homeResult(result: MediaResponse, userProfile: UserProfile, reloadData: Bool)
    case showLoading
    case error(error: Error?)
}

enum CoreError: Swift.Error {
    case network(statusCode: Int)
    case decodingResponse(error: Swift.Error)
}
