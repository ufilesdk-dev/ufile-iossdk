//
//  UFileSDK.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/14/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import Foundation

import ucloud_ufile_sdk;

class UFileSDK {
    
    var ufileSDK: UFileAPI?
    var bucket: String?
    var publicKey: String?
    var privateKey: String?
    
    init(fromKeys publicKey: String, privateKey: String, bucket: String) {
        //单区域空间上传域名，对应下载地址 http://{bucketname}.ufile.ucloud.cn/{filename}
        self.ufileSDK = UFileAPI(bucket:bucket, url:"http://ufile.ucloud.cn")
        //全球化空间上传域名，对应下载地址 http://{bucketname}.dl.ufileos.com/{filename}
        //self.ufileSDK = UFileAPI(bucket:bucket, url:"http://up.ufileos.com")
        self.bucket = bucket;
        self.publicKey = publicKey;
        self.privateKey = privateKey;
    }
    
    func calcKey(_ httpMethod: String, key: String, contentMd5: String?, contentType: String?) -> String {
        var s = httpMethod + "\n";
        if let type = contentMd5 {
            s += type;
        }
        s += "\n";
        if let md5s = contentType {
            s += md5s;
        }
        s += "\n";
        // date
        s += "\n";
        // ucloud header
        s += "";
        s += "/" + self.bucket! + "/" + key;
        return self._sha1Sum(self.privateKey!, s: s)
    }
    
    fileprivate func _sha1Sum(_ key: String, s: String) -> String {
        let str = s.cString(using: String.Encoding.utf8)
        let strLen = Int(s.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return "UCloud " + self.publicKey! + ":" + digest;
    }
    
    fileprivate func stringFromResult(_ result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = Data(bytes: UnsafePointer<UInt8>(result), count: length);
        return hash.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}
