//
//  AppSchedulers.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import RxSwift

class AppSchedulers {
    let main: RxSwift.SchedulerType
    let network: RxSwift.SchedulerType
    let computation: RxSwift.SchedulerType

    init(main: RxSwift.SchedulerType, network: RxSwift.SchedulerType,
         computation: RxSwift.SchedulerType) {
        self.main = main
        self.network = network
        self.computation = computation
    }
}

