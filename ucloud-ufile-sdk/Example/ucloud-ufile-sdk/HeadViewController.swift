//
//  HeadViewController.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/14/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import UIKit
import ucloud_ufile_sdk

class HeadViewController: UIViewController {
    var ufileSDK: UFileSDK?
    
    @IBOutlet weak var fileNameText: UITextField!
    
    @IBAction func headFile(_ sender: AnyObject) {
        let key = fileNameText.text!
        let auth = ufileSDK!.calcKey("HEAD", key: key, contentMd5: nil, contentType: nil);
        ufileSDK!.ufileSDK?.headFile(key, authorization: auth,
            success: { (result: [AnyHashable: Any]) -> Void in
                NSLog("%@", result);
                let s = "etag: " + (result[kUFileRespETag] as! NSString as String) + "\n"
                      + "filetype: " + (result[kUFileRespFileType] as! NSString as String) + "\n"
                    + "length: " + (result[kUFileRespLength] as! NSString as String)
                let alert = UIAlertController(title: "File Info", message: s, preferredStyle: UIAlertControllerStyle.alert)
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
        } )
    }
}
