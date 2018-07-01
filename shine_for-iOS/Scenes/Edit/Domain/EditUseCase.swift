//
//  EditUseCase.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol EditUseCase {
    
    func update(user: UserModel, from menu: Group, _ isUplodedIcon: Bool) ->Observable<Bool>

}

class EditUseCaseImpl: BaseUseCase, EditUseCase {

    let userRepository: UserRepository
    let iconRepository: IconRepository
    let groupRepository: GroupRepository
    let translator: UserTranslator
    
    init(userRepository: UserRepository, iconRepository: IconRepository, groupRepository:GroupRepository, translator: UserTranslator) {
        self.userRepository = userRepository
        self.iconRepository = iconRepository
        self.groupRepository = groupRepository
        self.translator = translator
        
        super.init()
    }
    
    func update(user: UserModel, from menu: Group, _ isUplodedIcon: Bool = false) -> Observable<Bool> {
        
        return self.upload(icon: user.icon, of: user.iconFileName, isUplodedIcon)
            .asObservable()
            .map { _ in true }
            .concat(self.update(user: user, from: menu))
            .do(onNext:{ result in
                if result {
                    _ = self.switchBetweenToUsedIfUnused(by: Group(key: user.name)).subscribe()
                }
             })
            .do(onNext:{ result in
                if result {
                    _ = self.switchBetweenToUnusedIfUserDoesNotExist(by: menu).subscribe()
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
    
    private func update(user: UserModel, from menu: Group) -> Observable<Bool> {
        var userEntity = translator.translate(model: user)

        return self.userRepository.update(user: &userEntity, from: menu)
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
    
    private func switchBetweenToUnusedIfUserDoesNotExist(by group: Group) ->Observable<Bool> {
        
        return self.userRepository.isExistUser(inGroup: group)
            .flatMap {
                [unowned self] isUsed ->Observable<Bool> in
                guard isUsed else {
                    return self.groupRepository.unused(group)
                }
                return Observable.just(true)
        }
    }
}
