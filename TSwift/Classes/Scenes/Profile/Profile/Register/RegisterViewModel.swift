//
//  RegisterViewModel.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/23.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import Result
import ReactiveSwift
import ReactiveCocoa

private let InvalidAccount = "手机号格式不正确"
private let InvalidPassword = "密码格式不正确"
private let InvalidVerifyCode = "验证码格式不正确"

//MARK: Interface
protocol RegisterViewModelProtocol {
    func setInput(accountInput: NSignal<String?>, passwordInput: NSignal<String?>, ensurePasswordInput: NSignal<String?>, verifyCodeInput: NSignal<String?>)
    
    var validAccount: MutableProperty<String> { get }
    var validPassword: MutableProperty<String> { get }
    var validEnsurePassword: MutableProperty<String> { get }
    var validVerifyCode: MutableProperty<String> { get }
    
    var errorText: MutableProperty<String> { get }
    var verifyCodeText: MutableProperty<String> { get }
    var getVerifyCodeAction: AnyAPIAction{ get }
    
    var submitAction: AnyAPIAction { get }
}
extension RegisterViewModel: RegisterViewModelProtocol{}

class RegisterViewModel {
    private let dealloc = DeinitLogItem(RegisterViewModel.self)
    
    private(set) var validAccount = MutableProperty("")
    private(set) var validPassword = MutableProperty("")
    private(set) var validEnsurePassword = MutableProperty("")
    private(set) var validVerifyCode = MutableProperty("")
    
    private var errors = (account: InvalidAccount, password: InvalidPassword, verifyCode: InvalidVerifyCode)
    private(set) var errorText = MutableProperty("")

    private var timer: Timer?
    private var time = MutableProperty(60)
    private(set) var verifyCodeText = MutableProperty("验证码")
    private(set) lazy var getVerifyCodeAction = AnyAPIAction(enabledIf: self.enableGetVerifyCode) { [unowned self] _ -> AnyAPIProducer in
        return self.getVerifyCodeProducer
    }

    private(set) lazy var submitAction: AnyAPIAction = AnyAPIAction(enabledIf:  self.enableSubmit) { [unowned self] _ -> AnyAPIProducer in
        return self.submitProducer
    }
    
    deinit {
        timer?.invalidate()
    }

    func setInput(accountInput: NSignal<String?>, passwordInput: NSignal<String?>, ensurePasswordInput: NSignal<String?>, verifyCodeInput: NSignal<String?>) {
        
        validAccount <~ accountInput.map({[unowned self] (text) -> String in
            
            let account = (text ?? "").substring(to: 11)
            self.errors.account = !account.isValidPhoneNum ? InvalidAccount : ""
            return account
        })
        
        validPassword <~ passwordInput.map({[unowned self] (text) -> String in
            
            let password = (text ?? "").substring(to: 16)
            let isValidPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,16}$")
            self.errors.password = !isValidPassword.evaluate(with: password) ? InvalidPassword : ""
            return password
        })
        
        validEnsurePassword <~ ensurePasswordInput.map({
            return ($0 ?? "").substring(to: 16)
        })
        
        validVerifyCode <~ verifyCodeInput.map({[unowned self] (text) -> String in
            
            let verifyCode = (text ?? "").substring(to: 6)
            let isValidVerifyCode = NSPredicate(format: "SELF MATCHES %@", "\\w+")
            self.errors.verifyCode = !isValidVerifyCode.evaluate(with: verifyCode) ? InvalidVerifyCode : ""
            return verifyCode
        })
    }
    
    //MARK: Action
    @objc private func timeDown() {
        
        if (self.time.value > 0) {
            self.verifyCodeText.value = String(self.time.value) + "s"
        } else {
            
            timer?.invalidate()
            verifyCodeText.value = "验证码";
        }
        self.time.value -= 1;
    }
    
    //MARK: Network
    private var getVerifyCodeProducer: AnyAPIProducer {
        return UserAPIManager().getVerifyCode(phoneNumber: self.validAccount.value).on(value: { [unowned self] (value) in
            
            self.timer?.invalidate()
            self.time.value = 60;
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeDown), userInfo: nil, repeats: true)
        })
    }
    
    private var submitProducer: AnyAPIProducer {
        return UserAPIManager().registerProducer(account: self.validAccount.value, password: self.validPassword.value).on(value: { [unowned self] (value) in
            
            self.timer?.invalidate()
//            UserDefaults.account = value
        })
    }
    
    //MARK: Utils
    private var enableSubmit: Property<Bool> {
        return Property.combineLatest(validAccount, validPassword, validEnsurePassword, validVerifyCode).map({ [unowned self] (account, password, ensurePassword, verifyCode) -> Bool in
            
            if self.errors.account.count > 0 {
                self.errorText.value = self.errors.account
            } else if self.errors.password.count > 0 {
                self.errorText.value = self.errors.password
            } else if password != ensurePassword  {
                self.errorText.value = "两次输入的密码不一致"
            } else if self.errors.verifyCode.count > 0 {
                self.errorText.value = self.errors.verifyCode
            } else {
                self.errorText.value = ""
            }
            
            return self.errorText.value.count == 0
        })
    }
    
    private var enableGetVerifyCode: Property<Bool> {
        return Property.combineLatest(time, errorText).map({ (time, error) -> Bool in
            return error != InvalidAccount && (time <= 0 || time >= 60)
        })
    }
}

