//
//  UserProfileController.swift
//  PolyStudents
//
//  Created by Dan on 11/05/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var eduDirectionTitle: UILabel!
    @IBOutlet weak var eduSpecTitle: UILabel!
    @IBOutlet weak var faculty: UILabel!
    @IBOutlet weak var qualification: UILabel!
    @IBOutlet weak var eduForm: UILabel!
    @IBOutlet weak var eduYear: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var semester: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var cathedra: UILabel!
    @IBOutlet weak var eduStatus: UILabel!
    @IBOutlet weak var userAvatarView: UIView!
    
    var profile: ProfileDataArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = profile?.data?.profile?.edu_mark_book_num
        let year = profile?.data?.profile?.edu_year
        let eduCourse = profile?.data?.profile?.edu_course
        let eduSemester = profile?.data?.profile?.edu_semester
        
        userName.text = profile?.data?.user?.fullname
        userId.text = id
        eduDirectionTitle.text = profile?.data?.profile?.edu_direction?.title
        eduSpecTitle.text = profile?.data?.profile?.edu_specialization?.title
        faculty.text = profile?.data?.profile?.faculty?.title
        qualification.text = profile?.data?.profile?.edu_qualification?.title
        if profile?.data?.profile?.edu_form == "full-time" {
            eduForm.text = "Очная"
        } else {
            eduForm.text = "Заочная"
        }
        eduYear.text = String(year!)
        course.text = String(eduCourse!)
        semester.text = String(eduSemester!)
        group.text = profile?.data?.profile?.edu_group?.title
        cathedra.text = profile?.data?.profile?.cathedra
        if profile?.data?.profile?.edu_status == "learn" {
            eduStatus.text = "Обучается"
        } else {
            eduStatus.text = "Закончил"
        }
        
        userAvatarView.dropShadow()
    }

}
