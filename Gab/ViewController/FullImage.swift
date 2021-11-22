//
//  SubView.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/11.
//

import Foundation
import UIKit
import Kingfisher

class FullImageView: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var path: IndexPath?
    @IBOutlet var fullimg2: UIImageView!
    var currentIdx: CGFloat = 0.0
    @IBOutlet var fullcollectionView: UICollectionView!
    @IBOutlet var imageCell: FullImageCell!
    
    var subscribeBtnCompletionClosure: (() -> Void)?
    var a = 0
    var b = 0
    
    @IBOutlet var viewBack: UIView!
    override func viewDidLoad() {
      
        super.viewDidLoad()
//        setupFlowLayout()
        cellLayout()
        fullcollectionView.dataSource = self
        fullcollectionView.delegate = self
//        print("--> \(fullcollectionView)")
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            [weak self] in 
            self?.fullcollectionView.setContentOffset(CGPoint(x: Int(self!.fullcollectionView.frame.width) * self!.imgnumber , y: 0), animated: false)
            
        }
    }
    var photolist3: [String] = []
    var imgnumber: Int = 0
    
    @IBAction func dismissbutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
     }
}

extension FullImageView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("cnt :: \(photolist3.count)")
        
        return photolist3.count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullImageCell", for: indexPath) as? FullImageCell else
        { return  UICollectionViewCell() }
        
        
        let url = URL(string: "\(photolist3[indexPath.item])")
        cell.fulimg.kf.setImage(with: url)
        
        return cell
    }

 
//
//    private func setupFlowLayout(){
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsets.zero
//        flowLayout.minimumInteritemSpacing = 10
//        flowLayout.minimumLineSpacing =  100
//
//        let halfwidth = UIScreen.main.bounds.width
//        flowLayout.itemSize = CGSize(width: halfwidth * 0.9, height: halfwidth * 0.9)
//        self.fullcollectionView.collectionViewLayout = flowLayout
//    }
    func cellLayout(){
        let cellSize = CGSize(width: fullcollectionView.frame.width , height: fullcollectionView.frame.height )
//        print("viewBack bounds width : \(viewBack.bounds.width)")
//        print("viewBack frame width : \(viewBack.frame.width)")
//        print("viewBack bounds height : \(viewBack.bounds.height)")
//        print("viewBack frame height : \(viewBack.frame.height)")
//        print("UIScreen bounds width : \(UIScreen.main.bounds.width)")
//        print("UIScreen bounds height : \(UIScreen.main.bounds.height)")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1.0
        
        fullcollectionView.setCollectionViewLayout(layout, animated: false)
//        print("cellSize : \(cellSize)")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("-- \(fullcollectionView.contentOffset.x)")
    }
    
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullcollectionView.frame.width, height: fullcollectionView.frame.height)
    }
    

    
}
class FullImageCell: UICollectionViewCell{
    @IBOutlet var fulimg: UIImageView!
}
