//
//  AppDelegate.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/16.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LocationService.default.requestLocationService()
        UserNotification.registerUserNotification()
        
        if (launchOptions?[.location]) != nil {
            writeToLogFile(write: "程序因位置变化在后台启动")
            LocationService.default.startLocation()
        }
        
        if launchOptions != nil {
            writeToLogFile(write: "未知原因导致程序后台运行。")
            LocationService.default.startLocation()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        writeToLogFile(write: "\(#function)")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        writeToLogFile(write: "\(#function)")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        writeToLogFile(write: "\(#function)")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        writeToLogFile(write: "\(#function)")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        writeToLogFile(write: "\(#function)")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate {
    
    func logFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [NSString]
        let filePath = documentPath[0].appendingPathComponent("logFile")
        return filePath
    }
    
    func transformDateToString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormat.string(from: Date())
    }
    
    
    func writeToLogFile(write: String) {
        let fileManager = FileManager.default
        let writeContent = "\n" + transformDateToString() + ":" + write
        
        if fileManager.fileExists(atPath: logFilePath()) {
            print("文件已存在!")
        } else {
            if fileManager.createFile(atPath: logFilePath(), contents: nil, attributes: nil) {
                print("创建文件成功!")
            } else {
                print("创建文件失败!")
            }
        }
        
        guard let fileHandel = FileHandle(forWritingAtPath: logFilePath()) else {
            return
        }
        fileHandel.seekToEndOfFile()
        
        guard let data = writeContent.data(using: .utf8) else {
            return
        }
        fileHandel.write(data)
        fileHandel.closeFile()
    }
    
}


