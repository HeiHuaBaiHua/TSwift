//
//  ListViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Foundation

import ReactiveSwift
import ReactiveCocoa

protocol ListCellModelProtocol {
    var cellHeight: CGFloat { get }
}

extension ListCellModelProtocol {
    var cellHeight: CGFloat { return 44 }
}

protocol ListViewModelProtocol {
    
    var allData: [ListCellModelProtocol] { get }
    var refreshAction: APIAction<[ListCellModelProtocol]>? { get }
    var loadMoreAction: APIAction<[ListCellModelProtocol]>? { get }
}

extension ListViewModelProtocol {
    
    var refreshAction: APIAction<[ListCellModelProtocol]>? { return nil }
    var loadMoreAction: APIAction<[ListCellModelProtocol]>? { return nil }
}

class ListViewModel: ListViewModelProtocol {
    
    private var page = 1
    internal var pageSize = 20
    
    //MARK: Interface
    
    private(set) var allData: [ListCellModelProtocol] = []
    
    private(set) lazy var refreshAction: APIAction<[ListCellModelProtocol]>? = Action { [unowned self] _ -> APIProducer<[ListCellModelProtocol]> in
        
        return self.fetchDataSignal(page: 1).on(value: { (weibos) in
            
            self.page = 2
            self.allData.removeAll()
            self.allData.append(contentsOf: weibos)
        })
    }
    
    private(set) lazy var loadMoreAction: APIAction<[ListCellModelProtocol]>? = Action { [unowned self] _ -> APIProducer<[ListCellModelProtocol]> in
        
        return self.fetchDataSignal(page: self.page).on(value: { (weibos) in
            
            self.page += 1
            self.allData.append(contentsOf: weibos)
        })
    }
    
    //MARK: Override
    
    func fetchDataSignal(page: Int) -> APIProducer<[ListCellModelProtocol]> {
        return APIProducer.empty
    }
}
