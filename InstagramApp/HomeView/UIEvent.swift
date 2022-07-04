//
//  UIEvent.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import Foundation

protocol UIEvent {}

struct LoadHomeUIElements: UIEvent {
    let nextPage: URL?
    
    init(nextPage: URL? = nil) {
        self.nextPage = nextPage
    }
}
