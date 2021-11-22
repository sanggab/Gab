//
//  ReceiveStory.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/22.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

class ReceiveStory: UIViewController, customProtocol1{
//    var cellDatas: [List] = []
    var flag = false
    @IBOutlet var receiveStoryTableView: UITableView!
    var fetchingMore = false
    let currentDate = Date()
    var time = 0
    var defaultImage = "img_default_s"
    var total_page = 1
    var current_page = 1
    var abc4: [List] = []

//    var sortedList:[Result1]{
//        let sortedList =  abc.sorted{
//            prev, next in
//            return prev.insdate > next.insdate
//        }
//        return sortedList
//    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "ReceiveStoryTableViewCell", bundle: nil)
        receiveStoryTableView.register(nibName, forCellReuseIdentifier: "ReceiveStoryCell")

        // tableview cell 높이 120 제한
        self.receiveStoryTableView.rowHeight = UITableView.automaticDimension
        self.receiveStoryTableView.estimatedRowHeight = 120
        
        receiveStoryTableView.delegate = self
        receiveStoryTableView.dataSource = self
        afStory(1)
    }
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ReceiveStory: UITableViewDataSource, UITableViewDelegate{
//    func sortedStory(at index: Int) -> Result1{
//        return sortedList[index]
//    }
    private func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    
    func afStory(_ number: Int){
        self.flag = true
        let url = URL(string: "http://babyhoney.kr/api/story/page/\(number)")!
        let parameter : Parameters = [
            "bj_id" : "kappa2490"
        ]
        let decoder = JSONDecoder()
        AF.request(url, method: .get,
                   parameters: parameter, encoding: URLEncoding.queryString).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let ok):
                        guard let data = try? JSONSerialization.data(withJSONObject: ok, options: .prettyPrinted) else{
                            return
                        }
                        do{
                            let result = try decoder.decode(SendStory.self, from: data)
                            self.total_page = result.total_page
                            self.current_page = result.current_page
//                            var abc3 = self.abc.sorted(by: { $0.insdate > $1.insdate })
                            for i in 0...result.list.count-1{
                                self.abc4.append(result.list[i])
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                self.receiveStoryTableView.tableFooterView = nil
                                self.receiveStoryTableView.reloadData()
                                self.flag = false
                            }
                        }
                        catch{
                            print(error)
                        }
                    case . failure(_):
                        print("fail")
                    }
                   })
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (current_page * 5) < total_page && indexPath.row == abc4.count-1 {
//            print("-> indexPath: \(indexPath.row)")
//            print("-> ab4 : \(abc4.count)")
//            print("total -> \(total_page)")
//            print("current -> \(current_page)")
//            print("11")
//            index = indexPath.row
//            current_page = current_page + 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                           self.afStory(self.current_page)
//                       }
//        }
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentheight = scrollView.contentSize.height
        if offsetY > contentheight - scrollView.frame.height{
            print("offsetY : \(offsetY)")
            print("contentheight: \(contentheight)")
            print("frame.height: \(scrollView.frame.height)")
          
            if (current_page * 5) < total_page && flag == false{
                print("1")
                current_page = current_page + 1
                DispatchQueue.main.async{
                    print("11")
                    self.receiveStoryTableView.tableFooterView = self.createSpinnerFooter()
                               self.afStory(self.current_page)
                           }
            

            }
        }
    }
        
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abc4.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveStoryCell") as? ReceiveStoryTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        sortStory(indexPath: indexPath.row)
 
        
        let mins = (time / 60)
        cell.contsLabel.text = abc4[indexPath.row].storyConts
        cell.nameLabel.text = abc4[indexPath.row].sendChatName
        let sec = (time % 60)
        if mins < 11{
            if mins == 0{
                cell.timeLabel.text = "\(sec)초전"
            }
            else{
                cell.timeLabel.text = "\(mins)분전"
            }
          }
        else{
            cell.timeLabel.text = "오래전"
          }
        
        
        if abc4[indexPath.row].sendMemPhoto == "" {
            let img = UIImage(named: defaultImage)
            cell.profileImg.image = img
        }
        else{
            let url = URL(string: abc4[indexPath.row].sendMemPhoto)
            cell.profileImg.kf.setImage(with: url )
            cell.contsLabel.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2959735682)
            
        }
        cell.deleteBtn.tag = indexPath.row
        cell.delegate = self
       
        return cell
       
        
    }
    

    func delBtn(_ tag: Int) {
        let indexPath = IndexPath(row: tag, section: 0)
        print("indexPath : \(indexPath)")
        print("tag : \(tag)")
        abc4.remove(at: tag)
        receiveStoryTableView.deleteRows(at: [indexPath], with: .fade)
        receiveStoryTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("--> 해당셀 indexPath : \(indexPath.row)")
    }
}
    
    
extension ReceiveStory{
    func sortStory(indexPath: Int){
        let dateString: String = abc4[indexPath].insdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: dateString)!
        let useTime = Int(currentDate.timeIntervalSince(date))
        time = useTime
    }
    
}
