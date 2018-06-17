//
//  UserRepository.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol UserRepository {
    func getUser(by key: String) ->Single<UserProfileEntity>
    func create(user entity: inout UserProfileEntity) ->Observable<UserProfileEntity>
    func update(user entity: inout UserProfileEntity) ->Observable<UserProfileEntity>
    func getUserInGroup(by key: String) ->Observable<UserGroupEntity>
}

class UserRepositoryImpl: BaseRepository, UserRepository {

    var userProfile: UserProfileDataStore
    var userGroup: UserGroupDataStore
    
    init(userProfile: UserProfileDataStore, userGroup: UserGroupDataStore) {
        self.userProfile = userProfile
        self.userGroup = userGroup
    }
    
    func getUser(by key: String) ->Single<UserProfileEntity> {
        return userProfile.fetch(by: key)
    }
    
    func create(user entity: inout UserProfileEntity) -> Observable<UserProfileEntity> {
        entity.group = self.extractFirstCharacter(in: entity.name)
        return userProfile.write(user: entity)
            .asObservable()
            .do(onNext: {
              [unowned self] (entity) in
                let key = self.extractFirstCharacter(in: entity.name)
                let result = self.userGroup.append(user: entity, key)
                result.subscribe()
                    .dispose()
            })
    }
    
    func update(user entity: inout UserProfileEntity) -> Observable<UserProfileEntity> {
        let fromKey = entity.group
        entity.group = self.extractFirstCharacter(in: entity.name)
        return userProfile.update(user: entity)
            .asObservable()
            .do(onNext: {
                [unowned self] (entity) in
                let toKey = entity.group
                let result = self.userGroup.move(user: entity, fromKey!, toKey!)
                result.subscribe()
                      .dispose()
            })
    }
    
    func getUserInGroup(by key: String) ->Observable<UserGroupEntity> {
        return userGroup.fetch(by: key)
    }
    
    private func extractFirstCharacter(in character: String) ->String {
        
        return String(character.lowercased().prefix(1))
    }

}
