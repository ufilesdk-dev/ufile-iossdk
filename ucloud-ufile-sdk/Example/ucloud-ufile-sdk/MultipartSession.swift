//
//  MultipartSession.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/16/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import Foundation

class MultipartSession {
    var uploadId: String
    var blockSize: UInt
    var fileData: Data
    var key: String
    var fileSize: UInt
    var allParts: UInt
    var ufileSDK: UFileSDK
    var etags: [String]
    
    init(info ufileSDK:UFileSDK, uploadId: String, blockSize: UInt, fileURL: String, key: String) {
        self.uploadId = uploadId
        self.blockSize = blockSize
        self.fileData = try! Data(contentsOf: URL(fileURLWithPath: fileURL))
        self.key = key
        let attr = try! FileManager.default.attributesOfItem(atPath: fileURL)
        self.fileSize = UInt((attr[FileAttributeKey.size] as! NSNumber).intValue)
        self.allParts = (self.fileSize+blockSize-1)/(blockSize)
        self.ufileSDK = ufileSDK
        self.etags = [String](repeating: "", count: Int(self.allParts))
    }
    
    func getDataForPart(_ partNumber: UInt) -> Data? {
        if partNumber >= self.allParts {
            return nil
        }
        let loc = partNumber * self.blockSize
        var length = self.blockSize
        let end = loc + length
        if end > self.fileSize {
            length = self.fileSize - loc
        }
        return self.fileData.subdata(in: (Int(loc) ..< (Int(loc) + Int(length))))
    }
    
    func addEtag(_ partNumber: UInt, etag: String) {
        self.etags[Int(partNumber)] = etag
    }
 
    func outputEtags() -> String {
        return self.etags.joined(separator: ",")
    }
}
