//
//  ViewController.swift
//  RSSReader
//
//  Created by anny on 2020/10/25.
//  Copyright © 2020 anny. All rights reserved.
//

import UIKit

struct NewsItem {
    var title: String?
    var link: String?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var news = [NewsItem]()
    let xmlAddress = "https://www.cnet.com/rss/news/"
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
//        let new1 = NewsItem(title: "Apple New", link: "https://www.apple.com")
//        let new2 = NewsItem(title: "Nike New", link: "https://www.nike.com")
//        let new3 = NewsItem(title: "Udemy New", link: "https://www.udemy.com")
//        news = [new1, new2, new3]
        
        dowmloadXML(withXMLAddress: xmlAddress)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = news[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let web = segue.destination as? WebViewController, let row = myTableView.indexPathForSelectedRow?.row{
            web.newsLink = news[row].link
        }
    }
    
    func dowmloadXML(withXMLAddress xmlAddress:String){
        if let url = URL(string: xmlAddress){
            URLSession.shared.dataTask(with: url) { (data, Response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async {
                            self.showAlert(title: "目前沒有連結網路")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert(title: "發生錯誤！！！")
                        }
                    }
                    return
                }
                if let loadData = data{
                    let parser = XMLParser(data: loadData)
                    let rssParserDelegate = RssParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true{
                        self.news = rssParserDelegate.getResult()
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert(title: "XML 解析失敗！！！")
                        }
                    }
                }
            }.resume()
        }
    }
    
    func showAlert(title:String){
        let alert = UIAlertController(title: title, message: "請稍後再試！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

