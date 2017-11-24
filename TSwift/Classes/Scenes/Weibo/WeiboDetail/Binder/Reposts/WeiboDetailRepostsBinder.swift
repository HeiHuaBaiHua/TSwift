//
//  WeiboDetailRepostsBinder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailRepostsBinder: WeiboDetailTableBinder {
    private let dealloc = DeinitLogItem(self)
}

//MARK: Override
extension WeiboDetailRepostsBinder {
    
    override var cellClass: AnyClass {
        return WeiboDetailRepostsCell.self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.description()) as! WeiboDetailRepostsCell
        cell.viewModel = viewModel.allData[indexPath.row] as! WeiboDetailRepostsCellViewModel
        return cell
    }
}
