//
//  ViewController.swift
//  paginations
//
//  Created by GadgetZone on 10/8/18.
//  Copyright © 2018 GadgetZone. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tbl: UITableView!
     var timer = Timer()
    var mainarry = NSMutableArray()
    var pager : Int = 0
    var temparr = [Any]()
    var isGettingData = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callapi()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainarry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        print(mainarry)
        let dict : NSDictionary = mainarry.object(at: indexPath.row) as! NSDictionary
        let name : String = dict.value(forKey: "reward_name") as! String
        cell.lbl.text = name
        return cell
    }
    
    func callapi()
    {
    let url : URL = URL(string: "")!
        
        let params : Parameters = ["user_id" : 1,
                                   "page" : pager]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON { (res) in
            
            
            let json : NSDictionary = res.result.value as! NSDictionary
            let is_success : String = json.value(forKey: "is_success") as! String
            if is_success == "true"
            {
                self.temparr = json.value(forKey: "result") as! [Any]
                
                self.mainarry.addObjects(from: self.temparr)
                
                if self.temparr.count > 2 {
                    self.pager = self.pager + 1
                    self.isGettingData = false
                }
                    //self.rewardarr = json.value(forKey: "result") as! NSArray
                else
                {
                    
                }
                
                self.tbl.reloadData()
            }
            else
            {
                
            }
            
        }
}
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tbl.contentOffset.y < 0 {
            
            return
            
        }
            
        else if tbl.contentOffset.y >= (tbl.contentSize.height - tbl.bounds.size.height) {
            
            
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: false)
            
        }
        
        
        
    }
    
    
    @objc func timerCallback() {
        
        timer.invalidate()
        
        if isGettingData == false && temparr.count > 2 {
            
            temparr.removeAll()
            callapi()
            
        }
    }
    
}
