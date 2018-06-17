//
//  AddUserUseCase.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddUserUseCase {
    func register(user model: UserModel) ->Observable<Bool>
}

class AddUserUseCaseImpl: BaseUseCase, AddUserUseCase {
    
    var repository: UserRepository
    var translator: UserTranslator
    
    init(repository: UserRepository, translator: UserTranslator) {
        self.repository = repository
        self.translator = translator
    }
    
    func register(user model: UserModel) ->Observable<Bool> {
        var entity = translator.translate(model: model)
        return repository.create(user: &entity)
            .map { (userEntity) ->Bool in
                return true
            }
    }
    
}
