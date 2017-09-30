//
//  MultipartTableCell.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/16/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import UIKit
import ucloud_ufile_sdk

class MultipartTableCell: UITableViewCell {
    var session: MultipartSession?
    var partNumber: Int = 0
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    func setSession(_ session: MultipartSession, partNumber: Int) {
        self.session = session
        self.partNumber = partNumber
        self.progressBar.setProgress(0, animated: false)
        self.downloadBtn.isEnabled = true
    }
    
    @IBAction func startDownload(_ sender: AnyObject) {
        let contentType = "application/jpeg"
        let auth = self.session!.ufileSDK.calcKey("PUT", key: self.session!.key, contentMd5: nil, contentType: contentType)
        let option = [
            kUFileSDKOptionTimeoutInterval: NSNumber(value: 5.0 as Double)
        ]
        self.session!.ufileSDK.ufileSDK?.multipartUploadPart(self.session!.key, uploadId: self.session!.uploadId, partNumber: self.partNumber, contentType: contentType, data: (self.session!.getDataForPart(UInt(self.partNumber)))!, option: option, authorization: auth,
            progress: { (progress:Progress) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
                })
            },
            success: { (result: [AnyHashable: Any]) -> Void in
                self.downloadBtn.isEnabled = false
                self.session!.addEtag(UInt(self.partNumber), etag: result[kUFileRespETag] as! NSString as String)
            },
            failure: { (err: Error) -> Void in
                self.progressBar.backgroundColor = UIColor.red
        })
    }
}
