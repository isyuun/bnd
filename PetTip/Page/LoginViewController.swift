//
//  LoginViewController.swift
//  PetTip
//
//  Created by carebiz on 12/3/23.
//

import UIKit

class LoginViewController : CommonViewController {
    
    @IBOutlet weak var cr_topMarginAreaHeight : NSLayoutConstraint!
    @IBOutlet weak var vw_basicAcctArea : UIView!
    
    @IBOutlet weak var logoImageView : UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var topBgView : UIView!
    
    @IBOutlet weak var inputBoxId : UITextField!
    @IBOutlet weak var inputBoxPwd : UITextField!
    
    @IBOutlet weak var btnLoginKakao : UIButton!
    @IBOutlet weak var btnLoginNaver : UIButton!
    @IBOutlet weak var btnLoginFacebook : UIButton!
    @IBOutlet weak var btnLoginGoogle : UIButton!
    @IBOutlet weak var btnLoginApple : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(hex: "#FFF6F8FC")
        
        topBgView.backgroundColor = UIColor.init(hex: "#FF4783f5")
        
        logoImageView.image = UIImage(named: "logo_login")
        
        scrollView.backgroundColor = UIColor.clear
        
        bgView.layer.cornerRadius = 35
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hex: "#FFF6F8FC")
        
        inputBoxId.layer.borderColor = UIColor.init(hex: "#e3e9f2")?.cgColor
        inputBoxId.initLeftIconIncludeTextField(iconImg: UIImage(named:"icon_email")!)
        
        inputBoxPwd.layer.borderColor = UIColor.init(hex: "#e3e9f2")?.cgColor
        inputBoxPwd.initLeftIconIncludeTextField(iconImg: UIImage(named:"icon_password")!)
        
        btnLogin.setTitleColor(UIColor.white, for: .normal)
        btnLogin.showShadowMid()
        
        btnLoginKakao.showShadowMid()
        var imageView  = UIImageView(frame:CGRectMake(27, 12, 22, 22));
        imageView.image = UIImage(named: "icon_kakao")
        btnLoginKakao.addSubview(imageView)
        
        btnLoginNaver.showShadowMid()
        imageView  = UIImageView(frame:CGRectMake(27, 12, 22, 22));
        imageView.image = UIImage(named: "icon_naver")
        btnLoginNaver.addSubview(imageView)
        
        btnLoginFacebook.showShadowMid()
        imageView  = UIImageView(frame:CGRectMake(27, 12, 22, 22));
        imageView.image = UIImage(named: "icon_facebook")
        btnLoginFacebook.addSubview(imageView)
        
        btnLoginGoogle.showShadowMid()
        imageView  = UIImageView(frame:CGRectMake(27, 12, 22, 22));
        imageView.image = UIImage(named: "icon_google")
        btnLoginGoogle.addSubview(imageView)
        
        btnLoginApple.showShadowMid()
        imageView  = UIImageView(frame:CGRectMake(27, 12, 22, 22));
        imageView.image = UIImage(named: "icon_apple")
        btnLoginApple.addSubview(imageView)
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            inputBoxId.text = email
        }
        
        // Hide basic account controls. Only shows SNS account controls.
//        cr_topMarginAreaHeight.constant = 160
//        vw_basicAcctArea.isHidden = true
//        vw_basicAcctArea.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    @IBOutlet weak var btnLogin : UIButton!
    @IBAction func onLogin(_ sender: Any) {
        inputBoxId.resignFirstResponder()
        inputBoxPwd.resignFirstResponder()
        
        let inputId = inputBoxId.text ?? ""
        let inputPw = inputBoxPwd.text ?? ""
        if (inputId.contains("@") && inputId.contains(".")
            && inputPw.count >= 4) {
            member_Login()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.showToast(msg: "아이디 및 패스워드를 확인해주세요")
            })
        }
    }
    
    func member_Login() {
        startLoading()
        
        let request = LoginRequest(appTypNm: Util.getModel(), userID: inputBoxId.text!, userPW: inputBoxPwd.text!)
        MemberAPI.login(request: request) { login, error in
            self.stopLoading()
            
            if let login = login {
                let userDef = UserDefaults.standard
                userDef.set(login.accessToken, forKey: "accessToken")
                userDef.set(login.refreshToken, forKey: "refreshToken")
                userDef.set(login.userId, forKey: "userId")
                userDef.set(login.email, forKey: "email")
                userDef.set(login.nckNm, forKey: "nckNm")
                userDef.synchronize()
//                KeychainServiceImpl.shared.accessToken = login.accessToken
//                KeychainServiceImpl.shared.refreshToken = login.refreshToken
                
                self.performSegue(withIdentifier: "segueLoginToMain", sender: self)
            }
            
            self.processNetworkError(error)
        }
    }
    
    override func processNetworkError(_ error: MyError?) {
        if let error = error {
            if let resCode = error.resCode {
                if resCode == 406 {
                    DispatchQueue.main.async {
                        self.showToast(msg: "아이디 및 패스워드를 확인해주세요")
                    }
                    return
                }
            }
            
            self.showSimpleAlert(title: "Network fail", msg: error.description)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueLoginToFindId") {
            let dest = segue.destination
            guard let vc = dest as? FindIdPwViewController else { return }
            vc.launchTabPageIndex = 0
            
        } else if (segue.identifier == "segueLoginToFindPw") {
            let dest = segue.destination
            guard let vc = dest as? FindIdPwViewController else { return }
            vc.launchTabPageIndex = 1
        }
    }
}

