//
//  NewsCollectionController.swift
//  PolyStudents
//
//  Created by Dan on 24/12/2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit

class NewsCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "cell"
    private var rssItems: [RSSItem]?
    private let rssURL = "***"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: Network.reachability)
        
        collectionView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        
        updateUserInterface()
        fetchData()
    }
    
    @objc private func fetchData() {
        let feedParser = FeedParser()
        self.navigationItem.title = "Соединение..."
        if Network.reachability.status == .unreachable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.navigationItem.title = "Нет интернет соединения"
                self.refreshControl.endRefreshing()
            }
        }
        feedParser.parseFeed(url: rssURL) { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
                self.navigationItem.title = "Новости"
                self.refreshControl.endRefreshing()
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let RSSItems = rssItems {
            return RSSItems.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsCollectionCell
        if let RSSItems = rssItems {
            let item = RSSItems[indexPath.row]
            cell.titleLabel.text = item.title
            ImageDonwloader.getImage(withURL: URL(string: item.imageUrl)!) { (image) in
                cell.imageNews.image = image
            }
        }
        
        return cell
    }
    
    //MARK: - Flow layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    //MARK: - Segue
    
    private func rssItem(at indexPath: IndexPath) -> RSSItem {
        return rssItems![indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDescription" {
            let cell = sender as! NewsCollectionCell
            if let selectedIndexPath = collectionView.indexPath(for: cell) {
                let selectedNews = rssItem(at: selectedIndexPath)
                
                let newsDescriptionController = segue.destination as! NewsDescriptionController
                
                newsDescriptionController.newsItem = selectedNews
                
            }
        }
    }
    
    //MARK: - Network check update interface
    
    private func updateUserInterface() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView!.collectionViewLayout = layout
        
        switch Network.reachability.status {
        case .unreachable:
            self.navigationItem.title = "Нет интернет соединения"
        case .wifi:
            self.navigationItem.title = "Новости"
            fetchData()
        case .wwan:
            self.navigationItem.title = "Новости"
            fetchData()
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }

}
