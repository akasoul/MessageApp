//
//  MessageListModel.swift
//  MessageApp
//
//  Created by Anton Voloshuk on 21.07.2021.
//

import Foundation
import UIKit
import Network

protocol MessageListModelListener: class{
    func update()
    func noInternetAllert()
    func noResponseAlert()
}

class MessageListModel{
    weak var listener: MessageListModelListener?
    var messages = [MessageListElement](){
        didSet{
            self.listener?.update()
        }
    }
    
    init() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if(path.status == .satisfied){
                self.listener?.noInternetAllert()
            }
        }
        monitor.start(queue: .global())
        self.requestMessages()
    }
    
    func getCount()->Int{
        return self.messages.count
    }
    
    func getAt(_ index: Int)->MessageListElement?{
        if(index<self.messages.count){
            return self.messages[index]
        }
        return nil
    }
    
    func requestMessages(){
        guard let url = URL(string: "https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json")
        else{
            return 
        }
        let task = URLSession.shared.dataTask(with: url){ data,response,error in
            guard let data = data
            else{
                self.listener?.noResponseAlert()
                return
            }
            if(response == nil){
                self.listener?.noResponseAlert()
            }
            if(error != nil){
                self.listener?.noResponseAlert()
            }
            
            guard let decoded = try? JSONDecoder().decode(Response.self, from: data)
            else{
                return
            }
            self.messages=[]
            for i in decoded{
                let nickname=i.user?.nickname ?? ""
                let avatarUrl=i.user?.avatarURL ?? ""
                let message=i.message?.text ?? ""
                
                var avatar:UIImage?
                if let url = URL(string: avatarUrl){
                    avatar = try? UIImage(data: Data(contentsOf: url))
                }
                else{
                    avatar = UIImage(named: "AvatarDefault")
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat="yyyy-MM-dd'T'HH:mm:ssZ"
                formatter.timeZone=TimeZone(abbreviation: "UTC")
                
                let date=formatter.date(from: i.message?.receivingDate ?? "")
                
                
                let item = MessageListElement(avatar: avatar, nickname: nickname, text: message, date: date)
                self.messages.append(item)
            }
        }
        task.resume()
    }
}
