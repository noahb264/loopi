//
//  AppDelegate.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/20/20.
//

import Foundation
import AVFoundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            print("Done!")
            if let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                print(iCloudDocumentsURL.path)
                
                let files = try FileManager.default.contentsOfDirectory(atPath: iCloudDocumentsURL.path)
                print(files)
                
                if (!FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil)) {
                    print("Done!")
                    try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                    print("Done!")
                } else {
                    print("Hello")
                    
                    let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last! as NSURL
                    print(localDocumentsURL.path!)
                    
                    
                    // TODO: Fix this :P
                    AudioController.shared.songs = files.map({(file: String) -> Song in
                        return Song(id: Int.random(in: 0..<1000), title: file, artist: "Noah Burkhardt")
                    })
                    

                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            } catch let error as NSError {
                print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
            }
        
        return true
    }
}
