//
//  FullImage.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/11.
//
// 전체보기 버튼 누를 시, 이미지들 전부다 출력

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire

class ViewAll: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet var viewAllCollectionView: UICollectionView!
    // 데이터를 전달받기 위한 photolist2
    var photolist2 : [String] = []
    var subscribeBtnCompletionClosure: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAllCollectionView.delegate = self
        viewAllCollectionView.dataSource = self
    }
    
    // 닫기버튼
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
// 컬렉션뷰 -> 데이터를 전달받아서 kingfisher를 이용해서 출력
extension ViewAll{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photolist2.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCell", for: indexPath) as? AllCell else{
            return UICollectionViewCell()
        }
        let url = URL(string: "\(photolist2[indexPath.row])")
        cell.allimg.kf.setImage(with: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (viewAllCollectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        return CGSize(width: width, height: height)
    }
}

class AllCell: UICollectionViewCell{
    @IBOutlet var allimg: UIImageView!
}
