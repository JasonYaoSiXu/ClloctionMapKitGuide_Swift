//
//  ConfigUserNotification.swift
//  ClloctionMapKitGuide
//
//  Created by yaosixu on 2016/11/21.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import Foundation
import UserNotifications

enum CateGeographicalIdentifier: String {
    ///进入某个地区
    case categorEnterGeographical = "categorEnterGeographical"
    ///离开某个地区
    case categorExitGeographical = "categorExitGeographical"
    ///进入某个Beacon的范围
    case categorEnterBeacon = "categorEnterBeacon"
    ///离开某个Beacon的范围
    case categorExitBeacon = "categorExitBeacon"
    
    //检测当前用户是否在某个Beacon或者Geographocal内
    case userInsideCompany = "userInsideCompany"
    case userInsideHome = "userInsideHome"
    case userInsideBeacon = "userInsideBeacon"
    
    case userOutsideCompany = "userOutsideCompany"
    case userOutsideHome = "userOutsideHome"
    case userOutsideBeacon = "userOutsideBeacon"
}

class UserNotification: NSObject {
    
    ///注册本地通知
    class func registerUserNotification() {
        //通知的表现形式，是否有角标、提示的形式如横幅、提示音
        let userNotificationType: UNAuthorizationOptions = [.badge, .alert, .sound]
        //获取当前的用户通知
        let userNotificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
        //删除已经送达的通知
        userNotificationCenter.removeAllDeliveredNotifications()
        //删除等待送达的通知
        userNotificationCenter.removeAllPendingNotificationRequests()
        //检测用户通知是否可用，当用户关闭通知时不可用，或者当用户在设置里面将该应用的 在“通知中心”显示等全部关掉时不可用
        userNotificationCenter.requestAuthorization(options: userNotificationType, completionHandler: {
            //completionHandler 的参数是一个元组类型 $0.0 是一个bool类型的值代表是否可用，$0.1是一个Error类型存放的是错误信息
            if $0.0 == true {
                return
            } else if $0.0 == false {
                print("无法进行推送!")
                print("pushError\($0.1)")
            }
        })
        
        /**
            用来定义一个通知的某个操作，在ios10以及之后，当你像使用3DTouch那样按压一个通知，在通知的下方会弹出一组操作，如删除、回复等等
            用UNNotificationAction便可以定义这样的一个操作
            identifier: 一个动作的唯一标识符
            title: 就是在通知下方弹出一组操作时，每个操作的名称
            options: 是一个可选集合有三个值，可以混合搭配。 authenticationRequired：当用户点击这个操作时，是否要求解锁（前提应该是设备处在锁定状态）
                                                                                                destructive: 在使用通知时没有没有发现一些操作的文字是红色的？ 如果需要title是红色的就的设置这个值
                                                                                                foreground: 如果你的应用是处于未运行状态活着后台状态，当你点击该操作时引用是否进入前台。设置这个属性时当你点击一个操作时应用会进入前台（活跃状态）
         */
        let lookNote = UNNotificationAction(identifier: "look", title: "查看", options: [.authenticationRequired, .foreground])
        let deleteNote = UNNotificationAction(identifier: "delete", title: "删除", options: [.destructive])
        /**
            定义一个通知类型
            identifier: 是一个唯一用来区分通知的标识
            actions: 是一个用来存放一个通知有几种操作的数组，类型是[UNNotificationAction]，上面已经介绍了怎么用
            intentIdentifiers: 没明白什么意思
            options: 是UNNotificationCategoryOptions类型的可选集合，有两个值 customDismissAction: 当用户设置了该值，在用户删除这个通知时会调用UNUserNotificationCenter 的代理方法
                                                                                                                                      allowInCarPlay: 只知道和CarPlay有关
         */
        let userNotificationEnterGeographicalCategor = UNNotificationCategory(identifier: CateGeographicalIdentifier.categorEnterGeographical.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userNotificationExitGeographicalCategor = UNNotificationCategory(identifier: CateGeographicalIdentifier.categorExitGeographical.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userNotificationEnterBeaconCategor = UNNotificationCategory(identifier: CateGeographicalIdentifier.categorEnterBeacon.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userNotificationExteBeaconCategor = UNNotificationCategory(identifier: CateGeographicalIdentifier.categorExitBeacon.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        
        let userInsideCompany = UNNotificationCategory(identifier: CateGeographicalIdentifier.userInsideCompany.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userInsideHome = UNNotificationCategory(identifier: CateGeographicalIdentifier.userInsideHome.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userInsideBeacon = UNNotificationCategory(identifier: CateGeographicalIdentifier.userInsideBeacon.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userOutsideCompany = UNNotificationCategory(identifier: CateGeographicalIdentifier.userOutsideCompany.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userOutsideHome = UNNotificationCategory(identifier: CateGeographicalIdentifier.userOutsideHome.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        let userOutsideBeacon = UNNotificationCategory(identifier: CateGeographicalIdentifier.userOutsideBeacon.rawValue, actions: [lookNote,deleteNote], intentIdentifiers: [], options: [.customDismissAction])
        
        let userEnterCompany = UNNotificationCategory(identifier: "userEnterCompany", actions: [], intentIdentifiers: [], options: [.customDismissAction])
        let userEnterHome = UNNotificationCategory(identifier: "userEnterHome", actions: [], intentIdentifiers: [], options: [.customDismissAction])
        
        let setNotificationCategory: Set<UNNotificationCategory> = [userNotificationEnterGeographicalCategor, userNotificationExitGeographicalCategor, userNotificationEnterBeaconCategor, userNotificationExteBeaconCategor, userInsideCompany, userInsideHome, userInsideBeacon, userOutsideCompany, userOutsideHome, userOutsideBeacon,userEnterCompany,userEnterHome]
        //将自已定的通知类型添加到userNotificationCenter
        userNotificationCenter.setNotificationCategories(setNotificationCategory)
    }
}
