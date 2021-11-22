//
//  MsgCodable.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/14.
//

import Foundation

// MARK: - RecevieMsg
struct RecevieMsg: Codable {
    let cmd: String
    let from: From?
    let msg: String?
}

// MARK: - From
struct From: Codable {
    let chatName, memID: String
    let memPhoto: String

    enum CodingKeys: String, CodingKey {
        case chatName = "chat_name"
        case memID = "mem_id"
        case memPhoto = "mem_photo"
    }
}
