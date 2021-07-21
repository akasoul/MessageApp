//
//  TableViewCell.swift
//  MessageApp
//
//  Created by Anton Voloshuk on 21.07.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    var cellData: MessageListElement?{
        didSet{
            guard let data = self.cellData
            else{
                return
            }
            var dateStr=""
            if let date=data.date{
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                dateStr=formatter.string(from: date)
                let calendar = Calendar.current
                if(calendar.isDateInToday(date)){
                    dateStr = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date))
                }
                if(calendar.isDateInYesterday(date)){
                    dateStr="Yesterday"
                }
            }
            
            self.avatar.image=data.avatar
            self.name.text=data.nickname
            self.date.text=dateStr
            self.message.text=data.text
        }
    }
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let img = UIImage(systemName: "chevron.right")
        self.arrow.image=img
        self.arrow.tintColor = .gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
