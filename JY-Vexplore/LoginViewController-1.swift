//
//  LoginViewController.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SharedKit
class LogViewController: UIViewController {
    /*private lazy var backgroundview: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = R.Image.LoginBackground
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var usernameContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(usernameContainerViewTapped)))
        return view
    }()
    
    private lazy var paswordContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(passwordContainerViewtapped)))
        return view
    }()
    private lazy var usernameTextFiled: UITextField = {
        let textfiled = UITextField()
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.clearButtonMode = .always
        textfiled.textColor = UIColor.body
        textfiled.returnKeyType = .next
        textfiled.delegate = self
        textfiled.placeholder = R.String.Username
        return textfiled
    }()
    private lazy var passworddtextFiled: UITextField = {
        let textfiled = UITextField()
        textfiled.isSecureTextEntry = true
        textfiled.clearButtonMode = .always
        textfiled.textColor = UIColor.body
        textfiled.returnKeyType = .done
        textfiled.delegate = self
        textfiled.placeholder = R.String.Password
        return textfiled
    }()
    private lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        let normalLoginText = NSMutableAttributedString(string: R.String.Login, attributes: [NSFontAttributeName : R.Font.VeryLarge, NSForegroundColorAttributeName: UIColor.body])
        let disabledLoginText = NSMutableAttributedString(string: R.String.Login, attributes: [NSFontAttributeName : R.Font.VeryLarge, NSForegroundColorAttributeName: UIColor.gray])
        btn.setAttributedTitle(normalLoginText, for: .normal)
        btn.setAttributedTitle(disabledLoginText, for: .disabled)
        btn.isEnabled = false
        btn.alpha = 0.0
     = 1.0
     btn.layer.cornerRadius = 5.0
     btn.
        return btn
        
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(R.Image.Close, for: .normal)
        btn.tintColor = .desc
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var onePasswordbtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.Image.Onepassword, for: .normal)
        btn.tintColor = UIColor.gray
        btn.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        btn.addTarget(self, action: #selector(searchFromOnePassword(_:)), for: .touchUpInside)
        return btn
    }()*/
    
    private lazy var centerLoadingview: SquareLoadingView = {
        let view = SquareLoadingView(loadingStyle: .bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private var loginRequest: Request?
    var successHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let bindings = [
            "usernameTextFiled" : usernameTextFiled,
            "passworddtextFiled" : passworddtextFiled,
            "backgroundview" : backgroundview,
            "closeBtn" : closeBtn,
            "usernameContainerView" : usernameContainerView,
            "paswordContainerView" : paswordContainerView,
            "loginBtn" : loginBtn
        ]
        usernameContainerView.addSubview(usernameTextFiled)
        paswordContainerView.addSubview(passworddtextFiled)
        
        usernameContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[usernameTextFiled]|", metrics: nil, views: bindings))
        paswordContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[passworddtextFiled]|", metrics: nil, views: bindings))
        usernameContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[usernameTextFiled(34)]-12-|", metrics: nil, views: bindings))
        paswordContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[passworddtextFiled(34)]-12-|", metrics: nil, views: bindings))
        backgroundview.addSubview(usernameContainerView)
        backgroundview.addSubview(paswordContainerView)
        backgroundview.addSubview(loginBtn)
        backgroundview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-48@999-[usernameContainerView]-48@999-|", metrics: nil, views: bindings))
        usernameContainerView.centerXAnchor.constraint(equalTo: backgroundview.centerXAnchor).isActive = true
        usernameContainerView.leadingAnchor.constraint(equalTo: paswordContainerView.leadingAnchor).isActive = true
        usernameContainerView.trailingAnchor.constraint(equalTo: paswordContainerView.trailingAnchor).isActive = true
        usernameContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 480.0).isActive = true
        backgroundview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[usernameContainerView][paswordContainerView]-44-[loginBtn(44)]", metrics: nil, views: bindings))
        loginBtn.widthAnchor.constraint(equalToConstant: 112.0)
        paswordContainerView.bottomAnchor.constraint(equalTo: backgroundview.centerYAnchor).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: backgroundview.centerXAnchor).isActive = true
        view.addSubview(backgroundview)
        view.addSubview(centerLoadingview)
        view.addSubview(closeBtn)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[closeBtn(50)]", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundview]|", metrics: nil, views: bindings))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundview]|", metrics: nil, views: bindings))
        closeBtn.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        closeBtn.heightAnchor.constraint(equalTo: closeBtn.widthAnchor).isActive = true
        centerLoadingview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerLoadingview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerLoadingview.widthAnchor.constraint(equalToConstant: R.Constant.LoadingViewHeight).isActive = true
        
        usernameContainerView.transform = CGAffineTransform(translationX: 0, y: 200)
        usernameContainerView.alpha = 0.0
        paswordContainerView.transform = CGAffineTransform(translationX: 0, y: 200)
        paswordContainerView.alpha = 0.0
        if OnePasswordExtension.shared().isAppExtensionAvailable() {
            passworddtextFiled.rightView = onePasswordbtn
            passworddtextFiled.rightViewMode = .always
        }
        view.backgroundColor = UIColor.background*/
       /* NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: Notification.Name.UITextViewTextDidChange, object: usernameTextFiled)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: Notification.Name.UITextViewTextDidChange, object: passworddtextFiled)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)*/
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       /* let duration = 0.4
        UIView.animate(withDuration: duration) {
            self.usernameContainerView.transform = CGAffineTransform.identity
            self.usernameContainerView.alpha = 1.0
            self.paswordContainerView.transform = CGAffineTransform.identity
            self.paswordContainerView.alpha = 1.0
            self.loginBtn.alpha = 1.0
        }*/
    }
    
    @objc private func usernameContainerViewTapped() {
        
    }
    @objc private func passwordContainerViewtapped() {
        
    }
    @objc private func closeBtnTapped(){
        loginRequest?.cancel()
        dismiss(animated: true, completion: nil)
    }
    @objc private func loginBtnTapped(){}
    @objc private func searchFromOnePassword(_ sender: UIButton) {}
    @objc private func textFieldTextDidChange() {
       /* if let username = usernameTextFiled.text, username.isEmpty == false, let password = passworddtextFiled.text, password.isEmpty == false {
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }*/
    }
    
    @objc  private func handleContentSizeCategoryDidChanged() {
        /*usernameTextFiled.font = R.Font.Medium
        passworddtextFiled.font = R.Font.Medium
        let normalLoginText = NSMutableAttributedString(string: R.String.Login, attributes: [NSFontAttributeName     : R.Font.VeryLarge, NSForegroundColorAttributeName: UIColor.body])
        let disabledLoginText = NSMutableAttributedString(string: R.String.Login, attributes: [NSFontAttributeName : R.Font.Large, NSForegroundColorAttributeName: UIColor.gray])
        loginBtn.setAttributedTitle(normalLoginText, for: .normal)
        loginBtn.setAttributedTitle(disabledLoginText, for: .disabled)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
