//
//  CreateAccount.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/04.
//

import Foundation
import UIKit
import Alamofire
import WebKit

protocol pageopen {
   func pageOpen(_ email: String)
}

class CreateAccount: UIViewController, UITextViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
  
   
  
   @IBOutlet var uploadImgBtn: UIButton!
   @IBOutlet var chatName: UITextField!
   @IBOutlet var countLabel: UILabel!
   @IBOutlet var textView: UITextView!
   @IBOutlet var manBtn: UIButton!
   @IBOutlet var girlBtn: UIButton!
   @IBOutlet var yearBtn: UIButton!
   @IBOutlet var monthBtn: UIButton!
   @IBOutlet var daysBtn: UIButton!
   @IBOutlet var signUpBtn: UIButton!
   @IBOutlet var tapView: UIView!
   let imagePicker = UIImagePickerController()
   var textViewPlaceHolder = "소개글을 작성해 주세요"
   var textFieldPalceHolder = "인턴 화이팅"
   var delegate : pageopen?
   let webView = WKWebView(frame: UIScreen.main.bounds)
   var gender = ""
   let calendar = Calendar.current
   let currentDate = Date()
   let dateFormatter = DateFormatter()
   var daysCount: Int = 0
   var age = 0
   var imageData : Data?
   var year = 0
   var month = 0
   var day = 0
   var toolBar = UIToolbar()
   var picker  = UIPickerView()
   var lastBtn = UIButton()
   var receiveEmail = ""
   var datePicker = UIDatePicker()
   var lastText = ""
   var activeText : UITextView? = nil
   
   let gradient: CAGradientLayer = CAGradientLayer()
    override func viewDidLoad() {
      datePicker.maximumDate = NSCalendar.current.date(byAdding: .year, value: -15, to: Date())
      datePicker.minimumDate = NSCalendar.current.date(byAdding: .year, value: -100, to: Date())
        textView.delegate = self
        chatName.delegate = self
        self.imagePicker.delegate = self
        uploadImgBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 48, bottom: 30, right: 0)
        uploadImgBtn.titleEdgeInsets = UIEdgeInsets(top: 60, left: -90, bottom: 0, right: 0)
        uploadImgBtn.imageView?.cornerRadius = 10
        hideKeyboard()
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      setGradient(color1: #colorLiteral(red: 0.5228744745, green: 0.5064840317, blue: 1, alpha: 1), color2: #colorLiteral(red: 0.5971117616, green: 0.4185523987, blue: 0.9986419082, alpha: 1))
      signUpBtnCheck(count: 0)
     print("width: \(UIScreen.main.bounds.width)")
        super.viewDidLoad()
    }
   func hideKeyboard(){
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      view.addGestureRecognizer(tap)
   }
   @objc func dismissKeyboard(){
      textView.endEditing(true)
      chatName.endEditing(true)
      
   }
   // MARK: 버튼 활성화, 비활성화 
   func signUpBtnCheck(count : Int){
      if daysBtn.titleLabel?.text == "일" || monthBtn.titleLabel?.text == "월" || chatName.text == "인턴 화이팅" || count < 10{
        gradient.isHidden = true
         signUpBtn.isEnabled = false
      }
      else {
         gradient.isHidden = false
         signUpBtn.isEnabled = true
         
      }
   }
   // MARK: 생년월일 picker
    @IBAction func pickerBtn(_ sender: UIButton) {
      datePicker.autoresizingMask = .flexibleWidth
      datePicker.preferredDatePickerStyle = .wheels
      datePicker.datePickerMode = .date
      datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
      datePicker.contentMode = .center
      datePicker.backgroundColor = UIColor.white
      datePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)

      self.view.addSubview(datePicker)
      toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.width, height: 50))
      toolBar.barStyle = .blackTranslucent
      toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
      self.view.addSubview(toolBar)
    }
   
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
      datePicker.removeFromSuperview()
      let date = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
      yearBtn.setTitle("\(date.year!)", for: .normal)
      monthBtn.setTitle("\(date.month!)", for: .normal)
      monthBtn.setTitleColor(#colorLiteral(red: 0.3872596622, green: 0.3873197436, blue: 0.3872465491, alpha: 1), for: .normal)
      daysBtn.setTitle("\(date.day!)", for: .normal)
      daysBtn.setTitleColor(#colorLiteral(red: 0.3872596622, green: 0.3873197436, blue: 0.3872465491, alpha: 1), for: .normal)
      year = date.year!
      month = date.month!
      day = date.day!
    }

   // MARK: dismissBtn
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   // MARK: 성별체크
    @IBAction func genderBtn(_ sender: UIButton) {
        switch sender{
        case manBtn:
            manBtn.backgroundColor = #colorLiteral(red: 0, green: 0.8059289455, blue: 1, alpha: 1)
            manBtn.borderWidth = 1
            manBtn.borderColor = .blue
            girlBtn.backgroundColor = .white
            girlBtn.borderWidth = 1
            girlBtn.borderColor = #colorLiteral(red: 0.8766115904, green: 0.8732194901, blue: 0.8730306029, alpha: 1)
           gender = "M"
        case girlBtn:
            girlBtn.backgroundColor = #colorLiteral(red: 1, green: 0.9004606605, blue: 0.9399731159, alpha: 1)
            girlBtn.borderWidth = 1
            girlBtn.borderColor = #colorLiteral(red: 1, green: 0.5969429016, blue: 0.7573990226, alpha: 1)
            manBtn.backgroundColor = .white
            manBtn.borderWidth = 1
            manBtn.borderColor = #colorLiteral(red: 0.8766115904, green: 0.8732194901, blue: 0.8730306029, alpha: 1)
         gender = "F"
        default:
            break
        }
    }
   // MARK: 사진 업로드 버튼
    @IBAction func uploadBtn(_ sender: Any) {
      let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
      
      let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
      }
      
      let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
      self.openCamera()
      }
      
      let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      alert.addAction(library)
      alert.addAction(camera)
      alert.addAction(cancel)
      present(alert, animated: true, completion: nil)
    }
   
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
      present(imagePicker, animated: false, completion: nil)
    }

    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
   
   // MARK: imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadImgBtn.setImage(image, for: .normal)
            uploadImgBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            uploadImgBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            uploadImgBtn.setTitle(nil, for: .normal)
            imageData = image.pngData()
       
        }
        dismiss(animated: true, completion: nil)
    }
   // MARK: 가입 버튼
    @IBAction func signUpBtn(_ sender: Any) {
      calculateDays()
      let header : HTTPHeaders = [
         "Content-Type" : "multipart/form-data"
      ]
      
      let url = URL(string: "http://babyhoney.kr/api/member")!
      AF.upload(multipartFormData: { [self] multipartFormData in
         multipartFormData.append(imageData ?? Data() , withName: "profile_img", fileName: "name.png", mimeType: "image/jpeg")
         multipartFormData.append("\(receiveEmail)".data(using: .utf8)!, withName: "email")
         multipartFormData.append("\(chatName.text!)".data(using: .utf8)!, withName: "name")
         multipartFormData.append("\(age)".data(using: .utf8)!, withName: "age")
         multipartFormData.append("\(textView.text!)".data(using: .utf8)!, withName: "costs")
         multipartFormData.append("\(gender)".data(using: .utf8)!, withName: "gender")
      }, to: url, method: .post, headers: header).responseJSON{ response in
         switch response.result{
         case .success:
            self.delegate?.pageOpen(self.receiveEmail)
            self.dismiss(animated: true, completion: nil)
         case .failure(let error):
            print("error : \(error)")
         }
      }
    }
   deinit {
      NotificationCenter.default.removeObserver(self)
   }
}

extension CreateAccount{
   
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      let currentText = textView.text ?? ""
      guard let stringRange = Range(range, in : currentText) else { return false}
      let changedText = currentText.replacingCharacters(in: stringRange, with: text)
      return changedText.utf8.count < 200
   }
   
   func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      self.activeText = textView
      return true
   }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.text == textViewPlaceHolder{
            textView.text = ""
        }
    }
   
    func textViewDidChange(_ textView: UITextView) {
      let textTrimming = self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
      textView.textColor = #colorLiteral(red: 0.3872596622, green: 0.3873197436, blue: 0.3872465491, alpha: 1)
      let countTrimming = textTrimming.utf8.count
      signUpBtnCheck(count: countTrimming)
      countLabel.text = "\(countTrimming)"
    
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
   
      self.activeText = nil
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if chatName.text == textFieldPalceHolder{
            chatName.text = ""
        }
    }
   // MARK: 나이계산
   func calculateDays(){
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let startDate = dateFormatter.date(from: "\(year)-\(month)-\(day)")!
      daysCount = days(from: startDate)
      age = daysCount / 365
      print("age : \(age)")
   }
   
   func days(from date: Date) -> Int{
      return calendar.dateComponents([.day], from: date, to: currentDate).day! + 1
   }
   
   // MARK: 키보드 올리기, textField랑 textView 구별해서 올려준다.
   @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return }
         var shouldMoveViewUp = false
         if let activeText = activeText{
            let textViewBottomY = activeText.convert(activeText.bounds, to: self.view).maxY
            let visibleRange = view.frame.height - keyboardSize.height
            print("visibleRange : \(visibleRange)")
            print("textViewBottmY: \(textViewBottomY)")
           if textViewBottomY > visibleRange{
               shouldMoveViewUp = true
           }
         }
         if(shouldMoveViewUp){
            self.view.frame.origin.y = 0 - keyboardSize.height
         }
       }
   
   // MARK: 키보드 숨기기
   @objc func keyboardWillHide(notification: NSNotification) {
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }
   }
  // MARK: 그라데이션
   func setGradient(color1:UIColor,color2:UIColor){
      signUpBtn.layoutIfNeeded()
         gradient.colors = [color1.cgColor,color2.cgColor]
         gradient.locations = [0.0 , 1.0]
         gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
         gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
         gradient.frame = signUpBtn.bounds
         gradient.cornerRadius = 25
         signUpBtn.layer.insertSublayer(gradient, at: 0)
         gradient.isHidden = false
         
       }
  
   
}
