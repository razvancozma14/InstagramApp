//
//  InstagramApi.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import Moya

enum InstagramApi {
    case getMedia
    case getUserProfile
    case nextPage(url: URL)
}

extension InstagramApi: TargetType {
    var baseURL: URL {
        switch self {
        case .nextPage(let url):
            return url
        default:
            return URL(string: Constants.NetworkAPI.baseEndpoint)!
        }
    }
    
    var path: String {
        switch self {
        case .getMedia:
            return "/me/media"
        case .getUserProfile:
            return "/me"
        case .nextPage:
            return ""
        }
    }
    
    var method: Moya.Method { return .get }
    
    var sampleData: Data { return Data() }
    
    var task: Task {
        switch self {
        case .getMedia:
            let fields = "id,caption,media_type,media_url,timestamp,children{id,media_url}"
            return .requestParameters(parameters: ["fields" : fields,
                                                   "access_token" : Constants.NetworkAPI.accessToken,
                                                   "limit": 20],
                                       encoding: URLEncoding.queryString)
        case .getUserProfile:
            let fields = "username"
            return .requestParameters(parameters: ["fields" : fields,
                                                   "access_token" : Constants.NetworkAPI.accessToken],
                                       encoding: URLEncoding.default)
        case .nextPage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? { nil }
}
