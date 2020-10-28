//
//  RssParserDelegate.swift
//  RSSReader
//
//  Created by anny on 2020/10/25.
//  Copyright © 2020 anny. All rights reserved.
//

import Foundation

class RssParserDelegate: NSObject ,XMLParserDelegate{
    var currentItem: NewsItem?
    var currentElementValue: String?
    var resultArray = [NewsItem]()
    
    //  碰到標籤tag<>就會觸發 開始解析
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item"{
            // 開始一個 新的新聞
            currentItem = NewsItem()
        }else if elementName == "title"{
            currentElementValue = nil
        }else if elementName == "link"{
            currentElementValue = nil
        }
    }
    
    //  再次 碰到相同標籤tag<>就會觸發 結束這段解析
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            if currentItem != nil{
                resultArray.append(currentItem!)
                currentItem = nil
            }
        }else if elementName == "title"{
            currentItem?.title = currentElementValue
        }else if elementName == "link"{
            currentItem?.link = currentElementValue
        }
        currentElementValue = nil
    }
    
    // 碰到標籤的內文字母時 就會開時讀取
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil{
            currentElementValue = string
        }else{
            currentElementValue = currentElementValue! + string
        }
    }
    
    func getResult() -> [NewsItem]{
        return resultArray
    }
}
