//
//  MusicVideoTVC.swift
//  PopTrax
//
//  Created by Tung Ly on 5/25/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController, UISearchResultsUpdating {
    
    private struct storyboard{
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
        
    }
    
    var limit = 10
    
    var videos = [Videos]()
    
    var filterSearch = [Videos]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        reachabilityStatusChanged()
    }
    
    func didLoadData(videos: [Videos]){
        
        self.videos = videos
        
        resultSearchController.searchResultsUpdater = self //for UISearchResultsUpdating protocol
        
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.placeholder = "Search"
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        //Looks like the one used in email
        
        tableView.tableHeaderView = resultSearchController.searchBar
    
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged(){   //no notification passed in !!
        switch reachabilityStatus{
            case NOACCESS :
                //view.backgroundColor = UIColor.redColor()
                //move back to main queue
                dispatch_async(dispatch_get_main_queue()){
                let alert = UIAlertController(title: "No connection", message: "Make sure you're connected to internet", preferredStyle: .Alert)
                    
                let closeAction = UIAlertAction(title: "Close", style: .Default) {
                    action in
                    //print("closeAction")
                }
                
                alert.addAction(closeAction)                
                self.presentViewController(alert, animated: true, completion: nil)
                }
            
        default:    //if we have wifi
            if videos.count > 0 {   //if we already loaded videos
                print("Don't load")
            }else{
                runAPI()
            }
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        
        refreshControl?.endRefreshing()
        
        if resultSearchController.active {
            refreshControl?.attributedTitle = NSAttributedString(string: "No Refresh in Search")
        } else {
            runAPI()
        }
    }
    
    func runAPI(){
        getAPICount()   //limit will be set
        title = "Top \(limit) Music Videos on iTunes"
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    func getAPICount() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil){
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if resultSearchController.active{ //search is active
            return filterSearch.count
        }
        return videos.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{ // Default is 1 if not implemented
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.active{
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier
        {
            if let indexpath = tableView.indexPathForSelectedRow{
                
                let video: Videos
                
                if resultSearchController.active
                {
                    video = filterSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
    }
    
    //MARK: Animation on Cell display
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //1. set initial state of the cell
        cell.alpha = 0
        
        //Adjustment on cell's layer
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animateWithDuration(1.0){
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSeach(searchController.searchBar.text!)
    }
    
    func filterSeach(searchText: String){
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}
