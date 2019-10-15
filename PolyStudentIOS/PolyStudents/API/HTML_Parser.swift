//
//  HTML_Parser.swift
//  PolyStudents
//
//  Created by Dan on 26/02/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import Foundation
import SwiftSoup

class HTMLParser {
    
    let cache = NSCache<NSString, NSString>()
    
    private var article: String = "" {
        didSet {
            article = article.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseHTML(withURL url: URL, completion: @escaping (_ articleText: String?, _ error: Error?) ->()) {
        do {
            let myHTMLString = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parseBodyFragment(myHTMLString)
            let element: Elements = try doc.select("p")
            let elementText: String = try element.html()
            article = String(elementText.dropLast(76))
            let modifyedText = article.replacingOccurrences(of: "<[^>]+>",
                                                            with: "",
                                                            options: .regularExpression,
                                                            range: nil)
            let trimmed = modifyedText.replacingOccurrences(of:"\n",
                                                            with: "\n\n", options: .regularExpression)
            
            if trimmed != "" {
                cache.setObject(trimmed as NSString, forKey: url.absoluteString as NSString)
                print(cache)
            }
            
            completion(trimmed, nil)
            
        } catch Exception.Error(let message) {
            print(message)
            completion(nil, message as? Error)
        } catch {
            print("error")
        }
    }
    
    func getHTML(withURL url: URL, completion: @escaping (_ articleText: String?, _ error: Error?) ->()) {
        if let articleText = cache.object(forKey: url.absoluteString as NSString) {
            completion(articleText as String, nil)
        } else {
            parseHTML(withURL: url, completion: completion)
        }
        
    }
}
