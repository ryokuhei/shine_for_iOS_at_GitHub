//
//  TopPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol TopInputs {
    
    var tapSlideMenuButton: PublishSubject<Void> {get}
    var tapAddButton: PublishSubject<Void> {get}

}

protocol TopOutputs {
    var tapedSlideMenuButton: Observable<Void> {get}
    var tapedAddButton: Observable<Void> {get}
}

protocol TopPresenter {
    var inputs: TopInputs {get}
    var outputs: TopOutputs {get}
}

class TopPresenterImpl: BasePresetner, TopPresenter, TopInputs, TopOutputs {
    
    lazy var inputs: TopInputs = { self }()
    lazy var outputs: TopOutputs = { self }()
    
    var tapSlideMenuButton = PublishSubject<Void>()
    var tapAddButton = PublishSubject<Void>()
    
    
    lazy var tapedSlideMenuButton: Observable<Void> = {
        return tapSlideMenuButton
    }()
    lazy var tapedAddButton: Observable<Void> = {
        return tapAddButton
    }()

}
