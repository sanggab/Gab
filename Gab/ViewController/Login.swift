//
//  Login.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/01.
//

import Foundation
import UIKit
import WebKit
import XHQWebViewJavascriptBridge
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire
import SocketIO

class Login: ViewController, NaverThirdPartyLoginConnectionDelegate,pageopen{
    @IBOutlet var liveChatBtn: UIButton!
    static let loginShared = Login()
    var memPhoto = ""
    var memId = ""
    var chatName = ""
    var pageOn = false
    
    let decoder = JSONDecoder()
    var naverEmail = ""
    var kakaoEmail = ""
    
    @IBOutlet var webView: WKWebView!
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    lazy var bridge = WKWebViewJavascriptBridge.bridge(forWebView: webView)    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abc()
        registerHandeler()
        loginInstance?.delegate = self
        liveChatBtn.isHidden = true
        self.loginInstance?.requestDeleteToken()
        
  
    }
    // MARK: 웹뷰 처음 띄워줄떄 
    func abc(){
        let url = URL(string: "http://babyhoney.kr/login")!
        webView.load(URLRequest(url: url))
    }
    // MARK: bridge
    func registerHandeler(){
        bridge.registerHandler(handlerName: "$.callFromWeb", handler: { [weak self] (data, responseCallback) in
            let jsonData = data as? [String: String]
            let emailData = try! JSONSerialization.data(withJSONObject: jsonData!, options: .prettyPrinted)
            let dataResult = try? self?.decoder.decode(EmailChange.self, from: emailData)
            let currentEmail = dataResult??.userInfo
            switch jsonData{
            case ["cmd":"loginKakao"]:
                self?.kakaoLogin()
            case ["cmd":"loginNaver"]:
                self?.loginInstance?.requestThirdPartyLogin()
            case ["userInfo" : "\(currentEmail!)", "cmd" : "open_profile"]:
                self?.emailCheck(currentEmail!)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Girl") as! GirlVC
                vc.notiFlag = true
                
                
                self?.present(vc, animated: true, completion: nil)
            default:
                break
            }
        })
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func liveChat(_ sender: Any) {
        SocketIO.shared.socketConnetion()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            SocketIO.shared.enterChatLive(self.memId, self.chatName, self.memPhoto)
        }
        
        
        let vc = UIStoryboard(name: "ChattingUI", bundle: nil).instantiateViewController(identifier: "ChattingUI") as! SocketViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    deinit {
        print("Login VC")
    }
}

extension Login{
    // MARK: 카카오
    func kakaoLogin(){
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    //do something
                    _ = oauthToken
                    
                    self.emailCheck(self.kakaoEmail)
                }
            }
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                self.kakaoEmail = user?.kakaoAccount?.email ?? ""
                //do something
                _ = user
            }
        }
    }
    
    // MARK: 이메일 가입 확인
    func emailCheck(_ email : String){
        print("email -> \(email)")
        let url = URL(string: "http://babyhoney.kr/api/member/\(email)")!
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default).responseJSON{ [weak self] response  in
                    switch response.result {
                        case .success(let ok):
                            guard let data = try? JSONSerialization.data(withJSONObject: ok, options: .prettyPrinted) else
                            { return }
                            guard let result = try? self?.decoder.decode(EmailCheck.self, from: data) else {
                                return }
                            if result?.isMember == false{
                                let vc = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(identifier: "CreateAccount") as CreateAccount
                                vc.delegate = self
                                vc.modalPresentationStyle = .fullScreen
                                vc.receiveEmail = email
                                self?.present(vc, animated: true, completion: nil)
                            }
                            else{
                                guard let result2 = try? self?.decoder.decode(EmailCheck2.self, from: data) else { return }
                                let conts = result2?.memInfo.contents
                                self?.memId = result2?.memInfo.email ?? ""
                                self?.chatName = result2?.memInfo.name ?? ""
                                self?.memPhoto = result2?.memInfo.profileImage ?? ""
                                let redirectURl = result2?.redirectURL
                                print("result login : \(result2)")
                                NotificationCenter.default.post(name: NSNotification.Name("이름"), object: nil, userInfo: ["이름":"\(result2!.memInfo.name)", "소개글":"\(result2!.memInfo.contents)", "이미지":"\(result2!.memInfo.profileImage)", "성별":"\(result2!.memInfo.gender)" ,"나이":"\(result2!.memInfo.age)", "이메일":"\(result2!.memInfo.email)"])
                            
                                if self?.pageOn == false {
                                    self?.pageOpen(email)
                                    self?.liveChatBtn.isHidden = false
                                    self?.registerHandeler()
                                }
                                else{
                                    self?.registerHandeler()
                                }
                                
                            }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
    // MARK: webView
    func pageOpen(_ email : String){
        print("email \(email)")
       let url = URL(string: "http://babyhoney.kr/member/list/\(email)")!
       webView.load(URLRequest(url: url))
        pageOn = true
    }
    
    // MARK: NAVERLOGIN
    // 로그인에 성공한 경우 호출
        func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
            print("Success login")
            naverLogin()
           
        }
        
        // referesh token
        func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
            loginInstance?.accessToken
        }
        
        // 로그아웃
        func oauth20ConnectionDidFinishDeleteToken() {
            print("log out")
        }
        
        // 모든 error
        func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
            print("error = \(error.localizedDescription)")
        }
    
        func naverLogin(){
            guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
              
              if !isValidAccessToken {
                return
              }
    
              guard let tokenType = loginInstance?.tokenType else { return }
              guard let accessToken = loginInstance?.accessToken else { return }
                
              let urlStr = "https://openapi.naver.com/v1/nid/me"
              let url = URL(string: urlStr)!
              
              let authorization = "\(tokenType) \(accessToken)"
              
              let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
              
              req.responseJSON { response in
                guard let result = response.value as? [String: Any] else { return }
                guard let object = result["response"] as? [String: Any] else { return }
                
                guard let email = object["email"] as? String else { return }
                
                
                self.naverEmail = email
                self.emailCheck(self.naverEmail)
              }
            }
}
