//
//  WeiboDetailCommentsBinder.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/21.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class WeiboDetailCommentsBinder: WeiboDetailTableBinder {
    private let dealloc = DeinitLogItem(self)
}

//MARK: Override
extension WeiboDetailCommentsBinder {
    
    override var cellClass: AnyClass {
        return WeiboDetailCommentsCell.self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.description()) as! WeiboDetailCommentsCell
        cell.viewModel = viewModel.allData[indexPath.row] as! WeiboDetailCommentsCellViewModel
        return cell
    }
}
