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
    func register(user model: UserModel, _ isUplodedIcon: Bool) ->Observable<Bool>
}
class AddUserUseCaseImpl: BaseUseCase, AddUserUseCase {
    
    var userRepository: UserRepository
    let iconRepository: IconRepository
    var translator: UserTranslator
    
    init(user: UserRepository, icon: IconRepository, translator: UserTranslator) {
        self.userRepository = user
        self.iconRepository = icon
        self.translator = translator
    }
    
    func register(user: UserModel, _ isUplodedIcon: Bool = false) ->Observable<Bool> {
        
        return self.upload(icon: user.icon, of: user.iconFileName, isUplodedIcon)
            .asObservable()
            .map { _ in true }
            .concat(self.register(user: user))
    }
    
    private func upload(icon: Data?, of fileName: String?, _ isUpload: Bool) ->Completable {
        if isUpload {
            return self.iconRepository.save(icon!, of: fileName!, to: .main)
        } else {
            return Completable.create { observer -> Disposable in
                observer(.completed)
                return Disposables.create()
            }
        }
    }
    
    private func register(user: UserModel) -> Observable<Bool> {
        var userEntity = translator.translate(model: user)
        
        return self.userRepository.create(user: &userEntity)
            .map { userEntity in
                return true
        }
    }
    
}
