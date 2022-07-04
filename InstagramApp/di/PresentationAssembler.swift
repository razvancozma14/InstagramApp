//
//  PresentationAssembler.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import Foundation


protocol PresentationAssembler {
    func resolve() -> HomeViewModel
    func resolve() -> HomeviewControlller
}

extension PresentationAssembler where Self: Assembler {
    
    func resolve() -> HomeViewModel{
        return HomeViewModel(shopRepository: resolve(), schedulers: resolve())
    }
    
    func resolve() -> HomeviewControlller{
        return HomeviewControlller(viewModel: resolve())
    }
}
