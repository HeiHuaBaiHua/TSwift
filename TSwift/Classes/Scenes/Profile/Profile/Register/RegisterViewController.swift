//
//  RegisterViewController.swift
//  TSwift
//
//  Created by HeiHuaBaiHua on 2017/10/20.
//  Copyright © 2017年 HeiHuaBaiHua. All rights reserved.
//

import UIKit

import ReactiveSwift
import ReactiveCocoa

class RegisterViewController: UIViewController {
    private let dealloc = DeinitLogItem(self)

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var ensurePasswordTF: UITextField!
    
    @IBOutlet weak var verifyCodeTF: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        title = "TRegister"
        
        submitButton.setBackgroundImage(UIColor(hex: 0xF14B5E).image, for: .normal)
        submitButton.setBackgroundImage(UIColor(hex: 0xcccccc).image, for: .disabled)
        verifyCodeButton.setBackgroundImage(UIColor(hex: 0xF14B5E).image, for: .normal)
        verifyCodeButton.setBackgroundImage(UIColor(hex: 0xcccccc).image, for: .disabled)
        viewModel = RegisterViewModel()
    }
    
    private var viewModel: RegisterViewModelProtocol! {
        didSet {
            viewModel.setInput(accountInput: accountTF.reactive.continuousTextValues,
                               passwordInput: passwordTF.reactive.continuousTextValues,
                               ensurePasswordInput: ensurePasswordTF.reactive.continuousTextValues,
                               verifyCodeInput: verifyCodeTF.reactive.continuousTextValues)
            
            accountTF.reactive.text <~ viewModel.validAccount
            passwordTF.reactive.text <~ viewModel.validPassword
            ensurePasswordTF.reactive.text <~ viewModel.validEnsurePassword
            
            errorLabel.reactive.text <~ viewModel.errorText.signal.skip(first: 1)
            
            verifyCodeTF.reactive.text <~ viewModel.validVerifyCode
            verifyCodeButton.reactive.title <~ viewModel.verifyCodeText
            verifyCodeButton.reactive.pressed = ButtonAction(viewModel.getVerifyCodeAction)
            viewModel.getVerifyCodeAction.errors.observeValues {[unowned self] (error) in
                self.view.toast(error.reason)
            }
            
            submitButton.reactive.pressed = ButtonAction(viewModel.submitAction)
            viewModel.submitAction.errors.observeValues {[unowned self] (error) in
                self.view.toast(error.reason)
            }
            viewModel.submitAction.values.observeValues {[unowned self] (value) in
                
                self.view.toast("注册成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
