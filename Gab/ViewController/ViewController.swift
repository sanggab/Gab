//
//  ViewController.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/06.
//

import UIKit
import Alamofire
import SwiftyJSON
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import WebKit
import XHQWebViewJavascriptBridge


class ViewController: UIViewController{
    
    @IBOutlet var storyButton: UIButton!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var socketBtn: UIButton!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
    }

    
    // 버튼을 눌러서 해당 스토리보드 출력
    @IBAction func onModalButton(_ sender: UIButton) {
        switch sender{
        // 사연리스트
        case storyButton :
            let vc = UIStoryboard(name: "ReceiveStory", bundle: nil).instantiateViewController(identifier: "ReceiveStory") as! ReceiveStory
            self.present(vc, animated: false, completion: nil)
            
        // 프로필
        case profileButton :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Girl") as! GirlVC
            print("vc : \(vc)")
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
}


