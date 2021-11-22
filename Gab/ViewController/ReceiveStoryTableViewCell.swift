//
//  ReceiveStoryTableViewCell.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/22.
//

import UIKit
import Foundation

//
protocol customProtocol1 {
    func delBtn(_ tag : Int)
}

class ReceiveStoryTableViewCell: UITableViewCell {
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var storyView: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var contsLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var labelView: UIView!
    var delegate: customProtocol1?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelView.layer.cornerRadius = 10
        self.profileImg.layer.cornerRadius = profileImg.bounds.size.width / 2
     
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // 삭제버튼
    @IBAction func deleteBtn(_ sender: UIButton) {
        delegate?.delBtn(sender.tag)
        print("sender.tag : \(sender.tag)")
    }
}

