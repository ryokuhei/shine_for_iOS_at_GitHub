//
//  DetailUseCase.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailUseCase {
    
    func getUserDetail(by key: String) ->Single<UserModel>
    func loadUserIcon(of fileName: String) ->Single<Data>
}

class DetailUseCaseImpl: BaseUseCase, DetailUseCase {

    let user: UserRepository
    let icon: IconRepository
    let translator: UserTranslator

    init(user: UserRepository, icon: IconRepository, translator: UserTranslator) {
        self.user = user
        self.icon = icon
        self.translator = translator
    }
    
    func getUserDetail(by key: String) ->Single<UserModel> {
        return self.user.getUser(by: key)
            .map {
              [unowned self] (user) ->UserModel in
                self.translator.translate(entity: user)
            }
    }
    
    func loadUserIcon(of fileName: String) ->Single<Data> {
        return self.icon.load(fileName, from: .main)
    }
}
