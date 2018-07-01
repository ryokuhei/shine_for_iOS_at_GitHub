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
    func update(user entity: inout UserProfileEntity, from currentGroup: Group) -> Observable<UserProfileEntity>
    func getUserInGroup(by key: Group) ->Observable<UserGroupEntity>
    func isExistUser(inGroup: Group) ->Observable<Bool>
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
        
        return userProfile.write(user: entity)
            .asObservable()
            .do(onNext: {
              [unowned self] (entity) in
                let result = self.userGroup.append(user: entity, to: entity.group)
                result.subscribe()
                    .dispose()
            })
    }
    
    func update(user entity: inout UserProfileEntity, from currentGroup: Group) -> Observable<UserProfileEntity> {
        return userProfile.update(user: entity)
            .asObservable()
            .do(onNext: {
                [unowned self] (entity) in
                let result = self.userGroup.move(user: entity, to: entity.group, from: currentGroup)
                result.subscribe()
                      .dispose()
            })
    }
    
    func getUserInGroup(by key: Group) ->Observable<UserGroupEntity> {
        return userGroup.fetch(by: key)
    }
    
    func isExistUser(inGroup: Group) ->Observable<Bool> {
        return userGroup.fetch(by: inGroup)
            .map { userGroup in
                if userGroup.users.count >= 1 {
                    return true
                } else {
                    return false
                }
            }
    }
    
}
