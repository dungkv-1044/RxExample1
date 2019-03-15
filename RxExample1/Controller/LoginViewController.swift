//
//  ViewController.swift
//  RxExample1
//
//  Created by Dung on 3/13/19.
//  Copyright © 2019 Dung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tfAccount: UITextField!
    @IBOutlet fileprivate weak var tfPassword: UITextField!
    @IBOutlet fileprivate weak var lbErrorEmail: UILabel!
    @IBOutlet fileprivate weak var lbErrorPassword: UILabel!
    @IBOutlet fileprivate weak var btnLogin: UIButton!
    
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegate
        tfAccount.delegate = self
        tfPassword.delegate = self
        //init viewmodel
        viewModel = LoginViewModel()
        
        //bind value of textfield to variable of viewmodel
        _ = tfAccount.rx.text.map { $0 ?? "" }.bind(to: viewModel.usernameText)
        _ = tfPassword.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordText)
        
        //  subscribe result of variable isValid in LoginViewModel then handle button login is enable or not?
        _ = viewModel.isValid.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else { return }
            strongSelf.btnLogin.isEnabled = isValid
            strongSelf.btnLogin.backgroundColor = isValid ? UIColor.red : UIColor.gray
        })
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        //do something
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.tfAccount:
            self.viewModel.isValidUsername.subscribe({ [weak self] isValid in
                self?.lbErrorEmail.text = isValid.element! ? "Valid username" : "Invalid username"
            }).disposed(by: disposeBag)
        case self.tfPassword:
            viewModel.isValidPassword.subscribe({ [weak self] isValid in
                self?.lbErrorPassword.text = isValid.element! ? "Valid password" : "Invalid password"
            }).disposed(by: disposeBag)
        default:
            return
        }
    }
}
