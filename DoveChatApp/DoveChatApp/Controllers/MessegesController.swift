//
//  MessagesController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase
import Security
import BigInt

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

let chatLogController = ChatLogController()
let rsaKeyGenerator = RSAKeyGenerator()

class MessagesController: UITableViewController {
    
    let cellId = "cellId"
    let n = 10
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        self.tableView.separatorColor = UIColor(r: 29, g: 29, b: 29)
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController?.searchBar.tintColor = UIColor.white
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        } else {
        
        }
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        navigationController?.navigationBar.barTintColor = UIColor(r: 74, g: 74, b: 74)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.title = "Chats"
        
        let backButton = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        checkIfUserIsLoggedIn()
        fetchUserAndSetupNavBarTitle()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        print("TOKEN=\n\(AppDelegate.DEVICEID)")
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadOfTable()
                
            })
        }
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            print(snapshot.key)
            print(self.messagesDictionary)
            
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.backgroundColor = UIColor(r: 35, g: 35, b: 35)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.timeLabel.textColor = UIColor.white
        
        let cellColor: UIView = {
            let cellColor = UIView()
            cellColor.backgroundColor = UIColor(r: 74, g: 74, b: 74)
            return cellColor
            
        }()
        cell.selectedBackgroundView = cellColor
        
        let message = messages[indexPath.row]
        let encryptedDataInDb = message.text
        if encryptedDataInDb != nil {
            let encryptedData = Data(base64Encoded: encryptedDataInDb!, options: NSData.Base64DecodingOptions())
            let decryptedData = RSAUtils.decryptWithRSAPrivateKey(encryptedData!, privkeyBase64: PRIVATE_KEY, keychainTag: TAG_PRIVATE_KEY)
            if ( decryptedData != nil ) {
                let decryptedString = NSString(data: decryptedData!, encoding:String.Encoding.utf8.rawValue)
    
                cell.detailTextLabel?.text = decryptedString! as String
            }
        }
        
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
    
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    func base64Encode(_ data: Data) -> String {
        return data.base64EncodedString(options: [])
    }
    
    func keysGeneration() {
        
        rsaKeyGenerator.p = generatePrime(512)
        rsaKeyGenerator.q = generatePrime(512)
        rsaKeyGenerator.n = rsaKeyGenerator.p * rsaKeyGenerator.q
        rsaKeyGenerator.phiN = ((rsaKeyGenerator.p - 1) * (rsaKeyGenerator.q - 1))
        
        rsaKeyGenerator.e = 65537
        rsaKeyGenerator.d = rsaKeyGenerator.e.inverse(rsaKeyGenerator.phiN)!
        
        let publicKey: (BigUInt,BigUInt) = (rsaKeyGenerator.e, rsaKeyGenerator.n)
        let privateKey:(BigUInt,BigUInt) = (rsaKeyGenerator.d, rsaKeyGenerator.n)
        
        print("PublicKey = \(publicKey)")
        print("PrivateKey = \(privateKey)")
        
        rsaKeyGenerator.statusCode = SecKeyGeneratePair(rsaKeyGenerator.keyPairAttr as CFDictionary, &rsaKeyGenerator.publicKey, &rsaKeyGenerator.privateKey)

    }
    
    func generatePrime(_ width: Int) -> BigUInt {
        while true {
            var random = BigUInt.randomInteger(withExactWidth: width)
            random |= BigUInt(1)
            if random.isPrime() {
                return random
            }
        }
    }
    
    func isPrime(n: Int) -> Bool {
        if n <= 1 {
            return false
        }
        if n <= 3 {
            return true
        }
        var i = 2
        while i*i <= n {
            if n % i == 0 {
                return false
                
            }
            i = i + 1
        }
        return true
        
    }
    
    func inverse(_ modulus: BigUInt, number: BigUInt) -> BigUInt? {
        precondition(modulus > 1)
        //Функция Эйлера (Для простых чисел N - 1)
        let phiN = modulus - 1
        
        let inverse = number ^ (phiN - 1) % number
        // 2 ^ Ф(N) - 1 mod 17 = 2 ^ 15 mod 17 = 32768 mod 17 = 9 mod 17 => 9
        
        return inverse
    }
    
    func setupNavBarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        present(PhoneNumberLoginController(), animated: true, completion: nil)
    }
    
}


