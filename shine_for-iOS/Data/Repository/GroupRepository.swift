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
    
}
