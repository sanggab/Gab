//
//  HalfVC.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/06.
//
//
//  MainVC.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/07.
//

import Foundation
import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire

class GirlVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var likeView: UIView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var backImg: UIImageView!
    @IBOutlet var genderImg: UIImageView!
    @IBOutlet var locView: UIView!
    @IBOutlet var imgback: UIImageView!
    @IBOutlet var l_code: UILabel!
    @IBOutlet var collectionView2: UICollectionView!
    @IBOutlet var girlImg: UIImageView!
    @IBOutlet var fullButton: UIButton!
    @IBOutlet var likeCnt: UILabel!
    @IBOutlet var chatCnt: UILabel!
    @IBOutlet var fvBtn: UIButton!
    @IBOutlet var totalCnt: UILabel!
    @IBOutlet var genderView: UIView!
    var notiFlag = false
    var photolist: [String] = []
    var imgnm: Int = 0
    var keyboardRect = CGRect.zero
    var deleteEmail  = ""
    var bounds = UIScreen.main.bounds
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    var gender = "F"
    var socketNoti = false
    var socketage = ""
    var socketImage = ""
    var socketGender = "F"
    var socketconts = ""
    var socketName = ""
    var socketEmail = ""
    var currentGender = ""
    @IBOutlet var corView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let gender = socketGender
        let up = gender.uppercased()
        if up == "F"{
            genderView.borderColor = #colorLiteral(red: 0.986030519, green: 0.7601245642, blue: 0.8071667552, alpha: 1)
        }
        else {
            genderView.borderColor = #colorLiteral(red: 0.785386622, green: 0.827813983, blue: 0.9765190482, alpha: 1)
        }
       
        
    }
    
    
    override func viewDidLoad() {
        deleteBtn.isHidden = true
        self.collectionView2.delegate = self
        self.collectionView2.dataSource = self
        
        profileView.clipsToBounds = true
        profileView.cornerRadius = 20
        likeView.borderWidth = 1
        likeView.borderColor = #colorLiteral(red: 1, green: 0.8943989277, blue: 0.8930781484, alpha: 1)
        likeView.cornerRadius = 17
        
        genderView.borderWidth  = 1
        
        genderView.cornerRadius = 10
        
        locView.cornerRadius = 13
        locView.borderWidth = 1
        locView.borderColor = #colorLiteral(red: 0.7914505601, green: 0.8681007028, blue: 0.9355227351, alpha: 1)
        
        chatCnt.clipsToBounds = true
        chatCnt.borderColor = #colorLiteral(red: 0.9249405265, green: 0.9250735641, blue: 0.9249115586, alpha: 1)
        chatCnt.borderWidth = 1
        chatCnt.cornerRadius = 5
        
        imgback.cornerRadius = imgback.frame.height / 2
        girlImg.cornerRadius = girlImg.frame.width / 2
        
        fullButton.cornerRadius = 10
        
        // MARK: noti가 없다면 기본실행
        if notiFlag == false{
            getTest(gender)
        }
        
        
        // MARK: noti 존재한다면 아래 실행
        if notiFlag == true{
            
            if socketNoti == true{
                socketProfile()
            }
            else{
                
                NotificationCenter.default.addObserver(self, selector: #selector(test(_:)), name: NSNotification.Name("이름"), object: nil)
                deleteBtn.isHidden = false
            }
        }
        
        
        
        
        
        
    }
    // MARK: 회원 삭제 버튼
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteMem =  UIAlertAction(title: "회원삭제", style: .default) { (action) in
            let alert = UIAlertController(title: "회원삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.deleteMem(email: self.deleteEmail)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        let reviseMem =  UIAlertAction(title: "회원수정", style: .default) { (action) in
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(deleteMem)
        alert.addAction(reviseMem)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    // MARK: 회원삭제
    func deleteMem(email: String){
        let url = URL(string:  "http://babyhoney.kr/api/member/\(email)")!
        print("email : \(email)")
        AF.request(url, method: .delete).responseJSON { response in
            switch response.result{
            case .success(let ok):
                print(ok)
            case .failure(let error):
                print(error)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: 이름, 소개글, 이미지, 성별, 나이 
    @objc func test(_ notification:NSNotification){
        print("result2 -- :\(notification.userInfo!["이름"]! as! String)")
        nameLabel.text! = notification.userInfo!["이름"]! as! String
        chatCnt.text! = notification.userInfo!["소개글"]! as! String
        let url = URL(string: "\(notification.userInfo!["이미지"]! as! String)")
        girlImg.kf.setImage(with: url)
        girlImg.contentMode = .scaleAspectFill
        let gender = notification.userInfo!["성별"]! as! String
        let up = gender.uppercased()
        if up == "F"{
            genderImg.image = UIImage(named: "woman")
        }
        else{
            genderImg.image = UIImage(named: "men")
            backImg.image = UIImage(named: "img_profile_line_m")
            genderView.borderColor = #colorLiteral(red: 0.785386622, green: 0.827813983, blue: 0.9765190482, alpha: 1)
            
        }
        
        ageLabel.text! = notification.userInfo!["나이"]! as! String
        if !(genderImg.image == UIImage(named: "woman")){
            ageLabel.textColor = #colorLiteral(red: 0.3648072183, green: 0.4939571023, blue: 0.909740448, alpha: 1)
        }
        
        deleteEmail = notification.userInfo!["이메일"]! as! String
    }
    
    // MARK: 소켓부분
    func socketProfile(){
        nameLabel.text = socketName
        chatCnt.text = socketconts
        let url = URL(string: "\(socketImage)")
        girlImg.kf.setImage(with: url)
        girlImg.contentMode = .scaleAspectFill
        let gender = socketGender
        let up = gender.uppercased()
        if up == "F"{
            genderImg.image = UIImage(named: "woman")
        }
        else{
            genderView.borderColor = #colorLiteral(red: 0.785386622, green: 0.827813983, blue: 0.9765190482, alpha: 1)
            genderImg.image = UIImage(named: "men")
            backImg.image = UIImage(named: "img_profile_line_m")
            
        }
        ageLabel.text = socketage
        if !(genderImg.image == UIImage(named: "woman")){
            ageLabel.textColor = #colorLiteral(red: 0.3648072183, green: 0.4939571023, blue: 0.909740448, alpha: 1)
        }
        deleteEmail = socketEmail
        
    }
    
    
    // 전체보기 버튼, 누르면 해당 뷰 컨트롤러 호출, 데이터 전달
    @IBAction func ViewAllButton(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAll") as! ViewAll
        vc.photolist2 = photolist
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func sendstorybtn(_ sender: UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let view = SendStoryView(frame: CGRect(x: 0, y: self.view.frame.height - 239  , width: bounds.size.width, height: 239))
        self.view.addSubview(view)
    }
    deinit {
        print("GirlVC deinit")
        NotificationCenter.default.removeObserver(self)
    }
}

extension GirlVC{
    func getTest(_ gender : String) {
        let url = URL(string: "http://babyhoney.kr/api/profile")!
        let param: Parameters = [
            "cmd" : "getProfile",
            "gender" : "\(gender)",
            "id" : "ID"
        ]
        let decoder = JSONDecoder()
        AF.request(url,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseJSON{ response  in
                    switch response.result {
                    case .success(let ok):
                        guard let data = try? JSONSerialization.data(withJSONObject: ok, options: .prettyPrinted) else{
                            return
                        }
                        do{
                            print(data)
                            let result = try decoder.decode(Profile.self, from: data)
                            
                            let result2 = result.result.member
                            
                            self.nameLabel.text = result2.chatName
                            self.ageLabel.text = result2.memAge
                            self.chatCnt.text = result2.chatConts
                            self.l_code.text = result2.lCode
                            self.likeCnt.text = result2.totLikeCnt
                            
                            let url = URL(string: result.result.photo.defPhoto)
                            self.girlImg.kf.setImage(with: url)
                            for i in 0...8 {
                                self.photolist.append(result.result.photo.photoList[i].url)
                            }
                            DispatchQueue.main.async {
                                self.collectionView2.reloadData()
                            }
                        }
                        catch {
                            print(error)
                            print("catch")
                        }
                    case .failure(_):
                        print("fail")
                    }
                    
                   }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photolist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell" , for: indexPath) as? GridCell else { return
            UICollectionViewCell() }
        cell.colimg2.cornerRadius = 15
        let url = URL(string: "\(photolist[indexPath.row])")
        cell.colimg2.kf.setImage(with: url)
        totalCnt.text = "총" + " \(photolist.count)개"
        let attributedStr = NSMutableAttributedString(string: totalCnt.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (totalCnt.text! as NSString).range(of: "\(photolist.count)"))
        totalCnt.attributedText = attributedStr
        
        
        return cell
    }
    
    // 셀을 클릭하였을 때, 스토리보드 호출, 데이터를 전달
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullImage") as! FullImageView
        
        vc.photolist3 = self.photolist
        self.imgnm = indexPath.item
        vc.path = indexPath
        vc.imgnumber = self.imgnm
        print("imgnm = \(self.imgnm)")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
class GridCell: UICollectionViewCell{
    @IBOutlet var colimg2: UIImageView!
    
}
