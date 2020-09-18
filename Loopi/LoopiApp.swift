//
//  LoopiApp.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import SwiftUI

@main
struct LoopiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SongsListView().environmentObject(UserData())
        }
    }
}
