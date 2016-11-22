//
//  ViewControllerC.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/22.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit

class ViewControllerC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        button.center = view.center
        button.setTitle("C", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.addTarget(self, action: #selector(tapButtonAction), for: .touchUpInside)
        
        view.addSubview(button)

        // Do any additional setup after loading the view.
    }

    func tapButtonAction() {
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
