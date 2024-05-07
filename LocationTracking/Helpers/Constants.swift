//
//  Constants.swift
//  iOSArchitecture
//
//  Created by Amit on 23/02/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import Foundation
import UIKit

enum Config {
//    static let baseUrl                  = "http://54.71.18.74:5925/api/"
    
    static let baseUrl                  = "https://adtrak.com.au/api/"
    
    //static let privacyUrl             = baseUrl + "/privacy-policy"
    static let login                    = "userLogin"
    static let forgotpassword           = "forgotPassword"
    static let logout                   = "userLogOut"
    static let history                  = "getAppUserTrackHistory"
    static let associateHistory         = "getAssociateTrackingHistory"
    static let comment                  = "uploadCommentImages"
    static let editjob                  = "editJobid"
    static let startmultipletracking    = "startMulipleTracking"
    static let getincidenttype          = "getIncidentTypes"
    static let incidentreport           = "reportIncident"
    static let stoptracking             = "stopTracking"
    static let stoptrackingcoordinates  = "setTrackingCoordinates"
    static let stopFromWeb              = "trackingUpdatetomobile"
    static let getTerms                 = "getTermDetail"
    static let getAssociatedUsers       = "getAssociatedUsers"
    static let getActiveAssociates      = "getActiveAssociates"//"getUserTracking"
    static let getUserTracking          = "getUserTracking"

}


let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

var Timestamp: String {
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}

let emailRegex                          = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

enum Color {
    static let indicatorcolor           = UIColor(red: 254.0/255, green: 127/255, blue: 42/255, alpha: 1.0)
    static let navigationbartint        = UIColor(red: 11/255, green: 43/255, blue: 73/255, alpha: 1.0)
    static let linecolor                = UIColor(red: 0/255, green: 164/255, blue: 239/255, alpha: 1.0)
    static let txtplaceholdercolor      = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
    static let closebtnbgcolor          = UIColor(red: 255/255, green: 27/255, blue: 33/255, alpha: 1.0)
    static let pathcolorBlue            = UIColor(red: 53/255, green: 159/255, blue: 242/255, alpha: 1.0)
    static let pathcolorOrange          = UIColor.orange//(red: 216/255, green: 0/255, blue: 30/255, alpha: 1.0)
    static let statusbarcolor           = UIColor(red: 42/255, green: 74/255, blue: 97/255, alpha: 1.0)
    static let buttonTopColor           = UIColor(red: 25.0/255.0, green: 118.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    static let buttonBottomColor        = UIColor(red: 53.0/255.0, green: 216.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    static let backgrndColor            = UIColor(red: 55.0/255.0, green: 72.0/255.0, blue: 82.0/255.0, alpha: 0.8)
}

enum GoogleAppID {
    static let appid                    = "AIzaSyD3pTKWTvIuMnaqe-M6Q59Lhb_Hk4WKms8"
}

enum Identifiers {
    enum Storyboard {
        static let main                 = "Main"
        static let dashboard            = "Dashboard"
    }
    
    enum Controler {
        static let login                = "LoginViewController"
        static let frogotpass           = "ForgotPasswordViewController"
        static let tracking             = "TrackingHistoryViewController"
        static let associateTracking    = "AssociateListViewController"
        static let maptracking          = "MapTrakingViewController"
        static let forgotpass           = "ForgotPasswordViewController"
        static let addjobID             = "AddJobIDViewController"
        static let stoptracking         = "StopTrackingViewController"
        static let commentvc            = "CommentViewController"
        static let filtertvc            = "FilterViewController"
        static let enlargemapvc         = "EnlargeMapViewController"
        static let editjobvc            = "EditJobViewController"
        static let termscond            = "TermsandConditionViewController"
        static let incidentreport       = "IncidentReportViewController"
        
    }
}

enum Device {
    static let  width   = UIScreen.main.bounds.size.width
    static let  height  = UIScreen.main.bounds.size.height
}

class Constants: NSObject {
    fileprivate static let reachability = Reachability()!
    
    public static var isNetworkReachable:Bool {
        if reachability.currentReachabilityStatus == .notReachable {
            _ = reachability.isReachable
        }
        return reachability.currentReachabilityStatus != .notReachable
    }
    
    public static var reachabilityStatus:String {
        return "Network Status: "+reachability.currentReachabilityString
    }
}

struct TABLE_VIEW_CELL_IDENTIFIERS {
    static let MENUDATACELL                 = "DataSourceCell"
    static let MENUPROFILECELL              = "ProfileCell"
    static let MAPLOCATIONCELL              = "locationcell"
    static let NEWJOBCELL                   = "AddNewJobCell"
    static let TRACKINGHISTORYCELL          = "TrackingHistoryCell"
    static let JOBIDCOLLECTIONVIEWCELL      = "JobIDCell"
    static let STOTRAKINGCELL               = "StopTrakingCell"
    
    //StopTrakingCell
}

enum AppStoryboard {
    case MainStoryboard
    case DashboardStoryboard
}

class UIUtility {
    
    //MARK:- Storyboards
    static func getStoryboard(_ appStoryboard: AppStoryboard) -> UIStoryboard? {
        var storyboard: UIStoryboard?
        switch appStoryboard {
        case .MainStoryboard:
            storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        case .DashboardStoryboard:
            storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        }
        return storyboard
    }
    
    //MARK:- Navigate to DashBoard View Controllers
    static func movetoLoginVC () {
        if let window = UIApplication.shared.windows.first as? UIWindow {

        window.rootViewController = nil
        let loginvc = self.getStoryboard(.MainStoryboard)?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginvc)
        window.rootViewController = navigationController
        }
    }
    
    static func addDashboardTabBarController () {
        if let window = UIApplication.shared.windows.first as? UIWindow {
        window.rootViewController = nil
        window.rootViewController = self.getDashboardTabBarController()
        window.backgroundColor    = UIColor.white
        LocationManager.shared.startManager()
        }
    }
    
    static func getDashboardTabBarController() -> SlideMenuController{
        let dashboard:MapTrakingViewController = self.getStoryboard(.DashboardStoryboard)?.instantiateViewController(withIdentifier: "MapTrakingViewController") as! MapTrakingViewController
        let leftMenuVC = SlideMenuController(mainViewController: UINavigationController(rootViewController: dashboard), leftMenuViewController: self.leftsideMenuViewController())
        leftMenuVC.addLeftGestures()
        leftMenuVC.addRightGestures()
        return leftMenuVC
    }
    
    //MARK:- LeftSideMenu
    static func leftsideMenuViewController() ->  LeftViewController{
        let leftSideMenuViewController:LeftViewController = self.getStoryboard(.DashboardStoryboard)?.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        return leftSideMenuViewController
    }
    
}

struct Utility {
    
    static func showNoData(with labelString:String, parentView:UIView) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: parentView.frame.height))
        label.text = labelString
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 13)
        //label.center = parentView.center
        return label
    }
}
extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIApplication.shared.keyWindow?.addSubview(toastLabel)
        UIView.animate(withDuration: 0.5, delay: 4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
