//
//  EmailCodable.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/04.
//

import Foundation

// MARK: - EmailCheck
struct EmailCheck: Codable{
    let code: Int
    let isMember: Bool
    let msg : String
    enum CodingKeys: String, CodingKey{
        case msg
        case isMember = "is_member"
        case code
    }
}

// MARK: - EmailCheck
struct EmailCheck2: Codable {
    let memInfo: MemInfo
    let code: Int
    let isMember: Bool
    let msg, redirectURL: String

    enum CodingKeys: String, CodingKey {
        case memInfo = "mem_info"
        case code
        case isMember = "is_member"
        case msg
        case redirectURL = "redirect_url"
    }
}

// MARK: - MemInfo
struct MemInfo: Codable {
    let name, email: String
    let profileImage: String
    let contents, gender, age: String

    enum CodingKeys: String, CodingKey {
        case name, email
        case profileImage = "profile_image"
        case contents, gender, age
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? ""
        self.contents = (try? container.decode(String.self, forKey: .contents)) ?? "소개글이 없습니다"
        self.gender = (try? container.decode(String.self, forKey: .gender)) ?? ""
        self.age = (try? container.decode(String.self, forKey: .age)) ?? ""
    }
}


struct EmailChange: Codable{
    let userInfo : String
    let cmd : String
}
