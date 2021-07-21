//
//  MessageListVC.swift
//  MessageApp
//
//  Created by Anton Voloshuk on 21.07.2021.
//

import Foundation
import UIKit

class MessageListVC: UIViewController{
    private let table = UITableView()
    private let progress = UIProgressView()
    private let label = UILabel()
    private let model = MessageListModel()
    private let cellID="cell"
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Messages"
        
        self.model.listener=self
        self.navigationController?.navigationBar.backgroundColor = .gray
        
        self.view.addSubview(self.table)
        self.table.frame=self.view.bounds
        self.table.delegate=self
        self.table.dataSource=self
        self.table.rowHeight=76
        let cellNib=UINib(nibName: "TableViewCell", bundle: .main)
        self.table.register(cellNib, forCellReuseIdentifier: self.cellID)
        
        self.table.addSubview(self.label)
        self.label.frame=self.table.bounds
        self.label.textAlignment = .center
        self.label.numberOfLines=0
        self.label.font = UIFont.systemFont(ofSize: 15)
        self.label.textColor = .gray
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.table.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.table.setContentOffset(CGPoint(x: 0, y: self.refreshControl.frame.height), animated: true)
        self.model.requestMessages()
    }
}


extension MessageListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let out = self.model.getCount()
        if(out==0){
            self.label.text="Nothing found"
            self.table.separatorStyle = .none
        }
        else{
            self.label.text=""
            self.table.separatorStyle = .singleLine
        }
        return out
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.table.dequeueReusableCell(withIdentifier: self.cellID) as? TableViewCell
        else{
            return UITableViewCell()
        }
        
        guard let data = self.model.getAt(indexPath.item)
        else{
            return UITableViewCell()
        }
        
        cell.cellData=data
        return cell
    }
    
    
}


extension MessageListVC: MessageListModelListener{
    func update(){
        DispatchQueue.main.async{
            self.table.reloadData()
            if(self.refreshControl.isRefreshing){
                self.refreshControl.endRefreshing()
                self.table.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.frame.height), animated: true)
            }
        }
    }
    
    func noResponseAlert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "", message: "No connection to server. Please, try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { i in
                
            }))
            self.present(alert,animated: true)
        }
    }
    
    func noInternetAllert() {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "", message: "No internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { i in
                
            }))
            self.present(alert,animated: true)
        }
    }
}
