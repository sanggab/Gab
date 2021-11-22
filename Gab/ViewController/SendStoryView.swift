//
//  SendStoryView.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/21.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class SendStoryView: UIView, UITextViewDelegate,UIGestureRecognizerDelegate{
    
    var storeConts = "10자 이상 300자 이내로 작성해주세요."
    var displayCountries: [String] = []
    var storeConts2 = ""
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var storyView: UIView!
    @IBOutlet var storyconts: UITextView!
    let gradient: CAGradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        storyconts.delegate = self

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("SendStoryView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        storyconts.text = storeConts
        storyconts.returnKeyType = .done
        sendBtn.isEnabled = false
        storyconts.layer.cornerRadius = 10
        sendBtn.layer.cornerRadius = 15
        setGradient(color1: #colorLiteral(red: 0.5228744745, green: 0.5064840317, blue: 1, alpha: 1), color2: #colorLiteral(red: 0.5971117616, green: 0.4185523987, blue: 0.9986419082, alpha: 1))

    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func sendStoryContsBtn(_ sender: Any) {
        let url = URL(string: "http://babyhoney.kr/api/story")!
        let parameter : Parameters = [
            "send_mem_gender" : "F",
            "send_mem_no" : 123,
            "send_chat_name" : "심상갑",
            "send_mem_photo" : "",
            "story_conts" : "\(storyconts.text!)",
            "bj_id" : "kappa2490"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default)
                .responseJSON{ response  in
                    switch response.result {
                    case .success:
                            print("데이터 전송 완료")
                    case .failure:
                        print("fail")
                    }
                   }
        storyconts.text = ""
        storeConts2 = storyconts.text
        sendBtn.isEnabled = false
        gradient.isHidden = true
        countLabel.text = "0" + " /300"
        
        }

}

extension SendStoryView{
    func textViewDidBeginEditing(_ textView: UITextView) {
        storyconts.text = storeConts2
        countLabel.text = "0" + " /300"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let textTrimming = self.storyconts.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let countTrimming = textTrimming.utf8.count
        countLabel.text = "\(countTrimming)/200"
        
        
        if countTrimming > 9 && countTrimming < 300{
            sendBtn.isEnabled = true
            gradient.isHidden = false
        }
        
        else if countTrimming < 10{
            sendBtn.isEnabled = false
            gradient.isHidden = true
            self.showToast(message: "10자 미만입니다.")
        }
        
        else if countTrimming > 300{
            showToast(message: "300자 넘을 수 없습니다.")
            sendBtn.isEnabled = false
            gradient.isHidden = true
        }
        storeConts2 = storyconts.text
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.storyView.frame.size.width/2 - 75, y: self.storyView.frame.size.height-75, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.storyView.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        hideKeyboardWhenTappedBackground()
        return true
    }
    func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
             tapEvent.cancelsTouchesInView = true   // false하면 보내기 버튼 인식 무시해버림.
             storyView.addGestureRecognizer(tapEvent)

     }
    @objc func dismissKeyboard(){
        storyView.endEditing(true)
    }
    func setGradient(color1:UIColor,color2:UIColor){
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = sendBtn.bounds
        gradient.cornerRadius = 15
        self.sendBtn.layer.insertSublayer(gradient, at: 0)
        gradient.isHidden = true
    }
}

