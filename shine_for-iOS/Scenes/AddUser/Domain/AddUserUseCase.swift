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
    let groupRepository: GroupRepository
    var translator: UserTranslator
    
    init(userRepository: UserRepository, iconRepository: IconRepository, groupRepository: GroupRepository, translator: UserTranslator) {
        self.userRepository = userRepository
        self.iconRepository = iconRepository
        self.groupRepository = groupRepository
        self.translator = translator
    }
    
    func register(user: UserModel, _ isUplodedIcon: Bool = false) ->Observable<Bool> {
        
        return self.upload(icon: user.icon, of: user.iconFileName, isUplodedIcon)
            .asObservable()
            .map { _ in true }
            .concat(self.register(user: user))
            .do(onNext: { result in
                if result {
                    _ = self.switchBetweenToUsedIfUnused(by: Group(key: user.name)).subscribe()
                }
            })
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
    
    private func switchBetweenToUsedIfUnused(by group: Group) ->Observable<Bool> {
        
        return self.groupRepository.isUsed(group)
            .flatMap {
                [unowned self] isUsed ->Observable<Bool> in
                guard isUsed else {
                    return self.groupRepository.use(group)
                }
                return Observable.just(true)
        }
    }
    
}
