//
//  ServicesAssembler.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import Foundation

protocol ServicesAssembler {
    func resolve() -> InstagramAppRepository
    func resolve() -> InstagramAPIService
}

extension ServicesAssembler where Self: Assembler {
    func resolve() -> InstagramAPIService {
        return InstagramAPIService(appSchedulers: resolve())
    }
    
    func resolve() -> InstagramAppRepository {
        return InstagramAppRepository(instagramAPIService: resolve(), schedulers: resolve())
    }
}

