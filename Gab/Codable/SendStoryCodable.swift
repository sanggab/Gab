//
//  SendStoryCodable.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/25.
//

import Foundation


// MARK: - SendStory
struct SendStory: Codable {
    let status: String
    let current_page: Int
    let total_page: Int
    let list: [List]
}

// MARK: - List
struct List: Codable{
   let sendMemGender: String
    let sendMemNo: String
    let sendMemPhoto: String
    let sendChatName,  storyConts, bjID: String
    let readyn: String
    let regno: String
    let insdate: String

    
    enum CodingKeys: String, CodingKey {
        case sendMemGender = "send_mem_gender"
        case sendMemNo = "send_mem_no"
        case sendChatName = "send_chat_name"
        case sendMemPhoto = "send_mem_photo"
        case storyConts = "story_conts"
        case bjID = "bj_id"
        case insdate = "ins_date"
        case regno = "reg_no"
        case readyn = "read_yn"
    }
    
   init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sendMemPhoto = (try? container.decode(String.self, forKey: .sendMemPhoto)) ?? ""
        self.sendMemGender = (try? container.decode(String.self, forKey: .sendMemGender)) ?? ""
        self.sendMemNo = (try? container.decode(String.self, forKey: .sendMemNo)) ?? ""
        self.storyConts = (try? container.decode(String.self, forKey: .storyConts)) ?? ""
        self.bjID = (try? container.decode(String.self, forKey: .bjID)) ?? ""
        self.insdate = (try? container.decode(String.self, forKey: .insdate)) ?? ""
        self.regno = (try? container.decode(String.self, forKey: .regno)) ?? ""
        self.readyn = (try? container.decode(String.self, forKey: .readyn)) ?? ""
        self.sendChatName = (try? container.decode(String.self, forKey: .sendChatName)) ?? ""
    }
   

}

