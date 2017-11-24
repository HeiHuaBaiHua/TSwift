//
//  HHTableView.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/11/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

class HHTableView: UITableView {

    var isFirstScrollResponder = true
    var gestureChoiceHandler: (UIGestureRecognizer, UIGestureRecognizer) -> Bool = {_,_ in
        return false
    }
}

extension HHTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureChoiceHandler(gestureRecognizer, otherGestureRecognizer)
    }
}
