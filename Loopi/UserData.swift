//
//  UserData.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/13/20.
//

import Foundation
import SwiftUI
import Combine

final class UserData: ObservableObject {
    
    @Published var sliderValue = 0.0
    var audioController = AudioController.shared
    
    init() {
        audioController.schedulePeriodicUpdates() { currentTime, duration in
            self.sliderValue = (currentTime.seconds / duration.seconds) * 100
        }
        
        seek()
    }
    
    func seek() {
        audioController.seekTo(time: sliderValue)
    }
    
    func prepare(song: Song) {
        if let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            audioController.prepareToPlay(file: iCloudDocumentsURL.appendingPathComponent(song.title), song: song)
        } else {
            print("Bad!")
        }
    }
    
}
