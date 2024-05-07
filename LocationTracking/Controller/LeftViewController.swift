//
//  LeftViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/14/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//




import UIKit

enum LeftMenu: Int {
    case Main = 0
    case associate
    case tracking
    case logout
}

enum eSection:Int {
    case sectionheader
    case sectioncell
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController: BaseViewControler,LeftMenuProtocol {
    
    @IBOutlet weak var tblmenu          : UITableView!
    @IBOutlet weak var imgprofile       : UIImageView!
    @IBOutlet weak var lblprofilename   : UILabel!
    
    
    var tableDataSet:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSet = [dataSource(iconName: "home", text: "MENU_HOME".localized, isSeparatoHidden: true)]
        if AppInstance.shared.getTypeOfUser == .primary {
            tableDataSet.append(dataSource(iconName: "home", text: "ASSOCIATE".localized, isSeparatoHidden: true))
        }
        tableDataSet.append(dataSource(iconName: "trackinghistory", text: "MENU_HISTORY".localized, isSeparatoHidden: true))
        tableDataSet.append(dataSource(iconName: "home", text: "MENU_LOG_OUT".localized, isSeparatoHidden: true))
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblmenu.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func  updateUI() {
        imgprofile.layer.cornerRadius   = imgprofile.frame.width/2
        imgprofile.clipsToBounds        = true
        if let firstname = AppInstance.shared.user?.firstname, let lastname = AppInstance.shared.user?.lastname, !firstname.isEmpty, !lastname.isEmpty {
            lblprofilename.text         = "\(AppInstance.shared.user?.firstname ?? "") \(AppInstance.shared.user?.lastname ?? "")"
        }
        guard AppInstance.shared.user?.profileimage != "" else {
            imgprofile.image            = UIImage(named: "profile_image_new")
            return
        }
        let url                         = URL(string: AppInstance.shared.user?.profileimage ?? "profile_image_new")
        let data                        = try? Data(contentsOf: url!)
        if let imageData = data {
            imgprofile.image            = UIImage(data: imageData)
        }
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .Main: self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: UIUtility.getStoryboard(.DashboardStoryboard)?.instantiateViewController(withIdentifier: Identifiers.Controler.maptracking) as! MapTrakingViewController), close: true)
        case .tracking: self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: UIUtility.getStoryboard(.DashboardStoryboard)?.instantiateViewController(withIdentifier: Identifiers.Controler.tracking) as! TrackingHistoryViewController), close: true)
        case .associate:
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: UIUtility.getStoryboard(.DashboardStoryboard)?.instantiateViewController(withIdentifier: Identifiers.Controler.associateTracking) as! AssociateListViewController), close: true)
        case .logout:
            if LocationManager.shared.isTrackingStarted {
                showAlert(with: "LOG_OUT_STOP_TRACKING".localized)
            }else{
                UIAlertController.show(with: "APP_NAME".localized, message: "LOGOUT_MSG".localized, preferredStyle: .alert, target: self, actions: [.No, .Yes]) { (action) in
                    switch action {
                    case .Yes:
                        self.logoutApi()
                    default:
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func logoutApi() {
        let service = UserService()
        service.logOut(with: AppInstance.shared.userid, target: self, complition: { (response) in
            DispatchQueue.main.async {
                LocationManager.shared.stopManager()
                UserDefaults.standard.removeObject(forKey: "userObj")
                UIUtility.movetoLoginVC()
            }
        })
    }
    
}

extension LeftViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL_IDENTIFIERS.MENUDATACELL) as! DataSourceCell
        cell.setData(tableDataSet[indexPath.row])
        return cell
    }
          
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexValue = indexPath.row
        if indexPath.row >= 1 && AppInstance.shared.getTypeOfUser == .associate {
            indexValue += 1// Because for seconday user to be redirect into Tracking page
        }
        if let menu = LeftMenu(rawValue: indexValue) {
            self.changeViewController(menu)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
