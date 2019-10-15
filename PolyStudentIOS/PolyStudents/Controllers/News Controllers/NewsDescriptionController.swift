//
//  NewsDescription.swift
//  PolyStudents
//
//  Created by Dan on 25/02/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class NewsDescriptionController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UITextView!
    
    let htmlParser = HTMLParser()

    
    
    var newsItem: RSSItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsDescription.text = ""
        newsImage.image = nil
        titleLabel.text = ""
        
        DispatchQueue.main.async {
            self.interfaceSetup()
        }

    }
    
   private func interfaceSetup() {
        if let item = newsItem {
            ImageDonwloader.getImage(withURL: URL(string: item.imageUrl)!) { (image) in
                self.newsImage.image = image
                self.titleLabel.text = item.title
                self.htmlParser.getHTML(withURL: URL(string: item.articleUrl)!, completion: { (articleText, error) in
                    if error != nil {
                        print(error)
                        self.newsDescription.text = "Что-то пошло не так"
                    } else {
                        self.newsDescription.text = articleText
                    }
                })
            }
        }
    }
}
