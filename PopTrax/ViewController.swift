//
//  ViewController.swift
//  PopTrax
//
//  Created by Tung Ly on 5/20/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var videos = [Videos]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        reachabilityStatusChanged()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=15/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]){
        
        print(reachabilityStatus) //WIFI Available
        
        self.videos = videos
        for (index, item) in videos.enumerate() {
            print("\(index).name = \(item.vArtist)")
        }
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged(){   //no notification passed in !!
        switch reachabilityStatus{
        case NOACCESS : view.backgroundColor = UIColor.redColor()
            displayLabel.text = "No Internet"
        case WIFI : view.backgroundColor = UIColor.greenColor()
            displayLabel.text = "Reachable with WIFI"
        case WWAN : view.backgroundColor = UIColor.orangeColor()
            displayLabel.text = "Reachable with Cellular"
        default:return
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let video = videos[indexPath.row]
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.vName
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{ // Default is 1 if not implemented
        return 1
    }
    
}

