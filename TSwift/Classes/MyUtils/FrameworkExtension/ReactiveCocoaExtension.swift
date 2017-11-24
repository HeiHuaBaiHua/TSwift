//
//  ReactiveCocoaExtension.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/27.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift

typealias NSignal<T> = ReactiveSwift.Signal<T, NoError>
typealias AnySignal = ReactiveSwift.Signal<Any?, NoError>
typealias APISignal<T> = ReactiveSwift.Signal<T, APIError>
typealias AnyAPISignal = ReactiveSwift.Signal<Any?, APIError>

typealias Producer<T> = ReactiveSwift.SignalProducer<T, NoError>
typealias AnyProducer = ReactiveSwift.SignalProducer<Any?, NoError>
typealias APIProducer<T> = ReactiveSwift.SignalProducer<T, APIError>
typealias AnyAPIProducer = ReactiveSwift.SignalProducer<Any?, APIError>

typealias NAction<I, O> = ReactiveSwift.Action<I, O, NoError>
typealias AnyAction = ReactiveSwift.Action<Any?, Any?, NoError>
typealias APIAction<O> = ReactiveSwift.Action<[String: String]?, O, APIError>
typealias AnyAPIAction = ReactiveSwift.Action<Any?, Any?, APIError>

typealias ButtonAction = ReactiveCocoa.CocoaAction<UIButton>

extension SignalProducer where Error == APIError {
    
    @discardableResult
    func startWithValues(_ action: @escaping (Value) -> Void) -> Disposable {
        return start(Signal.Observer(value: action))
    }
}

extension CocoaAction {
    
    public convenience init<Output, Error>(_ action: Action<Any?, Output, Error>) {
        self.init(action, input: nil)
    }
}
