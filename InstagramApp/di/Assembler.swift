//
//  Assembler.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import RxSwift

fileprivate var sharedInstances: [String : Any] = [:]

protocol Assembler: PresentationAssembler, ServicesAssembler {
    func resolve() -> AppSchedulers
}

class AppAssembler: Assembler {
    func resolve() -> AppSchedulers {
        let key = String(describing: AppSchedulers.self)
        if let instance = sharedInstances[key] as? AppSchedulers {
            return instance
        }
        
        let networkScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "network_serial_queue")
        let computationScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        let instance = AppSchedulers(main: MainScheduler.instance, network: networkScheduler, computation: computationScheduler)
        sharedInstances[key] = instance
        
        return instance
    }
}

