//
//  ListViewController.swift
//  NewsReader
//
//  Created by 岡本航昇 on 2020/04/02.
//  Copyright © 2020年 wataru okamoto. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, XMLParserDelegate {
    
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentString = ""
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
        //return 5
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        print("ok")
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDownload()
        print("ok2")
    }
    func startDownload() {
        self.items = []
        if let url = URL(string: "https://jp.techcrunch.com/feed/"){ //正誤表記載してある
            if let parser = XMLParser(contentsOf:url){
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI:String?,qualifiedName qName:String?, attributes attributeDict: [String:String]){
        self.currentString = ""
        if elementName == "item" {
            self.item = Item()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String){
        self.currentString += string
    }
    
    func parser(_ parser:XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        switch elementName {
        case "title" : self.item?.title = currentString
            print("title : " + currentString)
        case "link" : self.item?.link = currentString
            print("link : " + currentString)
        case "item" : self.items.append(self.item!)
            print("item")
        default : break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
}
