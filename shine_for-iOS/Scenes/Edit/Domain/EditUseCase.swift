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
    
    func update(user: UserModel, _ isUplodedIcon: Bool) ->Observable<Bool>

}

class EditUseCaseImpl: BaseUseCase, EditUseCase {

    let user: UserRepository
    let icon: IconRepository
    let translator: UserTranslator
    
    init(userRepository: UserRepository, iconRepository: IconRepository, translator: UserTranslator) {
        self.user = userRepository
        self.icon = iconRepository
        self.translator = translator
        
        super.init()
    }
    
//    func update(user: UserModel, _ isUplodedIcon: Bool = false) -> Observable<Bool> {
        
//        var userEntity = translator.translate(model: user)
//
//        return self.user.update(user: &userEntity)
//            .map { userEntity in
//                return true
//            }.do(onNext:{ _ in
//                if isUplodedIcon {
//                    _ = self.icon.save(user.icon!, of: user.iconFileName!, to: .main)
//                        .subscribe()
//                }
//            })

    func update(user: UserModel, _ isUplodedIcon: Bool = false) -> Observable<Bool> {
        
        return self.upload(icon: user.icon, of: user.iconFileName, isUplodedIcon)
            .asObservable()
            .map { _ in true }
            .concat(self.update(user: user))
    }
    
    private func upload(icon: Data?, of fileName: String?, _ isUpload: Bool) ->Completable {
        if isUpload {
             return self.icon.save(icon!, of: fileName!, to: .main)
        } else {
            return Completable.create { observer -> Disposable in
                observer(.completed)
                return Disposables.create()
            }
        }
    }
    
    private func update(user: UserModel) -> Observable<Bool> {
        var userEntity = translator.translate(model: user)

        return self.user.update(user: &userEntity)
            .map { userEntity in
                return true
            }
    }

}
