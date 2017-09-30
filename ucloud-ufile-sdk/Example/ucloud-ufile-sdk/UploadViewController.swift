//
//  UploadViewController.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/14/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import UIKit
import ucloud_ufile_sdk

class UploadViewController: UIViewController {
    var ufileSDK: UFileSDK?
    
    @IBOutlet weak var rangeText: UITextField!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func uploadFile(_ sender: AnyObject) {
        let b = Bundle.main.path(forResource: "initscreen", ofType: "jpg")
        let key = "initscreen.jpg"
        let auth = ufileSDK!.calcKey("PUT", key: key, contentMd5: "0d28630ac6120b1cdee408de0492482c", contentType: "application/jpeg")
        let data = try? Data(contentsOf: URL(fileURLWithPath: b!))
        let itMd5 = UFileAPIUtils.calcMD5(for: data!);
        let option = [kUFileSDKOptionMD5: itMd5, kUFileSDKOptionFileType: "application/jpeg"]
        
        ufileSDK!.ufileSDK!.putFile(key, authorization: auth, option: option, data: data!,
            progress: { (progress: Progress) -> Void in
                DispatchQueue.main.async(execute: {() in
                    self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
                })
            },
            success: { (result: [AnyHashable: Any]) -> Void in
                let s = key + " File Uploaded, etag: " + (result[kUFileRespETag] as! String)
                let alert = UIAlertController(title: "File Upload Done", message: s, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            },
            failure: { (err: Error) -> Void in
                
                var errMsg: String? = nil;
                if (err as NSError).domain == kUFileSDKAPIErrorDomain {
                    errMsg = (err as NSError).userInfo["ErrMsg"] as? NSString as String?;
                    NSLog("%@", (err as NSError).userInfo);
                } else {
                    errMsg = (err as NSError).description
                }
                let alert = UIAlertController(title: "File Upload Fail", message: errMsg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
        })
    }

    @IBAction func uploadHit(_ sender: AnyObject) {
        let b = Bundle.main.path(forResource: "initscreen", ofType: "jpg")
        let key = "initscreen.jpg"
        let auth = ufileSDK!.calcKey("POST", key: key, contentMd5: nil, contentType: nil)
        NSLog(auth);
        let data = try? Data(contentsOf: URL(fileURLWithPath: b!))
        let length = data!.count
        ufileSDK!.ufileSDK!.uploadHit(key, authorization: auth, fileSize: length, fileHash: "AQAAAJQnkf8WXMgGCb2-WYPgLZGI7yz1",
            success: { (result: [AnyHashable: Any]) -> Void in
                let s = key + " File UploadHit Suceess "
                let alert = UIAlertController(title: "File Upload Hit Done", message: s, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)

            },
            failure: { (err: Error) -> Void in
                
                var errMsg: String? = nil;
                if (err as NSError).domain == kUFileSDKAPIErrorDomain {
                    errMsg = (err as NSError).userInfo["ErrMsg"] as? NSString as String?;
                    NSLog("%@", (err as NSError).userInfo);
                } else {
                    errMsg = (err as NSError).description
                }
                let alert = UIAlertController(title: "File Upload Fail", message: errMsg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
        })
    }
    @IBAction func putFileFromFile(_ sender: AnyObject) {
        let b = Bundle.main.path(forResource: "initscreen", ofType: "jpg")
        let key = "123321.jpg"
        //let itMd5 = UFileAPIUtils.calcMD5ForPath(b!)
        let auth = ufileSDK!.calcKey("PUT", key: key, contentMd5: nil, contentType: "text/plain")
        let option = [
            kUFileSDKOptionFileType: "text/plain"]
        ufileSDK!.ufileSDK!.putFile(key, fromFile: b!, authorization: auth, option: option,
            progress: { (progress: Progress) -> Void in
                DispatchQueue.main.async(execute: {() in
                    self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
                })
            },
            success: { (result: [AnyHashable: Any]) -> Void in
                let s = key + " File Uploaded, etag: " + (result[kUFileRespETag] as! String)
                let alert = UIAlertController(title: "File Upload Done", message: s, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            },
            failure: { (err: Error) -> Void in
                
                var errMsg: String? = nil;
                if (err as NSError).domain == kUFileSDKAPIErrorDomain {
                    errMsg = (err as NSError).userInfo["ErrMsg"] as? NSString as String?;
                    NSLog("%@", (err as NSError).userInfo);
                } else {
                    errMsg = (err as NSError).description
                }
                let alert = UIAlertController(title: "File Upload Fail", message: errMsg!, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
        })
    }
}
