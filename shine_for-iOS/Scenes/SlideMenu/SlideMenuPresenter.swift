//
//  SlideMenuPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/07.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SlideMenuPresenter {
    var inputs:  SlideMenuInputs { get }
    var outputs: SlideMenuOutputs { get }
}
protocol SlideMenuInputs {
    var signOutButton: PublishSubject<Void> { get }
}
protocol SlideMenuOutputs {
    var signOut: Observable<Void> { get }
}

class SlideMenuPresenterImpl: BasePresetner, SlideMenuPresenter, SlideMenuInputs, SlideMenuOutputs {
    lazy var inputs: SlideMenuInputs    = { return self }()
    lazy var outputs: SlideMenuOutputs  = { return self }()
    
    var signOutButton = PublishSubject<Void>()
    
    lazy var signOut: Observable<Void> = {
        return self.signOutButton.asObserver()
    }()
    
}
