//
//  Media.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import UIKit

struct Media: Decodable {
    let id: String?
    let mediaType: MediaType?
    let mediaUrl: String?
    let caption: String?
    let timestamp: Date?
    let children: MediaResponse?
    var imageRatio: CGFloat?
    var imageUrl: URL? {
        return URL(string: mediaUrl ?? "")
    }
}

extension Media {
    enum MediaType: String, Decodable {
        case carouselAlbum = "CAROUSEL_ALBUM"
        case image = "IMAGE"
    }

}
