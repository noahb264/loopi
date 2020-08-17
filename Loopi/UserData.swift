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
    
    @Published var isPlaying = false
    @Published var sliderValue = 5.0
    var audioController = AudioController.shared
    
    init() {
        audioController.schedulePeriodicUpdates() { currentTime, duration in
            self.sliderValue = (currentTime.seconds / duration.seconds) * 100
        }
        
        audioController.scheduleBoundaryUpdate()
    }
    
    func seek() {
        audioController.seekTo(time: sliderValue)
    }
    
}
