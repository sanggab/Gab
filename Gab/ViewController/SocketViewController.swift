//
//  Socket.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/11.
//

import Foundation
import UIKit
import SocketIO
import Kingfisher
import Alamofire
import Lottie

class SocketViewController: UIViewController, UITextViewDelegate, customProtocol3{
    
    
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var chattingTable: UITableView!
    @IBOutlet var msgView: UITextView!
    @IBOutlet var sendMsgBtn: UIButton!
    @IBOutlet var scrollBottom: UIButton!
    @IBOutlet var allView: UIView!
    @IBOutlet var viewBottom: NSLayoutConstraint!
    @IBOutlet var graImg: UIImageView!
    static let oad = SocketViewController()
    
    let toastLabel =  ToastLabel()
    let gradient = CAGradientLayer()
    let heartImg = ["an_like_01", "an_like_02", "an_like_03", "an_like_04", "an_like_05"]
    let animationView = AnimationView(name: "lf30_editor_l1k8ykjh")
    var lastMsgText = ""
    let LoginData = Login.loginShared
    var getSocket = SocketIO.shared.getSocket()
    var socket : SocketIO?
    var userCount = 1
    var chatModel = [RecevieMsg]()
    let decoder = JSONDecoder()
    
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        hideKeyboard()
        msgView.isScrollEnabled = false
        msgView.text = "대화를 입력하세요"
        msgView.cornerRadius = 15
        msgView.backgroundColor = .white
        sendMsgBtn.isHidden = true
        lottie()
        
        msgView.textContainer.maximumNumberOfLines = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        msgView.textContainerInset = UIEdgeInsets(top: 8.5, left: 10, bottom: 8, right: 3)
        
        msgView.delegate = self
        scrollBottom.isHidden = true
        rcvMsg()
        
        let nibName = UINib(nibName: "ChattingCell", bundle: nil)
        chattingTable.register(nibName, forCellReuseIdentifier: "ChattingCell")
        let nibName2 = UINib(nibName: "System", bundle: nil)
        chattingTable.register(nibName2, forCellReuseIdentifier: "SystemMsg")
        
        self.chattingTable.rowHeight = UITableView.automaticDimension
        self.chattingTable.estimatedRowHeight = 120
        chattingTable.delegate = self
        chattingTable.dataSource = self
        
        chattingTable.transform = CGAffineTransform(rotationAngle: -((CGFloat)(Double.pi)))
    }
    // 그라데이션
    func setGradient(){
        gradient.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        gradient.locations = [0.5 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = graImg.bounds
        graImg.layer.mask = gradient
    }
    
    @IBAction func dismiss(_ sender: Any) {
        SocketIO.shared.reqRoomOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeBtnClicekd(_ sender: Any) {
        likeBtn.isEnabled = false
        likeBtn.setImage(UIImage(named: "btn_bt_heart_off"), for: .normal)
        animationView.stop()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(buttonTime), userInfo: nil, repeats: false)
        SocketIO.shared.sendLike()
        
    }
    
    @objc func buttonTime(){
        likeBtn.isEnabled = true
        likeBtn.setImage(UIImage(named: "btn_bt_heart_on"), for: .normal)
        animationView.play()
    }
    
    // 메세지 보내기
    @IBAction func sendMsgClicked(_ sender: Any) {
        SocketIO.shared.sendMsg(msgView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        msgView.text = ""
    }
    
    // 아래로 이동 버튼 누르면 contentOffset.y = 0 인 곳으로 이동하기
    @IBAction func scrollBottomBtnClicked(_ sender: Any) {
        chattingTable.contentOffset.y = 0
        scrollBottom.isHidden = true
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        sendMsgBtn.isHidden = false
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.viewBottom?.constant = keyboardSize.height - self.view.safeAreaInsets.bottom
            print("self.viewBottom : \(self.viewBottom.constant)")
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        sendMsgBtn.isHidden = true
        if self.viewBottom?.constant != 0{
            self.viewBottom?.constant = 0
            
        }
    }
    
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        msgView.endEditing(true)
        
    }
    
    // message 이벤트 받기위한 함수
    func rcvMsg(){
        
        getSocket.on("message") {[weak self] dataArray, ack in
            let jsondata = try! JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
            let result = try! self?.decoder.decode(RecevieMsg.self, from: jsondata)
            print("result : \(result)")
            let cmd = result?.cmd
            
            switch cmd{
            case "rcvChatMsg", "rcvSystemMsg":
                self?.chatModel.insert(result!, at: 0)
            case "rcvPlayLikeAni":
                self?.animation()
            case "rcvAlertMsg":
                self?.alertMsg(result?.msg ?? "공지없다")
            case "rcvToastMsg":
                self?.showToast(message: result?.msg ?? "메세지없다")
            default:
                break
            }
            DispatchQueue.main.async {
                self?.chattingTable.reloadData()
            }
        }
    }
    
    // 알럿메세지
    func alertMsg(_ msg : String){
        let alert =  UIAlertController(title: "공지", message: "\(msg)", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        let cancle = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        alert.addAction(cancle)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 토스트메세지 보여주기.
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        
        self.view.addSubview(toastLabel)
        
        toastLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: self.msgView.topAnchor, constant: -10).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: self.allView.centerXAnchor).isActive = true
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: { self.toastLabel.alpha = 0.0 }, completion: {(isCompleted) in self.toastLabel.removeFromSuperview() })
    }
    
    // 100글자 제한.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = msgView.text ?? ""
        guard let stringRange = Range(range, in : currentText) else { return false}
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        let trimmingText = changedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let countTrimming = trimmingText.utf8.count
        return countTrimming < 100
    }
    
    // 썸네일을 눌렀을 경우, 해당 이메일 가져오고나서 이메일 체크해서 프로필 띄워주기
    func profileBtn(_ tag: Int) {
        let currentEmail = chatModel[tag].from?.memID
        self.emailCheck(currentEmail!)
    }
    
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
                        
                        guard let result2 = try? self?.decoder.decode(EmailCheck2.self, from: data) else { return }
                        print("result222 : \(result2)")
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Girl") as! GirlVC
                        vc.socketage = result2?.memInfo.age ?? ""
                        vc.socketconts = result2?.memInfo.contents ?? ""
                        vc.socketImage = result2?.memInfo.profileImage ?? ""
                        vc.socketGender = result2?.memInfo.gender ?? ""
                        vc.socketName = result2?.memInfo.name ?? ""
                        vc.socketEmail = result2?.memInfo.email ?? ""
                        
                        vc.socketNoti = true
                        vc.notiFlag = true
                        self?.present(vc, animated: true, completion: nil)
                        
                    case .failure(let error):
                        print(error)
                    }
                   }
    }
    
    deinit {
        print("SocketVC")
        NotificationCenter.default.removeObserver(self)
        animationView.removeFromSuperview()
    }
    
    
}
extension SocketViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingCell") as? ChattingCell else { return
            UITableViewCell()}
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "SystemMsg") as? ChattingCell else { return UITableViewCell()}
        
        if chatModel[indexPath.row].cmd == "rcvSystemMsg"{
            
            cell2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cell2.systemMsg.text = chatModel[indexPath.row].msg
            cell2.selectionStyle = .none
            
            return cell2    
        }
        else {
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cell.chatName.text = chatModel[indexPath.row].from?.chatName
            cell.msgLabel.text = chatModel[indexPath.row].msg
            let url = URL(string: chatModel[indexPath.row].from?.memPhoto ?? "dd")!
            cell.profileImg.kf.setImage(with: url)
            cell.delegate = self
            cell.profileBtn.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    // 스크롤할때 contentOffset이 0이면 아래로 이동 버튼 비활성화 , 0이 아닐경우 아래로 이동 버튼 활성화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollBottom.isHidden = false
        let offsetY = scrollView.contentOffset.y
        if offsetY == 0.0{
            scrollBottom.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        msgView.text = lastMsgText
        msgView.textColor = #colorLiteral(red: 0.2006734014, green: 0.2007081211, blue: 0.2006658018, alpha: 1)
        let trimming = msgView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimcount = trimming.count
        if trimcount < 1 {
            sendMsgBtn.isEnabled = false
        }
        else{
            sendMsgBtn.isEnabled = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let trimming = msgView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimcount = trimming.count
        if trimcount < 1 {
            sendMsgBtn.isEnabled = false
        }
        else{
            sendMsgBtn.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        lastMsgText = msgView.text
    }
    
    
    
}


extension SocketViewController{
    
    // 하트 애니메이션
    func animation(){
        let totalTime = Double.random(in: 5.5...6)
        for _ in 0...6{
            let startX = Double.random(in: 0...60)
            let startY = Double(self.view.bounds.size.height) - Double.random(in: 0...80)
            let bSize = Int.random(in: 20...30)
            let heart = self.heartImg.randomElement()!
            print("heart : \(heart)")
            let img  = UIImage(named: "\(heart)")
            let imgView = UIImageView(image: img)
            imgView.frame = CGRect(x: startX, y: startY, width: 50, height: 50)
            self.view.addSubview(imgView)
            UIView.animateKeyframes(withDuration: 3, delay: 0, options: .calculationModePaced) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15*totalTime){
                    imgView.alpha = 1
                    
                    imgView.frame = CGRect(x: CGFloat(startX + Double.random(in: -75...75)), y: CGFloat(startY - Double.random(in: 100...150)), width: 50, height: 50)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.15*totalTime, relativeDuration: 0.55*totalTime) {
                    imgView.alpha = 1
                    imgView.frame = CGRect(x: CGFloat(startX + Double.random(in: -75...75)), y: CGFloat(startY - Double.random(in: 250...300)), width: CGFloat(50 + bSize) , height: CGFloat(50 + bSize))
                }
                UIView.addKeyframe(withRelativeStartTime: 0.7*totalTime, relativeDuration: 0.3*totalTime) {
                    imgView.alpha = 0
                    imgView.frame = CGRect(x: CGFloat(startX + Double.random(in: -75...75)), y: CGFloat(Double.random(in: 0...80)), width: CGFloat(70 + bSize ), height: CGFloat(70 + bSize))
                }
            }
        }
    }
    // MARK: Lottie
    func lottie(){
        self.allView.addSubview(animationView)
        animationView.loopMode = .loop  // 무한루프 설정
        
        // 로티 제약조건 설정
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: likeBtn.centerYAnchor).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        animationView.contentMode = .scaleAspectFit
        
        // 뒤에버튼 터치가능하게 설정
        animationView.isUserInteractionEnabled = false
        animationView.play()
        
    }
    
}

// 커스텀 토스트메세지
class ToastLabel : UILabel{
    // 좌우간격 5 설정
    let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    // 토스트메세지 생성할때 여백넣어주기
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    // 여백 넣어주고나서 contentSize에 그 여백만큼 더하기 , 더하지 않으면 텍스트 깨짐
    override var intrinsicContentSize: CGSize {
        
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        
        return contentSize
    }
}
