//
//  Helpers.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 6/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//


import UIKit
import SwifterSwift
import RealmSwift

extension Helpers {
    static var alert: UIAlertController!
    
    enum Alerts {
        static let error = NSLocalizedString("GenericError", comment: "")
        static let success = NSLocalizedString("GenericSuccess", comment: "")
    }
    
    enum Messages {
        static let emailEmpty = NSLocalizedString("AlertMessageEmailEmpty", comment: "")
        static let passwordEmpty = NSLocalizedString("AlertMessagePasswordEmpty", comment: "")
        static let passwordConfirmEmpty = NSLocalizedString("AlertMessagePasswordConfirmEmpty", comment: "")
        static let emailWrongFormat = NSLocalizedString("AlertMessageEmailWrongFormat", comment: "")
        static let passwordNotLongEnough = NSLocalizedString("AlertMessagePasswordNotLongEnough", comment: "")
        static let passwordsDonotMatch = NSLocalizedString("AlertMessagePasswordsDonotMatch", comment: "")
        static let firstNameEmpty = NSLocalizedString("AlertMessageFirstNameEmpty", comment: "")
        static let firstNameNotLongEnough = NSLocalizedString("AlertMessageFirstNameNotLongEnough", comment: "")
        static let lastNameEmpty = NSLocalizedString("AlertMessageLastNameEmpty", comment: "")
        static let lastNameNotLongEnough = NSLocalizedString("AlertMessageLastNameNotLongEnough", comment: "")
        static let pleaseLogin = NSLocalizedString("AlertMessagePleaseLogin", comment: "")
        static let issueWithUserToken = NSLocalizedString("AlertMessageIssueWithUserToken", comment: "")
        static let noWebsite = NSLocalizedString("AlertMessageNoWebsite", comment: "")
        static let youMustLogin = NSLocalizedString("AlertMessageYouMustLogin", comment: "")
        static let logoutSuccess = NSLocalizedString("AlertMessageLogoutSuccess", comment: "")
    }
}

class Helpers {
    
    static func alertWithMessage(title: String!, message: String!, completionHandler: (() -> ())? = nil) {
        //@TODO: Guard if there's already an alert message
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            guard !(topController is UIAlertController) else {
                // There's already a alert preseneted
                return
            }
            
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("GenericOkay", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
            completionHandler?()
        }
    }
    
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    static func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    /*
     A formatter for individual date components used to provide an appropriate
     value for the `startTimeLabel` and `durationLabel`.
     */
    static let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    static func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}

extension Helpers {
    //MARK: Date
    class func formatDate(dateString: String) -> String {
        let startDate = Date(iso8601String: dateString)!
        let startMonth = startDate.monthName()
        let day = startDate.day.string
        let year = startDate.year.string
        return startMonth + " " + day + ", " + year
    }
}

public extension String {
    /// Decodes string with html encoding.
    var htmlDecoded: String {
        guard let encodedData = self.data(using: .utf8) else { return self }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData,
                                                          options: attributedOptions,
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error: \(error)")
            return self
        }
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
