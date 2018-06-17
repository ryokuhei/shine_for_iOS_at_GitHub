//
//  UserListUseCase.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/26.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol UserListUseCase {
    
    func getUserList(by key: String) ->Observable<[UserListModel]>
}

class UserListUseCaseImpl: BaseUseCase, UserListUseCase {
    
    var user: UserRepository
    var userListTranslator: UserListTranslator
    
    init(user repository: UserRepository, userListTranslator translator: UserListTranslator) {
        self.user = repository
        self.userListTranslator = translator
    }
    
    func getUserList(by key: String) ->Observable<[UserListModel]> {
        
        return self.user.getUserInGroup(by: key)
                   .map { [unowned self] (userGroupEntity) ->[UserListModel] in
                     return self.userListTranslator.translate(userGroupEntity)
                   }
    }
}
