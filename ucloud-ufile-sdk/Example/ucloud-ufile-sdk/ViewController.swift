//
//  ViewController.swift
//  ufile sdk demo
//
//  Created by wu shauk on 12/11/15.
//  Copyright © 2015 ucloud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var publicKeyText: UITextField!
    @IBOutlet weak var privateKeyText: UITextField!

    @IBOutlet weak var bucketText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        publicKeyText.delegate = self;
        privateKeyText.delegate = self;
        bucketText.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
        // Dispose of any resources that can be recreated.
    @IBAction func onTouchUploadFile(_ sender: AnyObject) {
        
    }

    @IBAction func onTouchDownloadFile(_ sender: AnyObject) {
    }
    
    @IBAction func onTouchDeleteFile(_ sender: AnyObject) {
    }
    
    @IBAction func onTouchHeadFile(_ sender: AnyObject) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder();
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ufileSDK = UFileSDK(fromKeys: self.publicKeyText.text!, privateKey: self.privateKeyText.text!, bucket: self.bucketText.text!)

        if segue.identifier == "head" {
            let headViewCtrl = segue.destination as! HeadViewController
            headViewCtrl.ufileSDK = ufileSDK;
        } else if segue.identifier == "upload" {
            let headViewCtrl = segue.destination as! UploadViewController
            headViewCtrl.ufileSDK = ufileSDK;
        } else if segue.identifier == "download" {
            let headViewCtrl = segue.destination as! DownloadViewController
            headViewCtrl.ufileSDK = ufileSDK
        } else if segue.identifier == "delete"{
            let headViewCtrl = segue.destination as! DeleteViewController
            headViewCtrl.ufileSDK = ufileSDK
        } else if segue.identifier == "multipart" {
            let headViewCtrl = segue.destination as! MultipartUploadViewController
            headViewCtrl.ufileSDK = ufileSDK
        }
    }
}

