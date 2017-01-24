//
//  MusicVideoDetailVC.swift
//  PopTrax
//
//  Created by Tung Ly on 5/26/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SafariServices

class MusicVideoDetailVC: UIViewController {
    
    var videos: Videos!
    
    @IBOutlet weak var vName: UILabel!
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var vGenre: UILabel!
    
    @IBOutlet weak var vPrice: UILabel!
    
    @IBOutlet weak var vRights: UILabel!
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: videos.vVideoUrl)               //play video @ this url
        let player = AVPlayer(URL: url!)                        //instantiate an object from AVPlayer
        let playerViewController = AVPlayerViewController()     //instantiate another object from AVPLayerVC
        playerViewController.player = player                    
        self.presentViewController(playerViewController, animated: true){
            playerViewController.player!.play()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = videos.vArtist
        
        // Do any additional setup after loading the view.
        vName.text = videos.vName
        vRights.text = videos.vRights
        vPrice.text = videos.vPrice
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil { //there's a value
            videoImage.image = UIImage(data: videos.vImageData!)
        } else {
            videoImage.image = UIImage(named: "not-available")
        }
    }
    
    //MARK: hit share button -> execute func below
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        shareMedia()
    }
    
    func shareMedia(){
        
        let activity1 = "Have you seen this awesome music video from iTunes?"
        let activity2 = "(\(videos.vName) by \(videos.vArtist))"
        let activity3 = "Watch it and tell me watch you think?"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "Shared from PopTrax - the top music videos app"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        
        //activityViewController.excludedActivityTypes = [UIActivityTypePostToTwitter, UIActivityTypePostToVimeo]
        
        /* Types of Activity */
        
//        UIActivityTypeMail
//        UIActivityTypeMessage
//        UIActivityTypePostToTwitter
//        UIActivityTypePostToVimeo
//        UIActivityTypePostToFacebook

        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if activity == UIActivityTypeMail{
                print("email selected")
            }
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func shareCustomMedia(){
        
        let alertController = YBAlertController(title: "Let's share this awesome video", message: nil, style: .ActionSheet)
        
        alertController.addButton(UIImage(named: "twitter"), title: "Tweet about it") {
            print("he wanted to tweet")
            
        }
        
        alertController.addButton(UIImage(named: "facebook"), title: "Post on facebook") {
            print("he wanted to facebook")
        }
        
        alertController.addButton(UIImage(named: "message"), title: "Shoot a text") {
            print("he wanted to text")
        }
        
        alertController.addButton(UIImage(named: "email"), title: "Send an email") {
            print("he wanted to send email")
            
        }
        alertController.buttonIconColor = UIColor(red: 248/255.0, green: 47/255.0, blue: 38/255.0, alpha: 1.0)
        
        alertController.show()
        
        
    }
}
