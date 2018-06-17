//
//  DetailPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/27.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailInputs {
    
    var key: PublishSubject<String> {get}
    var tapEditBuutton: PublishSubject<Void> {get}
    var tapListBuutton: PublishSubject<Void> {get}
}

protocol DetailOutputs {
    var name: Observable<String> {get}
    var mail: Observable<String> {get}
    var comment: Observable<String?> {get}
    var icon: Observable<Data?> {get}
    
    var isIconLoding: Variable<Bool> {get}
    var isLoaded: Variable<Bool> {get}
    
    var showEditView: Observable<(user: UserModel, icon: Data?)> {get}
    var dismissView: Observable<Void> {get}

}

protocol DetailPresenter {
    var inputs: DetailInputs {get}
    var outputs: DetailOutputs {get}
}

class DetailPresenterImpl: BasePresetner, DetailPresenter, DetailInputs, DetailOutputs {

    
    lazy var inputs: DetailInputs = { self }()
    lazy var outputs: DetailOutputs = { self }()
    
    var usecase: DetailUseCase
    
    var key = PublishSubject<String>()
    
    lazy var user: Observable<UserModel> = {
        return self.key
                   .flatMap {
                     [unowned self] (key) in
                       return self.usecase.getUserDetail(by: key)
                   }
                   .do(onNext: { [unowned self] _ in
                      self.isLoaded.value = true
                   })
                   .share(replay: 1)
    }()
    
    lazy var name: Observable<String> = {
        return user.map {
            (user) -> String in
                return user.name
        }
        .share(replay: 1)
    }()
    lazy var mail: Observable<String> = {
        return user.map {
         (user) -> String in
           return user.email
         }
        .share(replay: 1)
    }()
    
    lazy var comment: Observable<String?> = {
        return user.map {
            (user) -> String? in
            return user.comment
        }
        .share(replay: 1)
    }()
    

    lazy var icon: Observable<Data?> = {
        return user
          .flatMap {
            [unowned self] (user) ->Observable<Data?> in
                guard let iconName = user.iconFileName,
                          iconName != "" else {
                    return Observable.just(nil)
                }
                self.isIconLoding.value = true
                return self.usecase.loadUserIcon(of : iconName)
                    .asObservable()
                    .flatMap { Observable.just($0) }  // Data -> Data?
                    .do(onNext: { _ in
                        self.isIconLoding.value = false
                    })
            }
            .share(replay: 1)
    }()
    
    var tapEditBuutton = PublishSubject<Void>()

    var isLoaded = Variable<Bool>(false)
    var isIconLoding = Variable<Bool>(false)

    lazy var showEditView: Observable<(user: UserModel, icon: Data?)> = {
        return tapEditBuutton
            .withLatestFrom(
                Observable.combineLatest(self.user, self.icon) {
                    (user, icon) in
                    return (user: user, icon: icon)
            }) { $1 }
    }()

    var tapListBuutton = PublishSubject<Void>()
    
    lazy var dismissView: Observable<Void> = {
        return tapListBuutton
    }()
    
    init(usecase: DetailUseCase) {
        self.usecase = usecase
        super.init()
    }
}
