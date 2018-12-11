//
//  AppDelegate.swift
//  MangoPractice
//
//  Created by Bernard Hur on 11/11/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import GoogleMaps // 구글맵 임폴트
import GooglePlaces // 구글플레이스(식당 등록 메뉴주소 자동완성 등에 필요)
import FBSDKCoreKit // 페이스북 로그인 설정

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 구글맵 사용을 위해 실제 API 키를 입력합니다. 이 키는 외부 노출 안시키는게 좋습니다.
        GMSServices.provideAPIKey("AIzaSyD2hQFiuJNqB7OdgDLqhYREhimyhp32CIU")
        GMSPlacesClient.provideAPIKey("AIzaSyD2hQFiuJNqB7OdgDLqhYREhimyhp32CIU")
    
        // 앱시작시 서버에 있는 데이터를 끌어서 저장하도록 지시

        CellData.shared.getDataFromServer()
        
//                self.window?.rootViewController = ViewController()   // 서버 죽음 임시
//                self.window?.makeKeyAndVisible()    //  서버 죽음 임시
        
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(application, open: url, options: options)
        
        return handled!
    }


}

