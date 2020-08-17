//
//  AudioController.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/16/20.
//

import AVFoundation

class AudioController {
    
    private var player: AVPlayer?
    private var sampleRate: Int32?
    
    func toggle() {
        if isPlaying() {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seekTo(time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func isPlaying() -> Bool {
        return player!.timeControlStatus == .playing
    }
    
    func schedulePeriodicUpdates(completion: @escaping (CMTime, CMTime) -> ()) {
        player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { _ in
            completion(self.player!.currentTime(), self.player!.currentItem!.duration)
        }
    }
    
    func scheduleBoundaryUpdate() {
        let LOOP_START = 2588892.0 / Double(sampleRate!)
        let LOOP_END = 6650000.0 / Double(sampleRate!)
        
        print(LOOP_START)
        print(LOOP_END)
        
        let times = [NSValue(time: CMTime(seconds: LOOP_END, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))]
        player!.addBoundaryTimeObserver(forTimes: times, queue: DispatchQueue.main, using: {
            self.player?.seek(to: CMTime(seconds: LOOP_START, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        })
    }
    
    static let shared: AudioController = {
        let instance = AudioController()
        
        let url = Bundle.main.url(forResource: "better_ganondorf", withExtension: "wav")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            let p = AVPlayer(url: url!)
            instance.sampleRate = p.currentItem?.asset.tracks[0].naturalTimeScale

            instance.player = p


        } catch let error {
            print(error.localizedDescription)
        }
        
        return instance
    }()
    
}
