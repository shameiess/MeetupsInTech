//
//  Extensions.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let centerMapByCurrentLocation = Notification.Name("centerMapByCurrentLocation")
    static let updateTopic = Notification.Name("updateTopic")
    static let meetups = Notification.Name("meetups")
}

extension UIImageView{
    
    func setImageFromURL(url: String) {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static let chatBubbleBlueColor = UIColor(red: 50, green: 206, blue: 243)//UIColor(red: 21, green: 126, blue: 251)
    static let chatBubbleGrayColor = UIColor(red: 241, green: 240, blue: 240)
}

extension Double {
    func convertToDateString() -> String {
        let timeInterval: TimeInterval = self/1000
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.long
        
        let dateString = formatter.string(from: date as Date)
        
        return dateString
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UIViewController {
//    var showSideMenu: Bool
//    if (self.showTrayButton && self.menu && !self.presentingViewController) {
//    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lefttray.button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
//    [menuButton setImageInsets:UIEdgeInsetsMake(0, -15, 0, -15)];
//    self.navigationItem.leftBarButtonItem = menuButton;
//    self.menuButton = menuButton;
//    } else
//    [self setupBackButton];

    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIAlertController {
    static func alertWithTitle(title: String, message: String, buttonTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alertController.addAction(action)
        
        return alertController
    }
}
