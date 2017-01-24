//
//  MusicVideoTableViewCell.swift
//  PopTrax
//
//  Created by Tung Ly on 5/25/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    var video: Videos? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell(){
        musicTitle.text = video?.vName
        
        rank.text = ("\(video!.vRank)")
        
        artist.text = video?.vArtist
        
        if video!.vImageData != nil{ //either get it from array which is loaded
            
            print("get data from array")
            
            musicImage.image = UIImage(data: video!.vImageData!)
            
        } else { //or go on internet and get it
            
            getVideoImage(video!, imageView: musicImage)
            
        }
        
    }
    
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    func getVideoImage(video: Videos, imageView: UIImageView)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image: UIImage?
            
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if self.tag == video.vRank {
                    imageView.image = image
                }
            }
        }
    }
}
