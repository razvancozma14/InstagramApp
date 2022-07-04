//
//  MediaResponse.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import Foundation

struct MediaResponse: Decodable {
    let data: [Media]?
    var paging: Paging?
    
    init(data: [Media], paging: Paging?) {
        self.data = data
        self.paging = paging
    }
}

extension MediaResponse {
    struct Paging: Decodable {
        let previous: String?
        var next: String?
    }
}
