//
//  ChatLogController.swift
//  DoveChatApp
//
//  Created by Dan on 10.04.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import SwiftyRSA
import Alamofire



//

// RSA public key in base64 / Key length: 512 bits
let PUBLIC_KEY = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJh+/sdLdlVVcM5V5/j/RbwM8SL++Sc3dMqMK1nP73XYKhvO63bxPkWwaY0kwcUU40+QducwjueVOzcPFvHf+fECAwEAAQ=="

// RSA private key in base64 / Key length: 512 bits
let PRIVATE_KEY = "MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAmH7+x0t2VVVwzlXn+P9FvAzxIv75Jzd0yowrWc/vddgqG87rdvE+RbBpjSTBxRTjT5B25zCO55U7Nw8W8d/58QIDAQABAkBCNqIZlsKCut6IOPTIQM7eoB/zuhIk3QdxCvunu4mV+OIv00b6lN02ZsQ64nblu6dP9UuhlyclFaGlXtwqfkABAiEA0XQlb0mT5cZ8VpNNOqojeWoyrvQIRPGhdBrq3VroT4ECIQC6YoVd0yaT6lUDV+tgKtNbQN8m9hVIMgE/awRT/aXicQIhAK+jIbEMlgTcSG+g3eYPveeWciHbaQPHS4g8+i3ciWoBAiBddJsEwaQ9VKlN5N67uJ2DyxJZediP+6rOfr2L08pCsQIhAJLmeidBF0uJxNZiBgnkIHlRQ167qE1D0s5SQ2j5217G"
let messagesController = MessagesController()


// tag name to access the stored private key stored in keychain
let TAG_PRIVATE_KEY = "com.github.btnguyen2k.Sample_Private"

// tag name to access the stored public key in keychain
let TAG_PUBLIC_KEY = "com.github.btnguyen2k.Sample_Public"

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User? {
        didSet {
            let userId = user?.id
            let online = "Online"
            let offline = "Offline"
            let typing = "is typing..."
            
            Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                let status = dictionary["status"] as! String
                
                if status == "true" {
                    self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: online)
                } else if status == "false" {
                    self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: offline)
                } else {
                    self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: (self.user?.name)! + typing)
                }
            }
            
            Database.database().reference().child("users").child(userId!).observe(.childChanged) { (snapshot) in
                print(snapshot)
                Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print("TEST\(snapshot)")
                    guard let dictionary = snapshot.value as? [String:Any] else {return}
                    let status = dictionary["status"] as! String
                    
                    if status == "true" {
                        self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: online)
                    } else if status == "false" {
                        self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: offline)
                    } else {
                        self.navigationItem.setTitle(title: (self.user?.name)!, subtitle: (self.user?.name)! + typing)
                    }
                })
               
            }
                
            observeMessages()
        }
    }
    
    
    var messages = [Message]()
    
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    let cellId = "cellId"
//    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: "background")
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        
//        self.player.playerDelegate = self as? PlayerDelegate
//        self.player.playbackDelegate = self as? PlayerPlaybackDelegate
//        self.player.view.frame = self.view.bounds
//
//
//        let closeButton = UIButton(type: .custom)
//        closeButton.setTitle("Close", for: .normal)
//        closeButton.tintColor = .white
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        closeButton.autoSetDimensions(to: CGSize(width: 50, height: 50))
//        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        player.view.addSubview(closeButton)
//
//        closeButton.topAnchor.constraint(equalTo: player.view.topAnchor, constant: 30).isActive = true
//        closeButton.leftAnchor.constraint(equalTo: player.view.leftAnchor, constant: 30).isActive = true
//
//
//        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        self.player.view.addGestureRecognizer(tapGestureRecognizer)
//
//        self.player.fillMode = PlayerFillMode.resizeAspectFit.avFoundationType
        
        setupKeyboardObservers()
        setupUserButton()
        setupUserInfoButton()
    }
    
    
    let userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.layer.cornerRadius = 20
        userImage.layer.masksToBounds = true
        userImage.contentMode = .scaleAspectFill
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        return userImage
    }()
    
    let userButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOpenUserProfile), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    @objc func handleOpenUserProfile() {
        let userId = user?.id
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = userId
            self.showChatControllerForUser(user)
        })
    }
    
    func showChatControllerForUser(_ user: User) {
        let userProfileVC = UserInfoViewController()
        userProfileVC.user = user
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func setupUserInfoButton() {
        let userId = user?.id
        
        Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    let url = URL(string: profileImageUrl)
                    
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            var image = self.userImage.image
                            image = UIImage(data: data!)
                            self.userButton.setImage(image, for: UIControlState.normal)
                        }
                    }
                }
            }
        }
        let barButtonItem = UIBarButtonItem(customView: userButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupUserButton() {
        
        view.addSubview(userButton)
        
        userButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.backgroundColor = UIColor(r: 74, g: 74, b: 74)
        chatInputContainerView.chatLogController = self
        chatInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        return chatInputContainerView
    }()
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error!)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.sendMessageWithProperties(properties)
                        
                    })
                }
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            })
           
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell

        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        
        let encryptedDataInDb = message.text
        if encryptedDataInDb != nil {
            let encryptedData = Data(base64Encoded: encryptedDataInDb!, options: NSData.Base64DecodingOptions())
            let decryptedData = RSAUtils.decryptWithRSAPrivateKey(encryptedData!, privkeyBase64: PRIVATE_KEY, keychainTag: TAG_PRIVATE_KEY)
            if ( decryptedData != nil ) {
                let decryptedString = NSString(data: decryptedData!, encoding:String.Encoding.utf8.rawValue)
                cell.textView.text = decryptedString! as String
            
                if let text = decryptedString {
                    
                    cell.bubbleWidthAnchor?.constant = estimateFrameForText(text as String).width + 32
                    cell.textView.isHidden = false
                }
            } else {
                print("error while decrypting")
            }
        }
        
        cell.message = message
        
        setupCell(cell, message: message)
        
        if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.darkGreyColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]

        let encryptedDataInDb = message.text
        if encryptedDataInDb != nil {
            let encryptedData = Data(base64Encoded: encryptedDataInDb!, options: NSData.Base64DecodingOptions())
            let decryptedData = RSAUtils.decryptWithRSAPrivateKey(encryptedData!, privkeyBase64: PRIVATE_KEY, keychainTag: TAG_PRIVATE_KEY)
            if ( decryptedData != nil ) {
                let decryptedString = NSString(data: decryptedData!, encoding:String.Encoding.utf8.rawValue)
                if let text = decryptedString {
                    height = estimateFrameForText(text as String).height + 20
                }
            }
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleSend() {
        if inputContainerView.inputTextField.text != "" {
            
            let properties = ["text": encryptData()]
            sendMessageWithProperties(properties as [String : AnyObject])
            
        }
        
    }
    
    func encryptData() -> String {
        let encryptText = inputContainerView.inputTextField.text
        let encryptedData = RSAUtils.encryptWithRSAPublicKey(encryptText!.data(using: String.Encoding.utf8)!, pubkeyBase64: PUBLIC_KEY, keychainTag: TAG_PUBLIC_KEY)
        let encryptedDataText = encryptedData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        return encryptedDataText
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let deviceId = AppDelegate.DEVICEID
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject,"deviceID": deviceId as AnyObject]
        
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        fetchmessages(toId: toId)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputContainerView.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
        
    }
    
    func fetchmessages(toId: String)
    {
        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let fromDevice = dictionary["deviceID"] as! String
            
            print(fromDevice)
            self.setupNotification(deviceId: fromDevice)
        }
    }
    
    
    func setupNotification(deviceId:String) {
        let toId = Auth.auth().currentUser?.uid
        let toDeviceID = deviceId
        
        Database.database().reference().child("users").child(toId!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let title = dictionary["name"] as! String
            
            if self.inputContainerView.inputTextField.text! != "" {
                let body = self.inputContainerView.inputTextField.text!
                
                var headers:HTTPHeaders = HTTPHeaders()
                
                headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVERKEY)"]
                
                let notification = ["to":"\(toDeviceID)","notification":["body":body,"title":"\(title)","badge":1,"sound":"default"]] as [String:Any]
                
                Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
                    print(response)
                }
            } else {
                let body = "🏞 Media"
                
                var headers:HTTPHeaders = HTTPHeaders()
                
                headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVERKEY)"]
                
                let notification = ["to":"\(toDeviceID)","notification":["body":body as Any,"title":"\(title)","badge":1,"sound":"default"]] as [String:Any]
                
                Alamofire.request(AppDelegate.NOTIFICATION_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
                    print(response)
                }
            }
        }
        
       
        
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
    func encryptWithRSAPublickey(data: Double, pubKeyBase64: Double, keychainTag: String) -> Double {
        let encryptedMessage = pow(data, pubKeyBase64).truncatingRemainder(dividingBy: Double(rsaKeyGenerator.n))
        
        return encryptedMessage
    }
    func decryptWithRSAPrivateKey(data: Double, privKeyBase64: Double, keychainTag: String) -> Double {
        let decryptedMessage = pow(data, privKeyBase64).truncatingRemainder(dividingBy: Double(rsaKeyGenerator.n))
        
        return decryptedMessage
    }
}
