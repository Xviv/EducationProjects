//
//  APIClient.swift
//  PolyStudents
//
//  Created by Dan on 24/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class APIClient {
    
    let baseURL = "***"
    let lkApiURL = "***"
    let lkTestLoginURL = "***"
    
    var weekDayArray = [Int]()
    var groupsArray = [Group]()
    var teachersArray = [Teacher]()
    var auditoriesArray = [Auditorie]()
    var marksArray = [RecordBook]()
    var bupArray = [StudyPlan]()
    var rupArray = [WorkPlan]()
    var users: [ProfileDataArray] = []
    var profileId: [ProfilesArray] = []

    //MARK: - Data downloader
    
    func cleanArrays() {
        weekDayArray = []
        groupsArray = []
        teachersArray = []
        auditoriesArray = []
        marksArray = []
        users = []
        rupArray = []
        bupArray = []
        profileId = []
    }

    func getProfileData(access_token: String, completion: @escaping(_ profile: [ProfilesArray]?, _ err: Error?) -> ()) {
        cleanArrays()
        SVProgressHUD.show()
        
        let parameters: [String: Any] = [
            "provider" : "spbstu_cas",
            "access_token" : access_token
        ]
        // To get data from api firstful
        Alamofire.request(lkTestLoginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { (response) in
            if response.result.isFailure {
                print(response.error!)
                SVProgressHUD.dismiss()
            } else {
                let data = response.data
                do {
                    let res = try JSONDecoder().decode(ProfilesArray.self,from:data!)
                    
                    self.profileId.append(res)
                    
                    completion(self.profileId, nil)
                    
                } catch {
                    print("ERROR: \(error)")
                    completion(nil, error)
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
    
    func getProfiles(token: String, profileId: Int, completion: @escaping ([ProfileDataArray]?, _ err: Error?) -> ()) {
        let headers: [String : String] = [
            "Authorization": "Bearer \(token)",
            "Profile": String(profileId)
        ]
        Alamofire.request(self.lkApiURL, headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                let profileData = response.data
                do {
                    let profileData = try JSONDecoder().decode(ProfileDataArray.self,from:profileData!)
                    self.users.append(profileData)
                    completion(self.users, nil)
                } catch {
                    print("ERROR: \(error)")
                    completion(nil, error)
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
    
    func getMarks(token: String, profileId: Int, completion: @escaping ([RecordBook]?, _ err: Error?) -> ()) {
        let headers: [String : String] = [
            "Authorization": "Bearer \(token)",
            "Profile": String(profileId)
        ]
        
        Alamofire.request(self.lkApiURL + "/marks", headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                let RBData = response.data
                do {
                    let marks = try JSONDecoder().decode(RecordBook.self,from:RBData!)
                    self.marksArray.append(marks)
                    completion(self.marksArray, nil)
                } catch {
                    print("ERROR: \(error)")
                    completion(nil, error)
                    SVProgressHUD.dismiss()
                }
            }
        })

    }
    
    func getBUP(token: String, profileId: Int, completion: @escaping ([StudyPlan]?, _ err: Error?) -> ()) {
        let headers: [String : String] = [
            "Authorization": "Bearer \(token)",
            "Profile": String(profileId)
        ]
        
        Alamofire.request(self.lkApiURL + "/bup", headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let bup = try JSONDecoder().decode(StudyPlan.self,from:data!)
                    self.bupArray.append(bup)
                    completion(self.bupArray, nil)
                } catch {
                    print("ERROR: \(error)")
                    completion(nil, error)
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
    
    func getRUP(token: String, profileId: Int, completion: @escaping ([WorkPlan]?, _ err: Error?) -> ()) {
        let headers: [String : String] = [
            "Authorization": "Bearer \(token)",
            "Profile": String(profileId)
        ]
        
        Alamofire.request(self.lkApiURL + "/rup", headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let rup = try JSONDecoder().decode(WorkPlan.self,from:data!)
                    self.rupArray.append(rup)
                    completion(self.rupArray, nil)
                } catch {
                    print("ERROR: \(error)")
                    completion(nil, error)
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
    
    func logOut(profileId: Int) {
        let headers: [String : String] = [
            "Profile": String(profileId)
        ]
        
        Alamofire.request("***", headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.isSuccess {
                print("LogOut")
            } else {
                print(response.result.error)
            }
        })
    }
    
    func getTeachersData(searchName:String, date:String, completion: @escaping(_ array:[Any]?, _ err: Error?) -> ()){
        
        let searchTeacherURL = baseURL + "api/v1/ruz/search/teachers?q=" + searchName
        let encodedURL = searchTeacherURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.SessionManager.default.request(encodedURL!, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let res = try JSONDecoder().decode(TeachersArray.self,from:data!)
                    completion(res.teachers, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func getGroupsData(searchName:String, date:String, completion: @escaping(_ array:[Any]?, _ err: Error?) -> ()){
        let searchGroupURL = baseURL + "api/v1/ruz/search/groups?q=" + searchName
        let encodedURL = searchGroupURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.SessionManager.default.request(encodedURL!, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let res = try JSONDecoder().decode(GroupsArray.self,from:data!)
                    completion(res.groups, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func getRoomsData(searchName:String, date:String, completion: @escaping(_ array:[Any]?, _ err: Error?) -> ()){
        let searchTeacherURL = baseURL + "api/v1/ruz/search/rooms?q=" + searchName
        let encodedURL = searchTeacherURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.SessionManager.default.request(encodedURL!, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let res = try JSONDecoder().decode(RoomsArray.self,from:data!)
                    completion(res.rooms, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    func getSchedule(url: String, completion: @escaping(_ lessonsArray:[Day]?,_ error: Error?)->()) {
        Alamofire.SessionManager.default.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data = response.data
                do {
                    let res = try JSONDecoder().decode(LessonsArray.self, from: data!)
                    completion(res.days, nil)
                    SVProgressHUD.dismiss()
                }
                catch {
                    SVProgressHUD.dismiss()
                    completion(nil, error)
                }
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}
