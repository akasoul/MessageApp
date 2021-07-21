//
//  MessageListStructs.swift
//  MessageApp
//
//  Created by Anton Voloshuk on 21.07.2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? newJSONDecoder().decode(Response.self, from: jsonData)

import Foundation
import UIKit

// MARK: - ResponseElement
struct ResponseElement: Codable {
    var user: User?
    var message: Message?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case message = "message"
    }
}

// MARK: - Message
struct Message: Codable {
    var text: String?
    var receivingDate: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case receivingDate = "receiving_date"
    }
}

// MARK: - User
struct User: Codable {
    var nickname: String?
    var avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickname"
        case avatarURL = "avatar_url"
    }
}

typealias Response = [ResponseElement]




struct MessageListElement{
    var avatar: UIImage?
    var nickname: String?
    var text: String?
    var date: Date?
}
