//
//  RSAKeysGenerator.swift
//  DoveChatApp
//
//  Created by Dan on 02.05.2018.
//  Copyright © 2018 Daniil. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class RSAKeyGenerator: NSObject {
    
    var error: Unmanaged<CFError>? = nil
    var statusCode: OSStatus = 0
    var publicKey: SecKey?
    var privateKey: SecKey?
    var p: BigUInt = 0
    var q:BigUInt = 0
    var n:BigUInt = 0
    var phiN:BigUInt = 0
    var e: BigUInt = 0
    var d: BigUInt = 0
    
    let publicKeyAttribute: [NSObject : NSObject] = [kSecAttrIsPermanent: true as NSObject, kSecAttrApplicationTag: "dove.apppublic".data(using: String.Encoding.utf8)! as NSObject]
    
    let privateKeyAtrribute: [NSObject: NSObject] = [kSecAttrIsPermanent: true as NSObject, kSecAttrApplicationTag: "dove.appprivate".data(using: String.Encoding.utf8)! as NSObject]
    
    var keyPairAttr = [NSObject: Any]()
    
}

