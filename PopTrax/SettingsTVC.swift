//
//  SettingsTVCTableViewController.swift
//  PopTrax
//
//  Created by Tung Ly on 5/27/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let step = 5
    
    @IBOutlet weak var supportDisplay: UILabel!
    
    @IBOutlet weak var videosCount: UILabel!
    
    @IBOutlet weak var countSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        tableView.alwaysBounceVertical = false
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            videosCount.text = "\(theValue)"
            countSlider.value = Float(theValue)
        } else {
            countSlider.value = 10.0
            videosCount.text = ("\(Int(countSlider.value))")
        }
        
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let roundedValue = round(sender.value / 5) * 5
        
        defaults.setObject(roundedValue, forKey: "APICNT")
        videosCount.text = ("\(Int(roundedValue))")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let mailComposerViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail(){
                self.presentViewController(mailComposerViewController, animated: true, completion: nil)
            } else {
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func configureMail() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["tungply7@gmail.com"])
        mailComposeVC.setSubject("PopTrax Feedback")
        mailComposeVC.setMessageBody("Hi Tung, \n\nI would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
        
    }
    
    func mailAlert() {
        
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No e-Mail Account setup for Phone", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "ok", style: .Default) { action -> Void in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        /*
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            print("Unknown Issue")
            
        }*/
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
