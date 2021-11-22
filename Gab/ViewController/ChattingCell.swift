//
//  ChattingCell.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/13.
//

import Foundation
import UIKit

protocol customProtocol3 {
    func profileBtn(_ tag : Int)
}

class ChattingCell: UITableViewCell{
    
    @IBOutlet var systemView: UIView!
    @IBOutlet var msgView: UIView!
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var chatName: UILabel!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var systemMsg: UILabel!
    
    static var memberSend : ChattingCell?
    var delegate : customProtocol3?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .clear
        self.profileImg?.layer.cornerRadius = self.profileImg.frame.height / 2
        msgView?.cornerRadius = 4
        systemView?.cornerRadius = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func profileClicked(_ sender: UIButton) {
        delegate?.profileBtn(sender.tag)
        print("profile clicked")
    }
    
    
}
