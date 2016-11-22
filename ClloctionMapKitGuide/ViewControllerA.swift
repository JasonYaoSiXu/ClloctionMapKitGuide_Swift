//
//  ViewControllerA.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/22.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit

class ViewControllerA: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.center = view.center
        button.setTitle("A", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.addTarget(self, action: #selector(tapButtonAction), for: .touchUpInside)
        
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapButtonAction() {
        self.dismiss(animated: true, completion: nil)
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
