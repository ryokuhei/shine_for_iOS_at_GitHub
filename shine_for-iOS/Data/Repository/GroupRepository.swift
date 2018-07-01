//
//  GroupRepository.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/31.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol GroupRepository {
    func getGroupList() ->Observable<[GroupEntity]>
    func use(_ group: Group) ->Observable<Bool>
    func unused(_ group: Group) ->Observable<Bool>
    func isUsed(_ group: Group) ->Observable<Bool>
}

class GroupRepositoryImpl: BaseRepository, GroupRepository {
    
    var group: GroupDataStore
    
    init(group: GroupDataStore) {
        self.group = group
    }
    
    func getGroupList() ->Observable<[GroupEntity]> {
        return group.fetchAll()
            .asObservable()
    }
    func use(_ group: Group) ->Observable<Bool> {
        return self.group.update(by: group, isUsed: true)
                   .asObservable()
                   .map{_ in true}
    }
    
    func unused(_ group: Group) ->Observable<Bool> {
        return self.group.update(by: group, isUsed: false)
            .asObservable()
            .map{_ in true}
    }
    
    func isUsed(_ group: Group) ->Observable<Bool> {
        return self.group.fetch(by: group)
            .map { group in
                return group.isUsed
            }
            .asObservable()
    }
}
