//
//  MainVC.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/07.
//

// 남자

import Foundation
import UIKit
import SwiftyJSON
import Kingfisher
import Alamofire

class ManVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var photolist: [String] = []    // photolist url 담기위해 만든 변수 
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var manImg: UIImageView!
    @IBOutlet var l_code: UILabel!
    
    @IBOutlet var likecnt: UILabel!
    @IBOutlet var chatcont: UILabel!

 
    override func viewDidLoad() {
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
     
    }
    
    // 윗 부분 눌렀을 때, 돌아가기 버튼
    @IBAction func dismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ReceiveStoryBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "ReceiveStory", bundle: nil).instantiateViewController(identifier: "ReceiveStory") as! ReceiveStory
        self.present(vc, animated: false, completion: nil)
    }
    
    
}
extension ManVC{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.photolist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell" , for: indexPath) as? gridCell else { return
            UICollectionViewCell() }

        let url = URL(string: "\(photolist[indexPath.row])")
        cell.colimg.kf.setImage(with: url)
        return cell
    }
  
}
class gridCell: UICollectionViewCell{
    
    @IBOutlet var colimg: UIImageView!
    

  
}
