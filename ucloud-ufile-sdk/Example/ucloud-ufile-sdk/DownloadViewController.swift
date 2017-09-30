
//
//  DownloadViewController.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/14/15.
//  Copyright © 2015 ucloud. All rights reserved.
//


import UIKit
import ucloud_ufile_sdk

class DownloadViewController: UIViewController {
    var ufileSDK: UFileSDK?
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var rangeText: UITextField!
    @IBOutlet weak var downloadFileName: UITextField!
    @IBAction func downloadFile(_ sender: AnyObject) {
        progress.setProgress(0.0, animated: true)
        let range = self.rangeText.text!
        let fileName = self.downloadFileName.text!
        var options = [String:NSObject]()
        if !range.isEmpty {
            options[kUFileSDKOptionRange] = range as NSObject
        }
        let auth = ufileSDK!.calcKey("GET", key: fileName, contentMd5: nil, contentType: nil);
        ufileSDK?.ufileSDK!.getFile(fileName, authorization: auth, option: options as [AnyHashable: Any], progress: { (p: Progress) -> Void in
                DispatchQueue.main.async {
                    self.progress.setProgress(Float(p.fractionCompleted), animated: true)
                }
            },
            success: {(result: [AnyHashable: Any], responseObj: Any) -> Void in
                let data = responseObj as! Data
                let alert = UIAlertController(title: "File Delete Done", message: fileName + " File Downloaded, file size: " + UInt(data.count).description, preferredStyle: UIAlertControllerStyle.alert)
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
                let alert = UIAlertController(title: "Fail Shame", message: errMsg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
        })

    }
    @IBAction func downloadToFile(_ sender: AnyObject) {
        progress.setProgress(0.0, animated: true)
        let range = self.rangeText.text!
        let fileName = self.downloadFileName.text!
        var options = [String:NSObject]()
        if !range.isEmpty {
            options[kUFileSDKOptionRange] = range as NSObject
        }
        options[kUFileSDKOptionTimeoutInterval] = NSNumber(value: 5.00 as Double)
        let dirUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask);
        let downloadFile = URL(fileURLWithPath:dirUrl[0].path+"/"+fileName);
        let auth = ufileSDK!.calcKey("GET", key: fileName, contentMd5: nil, contentType: nil);
        ufileSDK!.ufileSDK!.getFile(fileName, toFile: downloadFile.path, authorization: auth, option: options  as [AnyHashable: Any],
            progress: { (p: Progress) -> Void in
                DispatchQueue.main.async {
                    self.progress.setProgress(Float(p.fractionCompleted), animated: true)
                }
            },
            success: {(result: [AnyHashable: Any], responseObj: Any) -> Void in
                let data = (responseObj as! URL).absoluteString
                let alert = UIAlertController(title: "File Delete Done", message: fileName + " File Downloaded to " + data, preferredStyle: UIAlertControllerStyle.alert)
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
                let alert = UIAlertController(title: "Fail Shame", message: errMsg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
        })

    }
}
