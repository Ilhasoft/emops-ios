//
//  URLoginCredentialsViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 13/07/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit
import Firebase

class URLoginCredentialsViewController: UIViewController {

    @IBOutlet weak var btForgotPassword: UIButton!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    var appDelegate:AppDelegate!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "URLoginCredentialsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Login Credentials")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        ProgressHUD.dismiss()        
    }
    
    //MARK: Button Events
    @IBAction func btForgotPasswordTapped(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.pushViewController(URForgotPasswordViewController(), animated: true)
    }

    @IBAction func btLoginTapped(sender: AnyObject) {
        
        if let textfield = self.view.findTextFieldEmptyInView(self.view) {
            UIAlertView(title: nil, message: String(format: "is_empty".localized, arguments: [textfield.placeholder!]), delegate: self, cancelButtonTitle: "OK").show()
            return
        }
        
        self.view.endEditing(true)
        ProgressHUD.show(nil)
        URUserLoginManager.login(self.txtLogin.text!,password: self.txtPassword.text!, completion: { (FAuthenticationError,success) -> Void in
        ProgressHUD.dismiss()
            if success {                
                URNavigationManager.setupNavigationControllerWithMainViewController(URMainViewController())
            }else {
                UIAlertView(title: nil, message: "login_password_error".localized, delegate: self, cancelButtonTitle: "OK").show()
            }
        })
    }
    
    //MARK: Class Methods
    
    func setupUI() {
        self.btForgotPassword.setTitle("login_forgot_password".localized, forState: UIControlState.Normal)
        
        self.txtLogin.placeholder = "login_email".localized
        self.txtPassword.placeholder = "login_password".localized
        
        self.navigationController?.navigationBar.barTintColor = URConstant.Color.LOGIN_PRIMARY
    }
    
}
