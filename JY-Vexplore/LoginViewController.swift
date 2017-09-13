//
//  LogoutViewController.swift
//  JY-Vexplore
//
//  Created by JYKit on 2017/9/12.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SharedKit
class LoginViewController: UIViewController {
    private var loginRequest: Request?
    var successHandler: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var loginBtnTapped: UIButton!
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        loginRequest?.cancel()
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
