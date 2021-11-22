//
//  MemberCodable.swift
//  Gab
//
//  Created by 심상갑 on 2021/10/10.
//



import Foundation

// json 객체를 만들기 위한 Codable

// MARK: - Profile
struct Profile: Codable {
    let status: String
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let photo: Photo
    let member: Member
}

// MARK: - Member
struct Member: Codable {
    let memID, memPhotoSlct, lCode, memAge: String
    let memPhoto: String
    let loc, totLikeCnt: String
    let chatConts: String
    let chatName: String

    enum CodingKeys: String, CodingKey {
        case memID = "mem_id"
        case memPhotoSlct = "mem_photo_slct"
        case lCode = "l_code"
        case memAge = "mem_age"
 
        case memPhoto = "mem_photo"
        case chatConts = "chat_conts"
        case loc, totLikeCnt
  
        case chatName = "chat_name"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let maxCnt: String
    let defPhoto: String
    let photoCERTCnt: Int
    let certYn: String
    let photoList: [PhotoList]
    let yCnt: String
    let avataURL: String
    let cnt: String
    let photoDir: String
    let avataYn: String

    enum CodingKeys: String, CodingKey {
        case maxCnt, defPhoto
        case photoCERTCnt = "photoCertCnt"
        case certYn, photoList, yCnt
        case avataURL = "avataUrl"
        case cnt, photoDir, avataYn
    }
}

// MARK: - PhotoList
struct PhotoList: Codable {
 
    let url: String
    
}

