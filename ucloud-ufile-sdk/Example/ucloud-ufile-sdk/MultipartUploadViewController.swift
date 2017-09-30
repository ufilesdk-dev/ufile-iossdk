//
//  MultipartUploadViewController.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/16/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import UIKit
import ucloud_ufile_sdk

class MultipartUploadViewController : UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var startUpload: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var finishUploadBtn: UIButton!
    
    var ufileSDK : UFileSDK?
    var session: MultipartSession?
    var tableController: MultipartTableController?
    
    @IBOutlet weak var upload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableController = MultipartTableController()
        self.table.delegate = self.tableController
        self.table.dataSource = self.tableController
        self.table.reloadData()
        self.startUpload.isEnabled = true
        self.finishUploadBtn.isEnabled = false
        self.cancelBtn.isEnabled = false
    }
    
    @IBAction func uploadBtnClicked(_ sender: AnyObject) {
        
        self.cancelBtn.isEnabled = true
        self.finishUploadBtn.isEnabled = true
        self.startUpload.isEnabled = false

        let b = Bundle.main.path(forResource: "initscreen", ofType: "jpg")
        let key = "test-multipart.jpg"
 //       let data = NSData(contentsOfFile: b!)
        let auth = ufileSDK!.calcKey("POST", key: key, contentMd5: nil, contentType: nil)
        ufileSDK!.ufileSDK!.multipartUploadStart(key, authorization: auth,
            success: { (result: [AnyHashable: Any]) -> Void in
                let msg = String(format: "Multipart start:\n uploadId=%@\nblockSize=%lu\nbucketName=%@\nKey=%@\n", arguments: [result[kUFileRespUploadId] as! NSString, (result[kUFileRespBlockSize] as! NSNumber).intValue, result[kUFileRespBucketName] as! NSString, result[kUFileRespKeyName] as! NSString]);
                self.session = MultipartSession(info: self.ufileSDK!, uploadId: result[kUFileRespUploadId] as! NSString as String, blockSize: UInt(result[kUFileRespBlockSize] as! NSNumber), fileURL: b!, key: key)
                self.tableController?.setSession(self.session!)
                self.table.reloadData()
                self.showMsg(msg)
                
            },
            failure: { (err) -> Void in
                self.showError(err as NSError)
        })
    }
    
    fileprivate func showMsg(_ msg: String) {
        let alert = UIAlertController(title: "File Upload Done", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showError(_ err: NSError) {
        var errMsg: String? = nil;
        if err.domain == kUFileSDKAPIErrorDomain {
            errMsg = err.userInfo["ErrMsg"] as? NSString as String?;
            NSLog("%@", err.userInfo);
        } else {
            errMsg = err.description
        }
        let alert = UIAlertController(title: "File Upload Fail", message: errMsg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func finishUpload(_ sender: AnyObject) {
        self.cancelBtn.isEnabled = false
        self.finishUploadBtn.isEnabled = false
        self.startUpload.isEnabled = true
        let auth = self.ufileSDK!.calcKey("POST", key: self.session!.key, contentMd5: nil, contentType: "application/jpeg")
        self.ufileSDK!.ufileSDK!.multipartUploadFinish(self.session!.key, uploadId: self.session!.uploadId, newKey: self.session!.key+NSTimeIntervalSince1970.description, etags: self.session!.etags, contentType: "application/jpeg", authorization: auth, success: { (result:[AnyHashable: Any]) -> Void in
                let s = String(format: "File upload success\nBucket=%@\nKey=%@\nFileSize=%@", arguments: [result[kUFileRespBucketName] as! NSString, result[kUFileRespKeyName] as! NSString, result[kUFileRespLength] as! NSNumber])
                self.showMsg(s)
            }) { (err) -> Void in
                self.showError(err as NSError)
        }
        
        self.session = nil
    }
    
    @IBAction func cancelUpload(_ sender: AnyObject) {
        self.cancelBtn.isEnabled = false
        self.finishUploadBtn.isEnabled = false
        self.startUpload.isEnabled = true
        let auth = self.ufileSDK!.calcKey("DELETE", key: self.session!.key, contentMd5: nil, contentType: nil)
        self.ufileSDK!.ufileSDK!.multipartUploadAbort(self.session!.key, uploadId: self.session!.uploadId, authorization: auth,success: { (result:[AnyHashable: Any]) -> Void in
            let s = String("File upload aborted")
            self.showMsg(s!)
            }) { (err) -> Void in
                self.showError(err as NSError)
        }
        self.session = nil

    }
    
}

