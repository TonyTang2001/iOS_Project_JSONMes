//
//  MessageListTableViewController.swift
//  MTDoc180806
//
//  Created by 唐子轩 on 2018/8/7.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

struct WebChat: Decodable {
    let stdChat: Int
    let stdMes: [StdMes]
}

struct StdMes: Decodable {
    let from: String
    let to: String
    let type: String
    let content: String
    let time: Int
    let date: String
}

class MessageListTableViewController: UITableViewController {
    
//    var message = [StdMes]()
    var messagenum = 0
    var messages = [StdMes]()
    
    @IBOutlet var listtableView: UITableView!
    
    
    //MARK: Setup Pull to Refresh
    lazy var refresher: UIRefreshControl = {
        
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = UIColor(named: "mainDefaultLightGray")
        refreshCtrl.addTarget(self, action: #selector(loadDataR), for: .valueChanged)
        
        return refreshCtrl
    }()
    
    @objc func loadDataR(){
//        viewDidLoad()
        parsingJSON()
        tableView.reloadData()
        
        let deadline = DispatchTime.now() + .milliseconds(600)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let path = Bundle.main.path(forResource: "std", ofType: "json")
//        let url = URL(fileURLWithPath: path!)
        parsingJSON()
        tableView.reloadData()
        
        tableView.refreshControl = refresher
    }

    func parsingJSON() {
        
        let jsonUrlString = "http://39.104.90.230/webChat/data/store.json"
        guard let url = URL(string: jsonUrlString) else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else { return }
                do {
                    let webChat = try JSONDecoder().decode(WebChat.self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
    //              print(webChat)    //This is what we've Parsed
    //              let index = 0
    //              print(webChat.stdMes[index])  //No.(index-1) of stdMes
                    
                    print(webChat.stdChat)  //Given totalNum# in JSON
                    self.messages = webChat.stdMes
                    
                } catch let jsonErr{
                    print("Error Serializing JSON:", jsonErr)
                }
            }.resume()
        }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagenum = messages.count
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell else { return UITableViewCell()}
        
//        print(indexPath.row)
        let index = indexPath.row
        print(messages[index].content)
        print(messages[index].time)
        cell.bodyLabel.text = messages[index].content
        cell.timeLabel.text = timeFromIntToString(with: messages[index].date, And: messages[index].time)
        cell.fromToLabel.text = fromAToB(with: messages[index].from, to: messages[index].to)
        
        return cell
    }
    
    func timeFromIntToString(with dateString: String,And timeInt: Int) -> String {
        var mesTime: String
//        let year = String(TimeInt/100000000)
//        let month = String(TimeInt/1000000-100*(TimeInt/100000000))
//        let date = String(TimeInt/10000-10000*(TimeInt/100000000)-100*(TimeInt/1000000-100*(TimeInt/100000000)))
//        let hour = String((TimeInt%10000-TimeInt%100)/100)
//        let minute = String(TimeInt%100)
//        timeString = year + "-" + month + "-" + date + " " + hour + ":" + minute
        
        let dateToday = Date()
        let calendar = Calendar.current
        
        //convert dateToday to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateTodayString = dateFormatter.string(from: dateToday)
        
        //get hour&minute at Now as String
        let nowHourString = String(calendar.component(.hour, from: dateToday))
        let nowMinuteString = String(calendar.component(.minute, from: dateToday))
//        let nowsecondString = String(calendar.component(.second, from: dateToday))
        
        //get hour&minute for Message as String
        var mesHourString = String(timeInt/10000)
        var mesMinuteString = String(timeInt/100-100*(timeInt/10000))
        //        let mesSecondString = String(timeInt%100)
        
        let nowTimeHMString = nowHourString + nowMinuteString
        let messageTimeHMString = String(timeInt/100)
        
        var timeString : String
        //Time: 0X:XX
        if (timeInt/100000) == 0 {
            mesHourString = "0" + mesHourString
        }
        //Time: XX:0X
        if (timeInt/100-100*(timeInt/10000))/10 == 0{
            mesMinuteString = "0" + mesMinuteString
        }
        
        timeString = " " + mesHourString + ":" + mesMinuteString
        
//        //If in same Day, Present Time directly
        if dateTodayString == dateString {
//            //If in same Minute, Present Now
            if nowTimeHMString == messageTimeHMString {
                return "Now"
            }
            mesTime = timeString
        } else {
            mesTime = dateString + timeString
        }
        
        return mesTime
    }
    
    func fromAToB(with A:String, to B: String) -> String {
        let fromTo = A + " to " + B
        return fromTo
    }
    
    
}
