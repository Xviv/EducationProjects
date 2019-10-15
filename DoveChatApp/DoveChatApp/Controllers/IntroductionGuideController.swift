//
//  IntroductionGuideController.swift
//  DoveChatApp
//
//  Created by Dan on 13.05.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit

class IntroductionGuideController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellId"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        
        let intro = Page(title: "Welcome!", message: "Dove is a secure message sharing system.", imageName: "DoveLogo")
        let firstPage = Page(title: "Confidentiality", message: "Dove has end-to-end RSA-1024 encryption", imageName: "secure")
        let secondPage = Page(title: "Media", message: "Supports image and video message sending to other users", imageName: "media")
        let thirdPage = Page(title: "Secret chats", message: "Automatically delete all your messages after chat session ends", imageName: "Secret")
        
        
        return[intro, firstPage, secondPage, thirdPage]
        
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        return cv
        
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .white
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = self.pages.count
        pc.currentPageIndicatorTintColor = UIColor(r: 247, g: 154, b: 27)
        
        return pc
    }()
    
    lazy var skipButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Start messaging >>", for: .normal)
        button.setTitleColor(UIColor(r: 247, g: 154, b: 27), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipGuide), for: .touchUpInside)
        
        return button
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PageCell
    
        cell.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        
        let page = pages[indexPath.item]
        cell.page = page
        
        return cell
    }
    
    @objc func skipGuide() {
        let phoneNumberController = UINavigationController(rootViewController: PhoneNumberLoginController())
            self.show(phoneNumberController, sender: Any?.self)
        print("Skip")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        collectionView.frame = view.frame
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellID)
        
        setupViews()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func setupViews() {
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
