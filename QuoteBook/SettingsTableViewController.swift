//
//  SettingsTableViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 26/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var reminderCell: UITableViewCell!
    @IBOutlet weak var newQuotesReminderCell: UITableViewCell!
    let NOTIFICATION_SWITCH:String = "NOTIFICATION_SWITCH"
    let NEW_QUOTES_NOTIFICATION_SWITCH:String = "NEW_QUOTES_NOTIFICATION"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure the Notification switch Cell
        let reminderSwitch:UISwitch = UISwitch(frame: CGRectZero)
        let switchValue = NSUserDefaults.standardUserDefaults().boolForKey(NOTIFICATION_SWITCH)
        reminderSwitch.setOn(switchValue, animated: false)
        reminderSwitch.addTarget(self, action: "notificationSwitchTapped:", forControlEvents: .ValueChanged)
        reminderCell.accessoryView = reminderSwitch
        //New Quotes Notification
        let newQuotesNotifSwitch:UISwitch = UISwitch(frame: CGRectZero)
        let shouldPushNewQuotes = NSUserDefaults.standardUserDefaults().boolForKey(NEW_QUOTES_NOTIFICATION_SWITCH)
        newQuotesNotifSwitch.setOn( shouldPushNewQuotes, animated: false)
        newQuotesNotifSwitch.addTarget(self, action: "newQuotesNotificationSwitchTapped:", forControlEvents: .ValueChanged)
        newQuotesReminderCell.accessoryView = newQuotesNotifSwitch
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func feedbackButtonTapped(sender: UIButton) {
        let mailComposerVC:MFMailComposeViewController = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["goquotebookapp@gmail.com"])
        mailComposerVC.setSubject("Feedback about QuoteBook App")
        
        guard MFMailComposeViewController.canSendMail() else {
            //show error message 
            let errorAlert:UIAlertController = UIAlertController(title: "Sorry", message: "It seems we cannot send emails on your device", preferredStyle: .Alert )
            let cancelAction:UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            errorAlert.addAction( cancelAction )
            self.presentViewController(errorAlert, animated: true, completion: nil)
            return;
        }
        
        self.presentViewController(mailComposerVC, animated: true, completion: nil)
    }
    
    func newQuotesNotificationSwitchTapped( sender:UISwitch ){
        //NB: Currently we only send New quotes Notifications from the server, so as a result, the user can register/unregister for notifications since only one type of push notifications are being sent on the global channel
        //If Pushing Notifications of different types/channels then remove this stub and simply subscribe/unsusbscribe to the specific channel 🤓🤓
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: NEW_QUOTES_NOTIFICATION_SWITCH)
        let application:UIApplication = UIApplication.sharedApplication()
        
        if sender.on {
            //Register for push notifications
            let userNotificationTypes:UIUserNotificationType = [ .Alert, .Badge, .Sound ]
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = 0; //Reset the notification badge
            print("Registered for remote notifications")
        }else{
            application.unregisterForRemoteNotifications()
            application.applicationIconBadgeNumber = 0;
            print("Unregistered for remote notifications")
        }
    }
    
    func notificationSwitchTapped(sender: UISwitch) {
        //Save the new settings
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: NOTIFICATION_SWITCH)
        
        if sender.on {
            //Setup the local notification date
            let calendar:NSCalendar = NSCalendar.autoupdatingCurrentCalendar()
            var scheduleDate = NSDate()
            var dateComponent:NSDateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year,NSCalendarUnit.Hour , NSCalendarUnit.Minute], fromDate: scheduleDate)
            if dateComponent.hour >= 9 {
                scheduleDate = scheduleDate.dateByAddingTimeInterval(86400) //The following day
                dateComponent = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year,NSCalendarUnit.Hour , NSCalendarUnit.Minute], fromDate: scheduleDate)
            }
            dateComponent.hour = 8; dateComponent.minute = 30;
            scheduleDate = calendar.dateFromComponents(dateComponent)!
            
            //create the notification
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.fireDate = scheduleDate
            localNotification.alertBody = "Rise and Shine! ☀️☀️, your quotes are ready for you"
            localNotification.alertAction = "View quotes"
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertTitle = "Morning!"
            localNotification.repeatInterval = .Day
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            print( scheduleDate )
        }else{
            //Cancel all local notifications, for now there is only one
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        print( UIApplication.sharedApplication().scheduledLocalNotifications?.count )
    }

}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
