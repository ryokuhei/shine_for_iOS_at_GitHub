//
//  FirstCharacterNenuBar.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/11.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class MenuBarView: UICollectionView {
    
    var presenter: MenuContainerPresenter?
    
    var isInfinite = false
    var menuTabWidth: CGFloat = 0.0

    var itemCount: Int {
        var itemCount = MenuManager.menuList.count
        if isInfinite {
            itemCount = itemCount * 3
        }
        return itemCount
    }
    var selectIndexPath: IndexPath {
        var index = self.currentIndex
        if isInfinite {
              index = self.currentIndex ?? 0 + MenuManager.menuList.count
        }
        return IndexPath(item: index ?? 0, section: 0)
    }

    var currentIndex: Int? = nil {
        didSet {
            if let currentIndex = self.currentIndex,
                isInfinite && MenuManager.menuList.count >= 1 {
                    self.currentIndex = currentIndex % MenuManager.menuList.count
            }
        }
    }

    func inject(_ presenter: MenuContainerPresenter) {
        self.presenter = presenter
    }
    
    func selectMenu(index: Int) {
        self.currentIndex = index
        
        self.scrollToItem(at: self.selectIndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension MenuBarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.currentIndex = indexPath.item
        collectionView.selectItem(at: self.selectIndexPath , animated: true, scrollPosition: .centeredHorizontally)
        presenter?.inputs.selectMenu.onNext(MenuManager.menuList[currentIndex!])
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    }
    
}

extension MenuBarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        let index = indexPath.row % MenuManager.menuList.count
        cell.setDisplay(display: MenuManager.menuList[index].tabDisplay ?? "")

        return cell
    }
}

extension MenuBarView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isInfinite else {
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
