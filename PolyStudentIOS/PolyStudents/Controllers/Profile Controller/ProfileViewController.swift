//
//  ProfileViewController.swift
//  PolyStudents
//
//  Created by Dan on 16/03/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire
import SVProgressHUD
import SafariServices

class ProfileTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    private var loader: OAuth2DataLoader?
    private var profile = [ProfileDataArray]()
    private let OAuth2AppDidReceiveCallbackNotification = "OAuth2AppDidReceiveCallback"
    private let docsArray = ["Зачетная книжка", "Учебный план", "Рабочий план"]
    private let imagesArray = ["RB", "BUP", "RUP"]
    private let segues = ["recordBookSegue","studyPlanSegue","workPlanSegue"]
    private let profileCell = "profileCell"
    private var selectedSegmentIndex = 0
    private var marks = [RecordBook]()
    var alamofireManager: SessionManager?
    let api = APIClient()
    var rup = [WorkPlan]()
    var bup = [StudyPlan]()
    var profileId = [ProfilesId]()
    var group = DispatchGroup()
    var didLogin: Bool = false
    var profileIDs = [Int]()
    private var alert = ScheduleTableViewController()
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "***",
        "client_secret": "***",
        "authorize_uri": "***",
        "token_uri": "***",
        "scope": "***",
        "redirect_uris": ["***"],
        "secret_in_body": false,
        ] as OAuth2JSON)
    
    lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc private func fetchData() {
        refresh.endRefreshing()
        self.tableView.isUserInteractionEnabled = false
        if didLogin == false {
            checkIfUserGotToken()
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.tableView.isUserInteractionEnabled = false
        self.didLogin = true
        self.authorize()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        let urlString = "***"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refresh
        NotificationCenter.default.addObserver(forName: .saveSelectedSegment, object: nil, queue: OperationQueue.main) { (notification) in
            let dateVC = notification.object as! ProfileCell
            
            self.selectedSegmentIndex = dateVC.segmentedControll.selectedSegmentIndex
            
            print(self.selectedSegmentIndex)
            self.oauth2.forgetTokens()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRedirect(notification:)), name: NSNotification.Name(rawValue: OAuth2AppDidReceiveCallbackNotification), object: nil)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.reloadData()
        
        oauth2.forgetTokens()
        
        checkIfUserGotToken()
        navBarViewSetup()
        
        self.tableView.isScrollEnabled = true
    }
    
    private func navBarViewSetup() {
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func checkIfUserGotToken() {
        
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }

        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self
        oauth2.authConfig.authorizeEmbeddedAutoDismiss = true

        if self.oauth2.hasUnexpiredAccessToken() {
            self.authorize()
        } else {
            self.oauth2.forgetTokens()
            oauth2.authorize { (json, error) in
                if error != nil {
                    print("ERROR: \(error!)")
                } else {
                    self.authorize()
                }
            }
        }
    }
    
    @objc func handleRedirect(notification: NSNotification) {
        oauth2.handleRedirectURL(notification.object as! URL)
    }
    
    
    //MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if didLogin == false {
            return 1
        } else if profile.isEmpty {
            return 0
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if profile.isEmpty && oauth2.accessToken != nil {
            return 0
        } else if section == 1 {
            return docsArray.count
        } else {
            //one exit cell
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if self.didLogin == false {
                let loginCell = tableView.dequeueReusableCell(withIdentifier: "enterCell", for: indexPath) as! LoginCell
                
                tableView.separatorStyle = .none
                
                tableView.setContentOffset(.zero, animated: false)
                
                return loginCell
            } else {
                tableView.separatorStyle = .none
                let profileCell = tableView.dequeueReusableCell(withIdentifier: self.profileCell, for: indexPath) as! ProfileCell
                
                if profile.isEmpty == false {
                    profileCell.nameLabel.text = profile[indexPath.row].data?.user?.fullname
                    var i = 0
                    print("COUNT = \(self.profile.count)")
                    DispatchQueue.main.async {
                        profileCell.segmentedControll.removeAllSegments()
                        for profile in self.profile {
                            profileCell.segmentedControll.insertSegment(withTitle: profile.data?.profile?.edu_group?.title,at: i,animated: false)

                            i += 1
                        }
                    }
                    DispatchQueue.main.async {
                         profileCell.segmentedControll.selectedSegmentIndex = self.selectedSegmentIndex
                    }
                }
                
                return profileCell
            }
           
        } else if indexPath.section == 1 {
            let regularCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
            regularCell.menuLabel.text = docsArray[indexPath.row]
            regularCell.menuImage.image = UIImage(named:imagesArray[indexPath.row])
            regularCell.menuImage.tintColor = #colorLiteral(red: 0.1921568627, green: 0.6078431373, blue: 0.2392156863, alpha: 1)
            
            return regularCell
        } else {
            let regularCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
            
            regularCell.accessoryType = .none
            regularCell.menuLabel.text = "Выход"
            regularCell.menuImage.image = UIImage(named:"exit1")
            regularCell.menuImage.tintColor = #colorLiteral(red: 0.7450980392, green: 0.2156862745, blue: 0.2431372549, alpha: 1)
            
            return regularCell
        }
    
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            for id in self.profileId {
                self.api.logOut(profileId: id.id!)
            }
            let storage = HTTPCookieStorage.shared
            storage.cookies?.forEach() { storage.deleteCookie($0) }
            self.oauth2.forgetTokens()
            self.profile.removeAll()
            self.didLogin = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        }
    }
    
    //Talbe view Delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.didLogin == false {
            tableView.isScrollEnabled = false
            return tableView.frame.height
        } else if indexPath.section == 0 && oauth2.accessToken != nil {
            tableView.isScrollEnabled = true
            return 200
        } else {
            tableView.isScrollEnabled = true
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }  else {
            return 20
        }
    }
    
    //MARK: - Prepare for segue
    
    private func profileItem(at indexPath: IndexPath) -> ProfileDataArray {
        return profile[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSegue" {
                let selectedProfile = profile[selectedSegmentIndex]
                let userProfileController = segue.destination as! UserProfileController
                userProfileController.profile = selectedProfile
        }
        if segue.identifier == "recordBookSegue" {
            let selectedProfile = marks[selectedSegmentIndex]
            let RBController = segue.destination as! RecordBookTableController
            RBController.marks = selectedProfile
        }
        
        if segue.identifier == "studyPlanSegue" {
            let selectedProfile = bup[selectedSegmentIndex]
            let bupController = segue.destination as! StudyPlanViewController
            bupController.studyPlan = selectedProfile
        }
        
        if segue.identifier == "workPlanSegue" {
            let selectedProfile = rup[selectedSegmentIndex]
            let rupController = segue.destination as! WorkPlanViewController
            rupController.workPlan = selectedProfile
        }

    }
    
    func alertShow(title: String) -> Void {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - OAuth2.0 Authorization
extension ProfileTableViewController {
    fileprivate func authorize() {
        
        cancelAllRequests {
            let sessionManager = SessionManager()
            let retrier = OAuth2RetryHandler(oauth2: self.oauth2)
            sessionManager.adapter = retrier
            sessionManager.retrier = retrier
            self.alamofireManager = sessionManager
            self.didLogin = true
        sessionManager.request("***").validate().responseJSON { response in
            DispatchQueue.main.async {
                if response.result.isFailure {
                    self.tableView.isUserInteractionEnabled = true
                    self.alertShow(title: response.error!.localizedDescription)
                } else {
                    if let token = self.oauth2.accessToken {
                        print(self.oauth2.accessToken)
                        
                        self.api.getProfileData(access_token: token) { (profiles, err)  in
                            if err != nil {
                                self.alertShow(title: err!.localizedDescription)
                            } else {
                                if let profile = profiles {
                                    let id = profile[0].data.profiles
                                    let token = profile[0].data.access_token
                                    
                                    var i = 0
                                    let queue = OperationQueue()
                                    queue.maxConcurrentOperationCount = 1
                                    id.enumerated().forEach({ (index, prof) in
                                        queue.addOperation {
                                            self.group.enter()
                                            self.api.getProfiles(token: token!, profileId: prof.id!, completion: { (profileArray, error) in
                                                debugPrint("PROFILES: \(prof.id!) At index: \(index)")
                                                if err != nil {
                                                    self.alertShow(title: err!.localizedDescription)
                                                }
                                                if let profileArray = profileArray {
                                                    self.profile = profileArray
                                                    self.group.leave()
                                                    self.group.wait(timeout: .now() + 0.1)
                                                }
                                                
                                                self.group.enter()
                                                queue.addOperation {
                                                    self.api.getMarks(token: token!, profileId: prof.id!, completion: { (marksArray, error) in
                                                        debugPrint("MARKS: \(prof.id!) At index: \(index)")
                                                        if err != nil {
                                                            self.alertShow(title: err!.localizedDescription)
                                                        }
                                                        if let marksArray = marksArray {
                                                            self.marks = marksArray
                                                            self.group.leave()
                                                            self.group.wait(timeout: .now() + 0.1)
                                                        }
                                                        self.group.enter()
                                                        queue.addOperation {
                                                            self.api.getBUP(token: token!, profileId: prof.id!, completion: { (bup, error) in
                                                                debugPrint("BUP: \(prof.id!) At index: \(index)")
                                                                print(token)
                                                                if err != nil {
                                                                    self.alertShow(title: err!.localizedDescription)
                                                                }
                                                                if let bup = bup {
                                                                    self.bup = bup
                                                                    self.group.leave()
                                                                    self.group.wait(timeout: .now() + 0.1)
                                                                }
                                                                self.group.enter()
                                                                queue.addOperation {
                                                                    self.api.getRUP(token: token!, profileId: prof.id!, completion: { (rup, error) in
                                                                        debugPrint("RUP: \(prof.id!) At index: \(index)")
                                                                        if err != nil {
                                                                            self.alertShow(title: err!.localizedDescription)
                                                                        }
                                                                        if let rup = rup {
                                                                            self.rup = rup
                                                                            
                                                                            i += 1
                                                                            self.group.leave()
                                                                            self.group.wait(timeout: .now() + 0.1)
                                                                        }
                                                                    })
                                                                }
                                                            })
                                                        }
                                                    })
                                                }
                                            })
                                            self.group.notify(queue: .main, execute: {
                                                SVProgressHUD.dismiss()
                                                UIView.transition(with: self.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                                                    self.tableView.reloadData()
                                                }, completion: {(completed) in
                                                    if completed {
                                                        self.tableView.isUserInteractionEnabled = true
                                                        self.didLogin = false
                                                    }
                                                })
                                            })
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    }
    
    private func cancelAllRequests(completion: @escaping () -> ()) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    fileprivate var userDataRequest: URLRequest {
        if let accessToken = oauth2.accessToken {
            return URLRequest(url: URL(string: "***" + accessToken)!)
        } else {
            return URLRequest(url: URL(string: "***")!)
        }
    }
}
