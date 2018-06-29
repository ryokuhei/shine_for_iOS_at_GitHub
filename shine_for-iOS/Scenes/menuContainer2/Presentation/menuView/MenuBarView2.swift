//
//  MenuBarViewController2.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/19.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Foundation
import UIKit

class MenuBarView2: UICollectionView {
    
    var presenter: MenuBarPresenter2?
    var disposeBag = DisposeBag()
    
    var menuTabWidth: CGFloat = 0.0

    func inject(_ presenter: MenuBarPresenter2) {
        self.presenter = presenter
        self.setOutputsObservable()
    }
    
    func setOutputsObservable() {
        
        self.presenter?.outputs.selectedMenus
            .map{ menus in menus.current.index}
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [unowned self] index in
                self.selectMenu(by: index)
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.eventOfLeftSwiped
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [unowned self] index in
                self.selectMenu(by: index)
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.eventOfRightSwiped
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [unowned self] index in
                self.selectMenu(by: index)
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.reloadData
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.reloadData()
            }).disposed(by: disposeBag)

    }
    
    private func selectMenu(by index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}

extension MenuBarView2: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        presenter?.inputs.indexOfSelected.onNext(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    }
    
}

extension MenuBarView2: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.presenter?.outputs.menuList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        let index = indexPath.item
        cell.setDisplay(display: MenuManager.menuList[index].tabDisplay ?? "")
        
        return cell
    }
}

extension MenuBarView2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.presenter?.outputs.isInfinite ?? false else {
            return
        }
        
        if self.menuTabWidth == 0.0 {
            self.menuTabWidth = scrollView.contentSize.width / 3.0
        }
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x >= menuTabWidth * 2) {
            scrollView.contentOffset.x = self.menuTabWidth
        }
        
    }
}
