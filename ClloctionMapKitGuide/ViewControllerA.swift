//
//  ViewControllerA.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/23.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit

class ViewControllerA: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        let button = UIButton()
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.sizeToFit()
        button.center = view.center
        button.addTarget(self, action: #selector(tapDismissAction), for: .touchUpInside)
        
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    func tapDismissAction() {
        self.dismiss(animated: true, completion: nil)
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
