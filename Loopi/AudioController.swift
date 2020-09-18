//
//  AudioController.swift
//  Loopi
//
//  Created by Noah Burkhardt on 8/16/20.
//

import AVFoundation
import MediaPlayer


class AudioController {
    
    private var playerLooper: AVPlayerLooper?
    private var player: AVQueuePlayer?
    private var rainPlayerLooper: AVPlayerLooper?
    private var rainPlayer: AVQueuePlayer?
    private var isStarted = false
    public var songs: [Song] = []
    
    func toggle() {
        if isPlaying() {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        if !isStarted {
            isStarted = true
            player?.seek(to: CMTime.zero)
        }
        
        player?.volume = 1
        player?.play()
    }
    
    func pause() {
        let _ = player?.fadeVolume(from: 1, to: 0, duration: 0.5, completion: {
            self.player?.pause()
        })
    }
    
    func toggleRain() {
        if rainPlayer!.timeControlStatus == .playing {
            stopRain()
        } else {
            startRain()
        }
    }
    
    func startRain() {
        rainPlayer?.play()
    }
    
    func stopRain() {
        rainPlayer?.pause()
    }
    
    func seekTo(time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func isPlaying() -> Bool {
        return player!.timeControlStatus == .playing
    }
    
    func isRaining() -> Bool {
        return rainPlayer!.timeControlStatus == .playing
    }
    
    func schedulePeriodicUpdates(completion: @escaping (CMTime, CMTime) -> ()) {
        player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { _ in
            completion(self.player!.currentTime(), self.player!.currentItem!.duration)
        }
    }
    
    func updateNowPlaying(title: String, artist: String) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = artist

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
            print("Play command - is playing: \(isPlaying())")
            if !isPlaying() {
                play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
            print("Pause command - is playing: \(isPlaying())")
            if isPlaying() {
                pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            print("Seeking to 0.0")
            seekTo(time: 0.0)
            return .success
        }
    }
    
    func prepareToPlay(file: URL, song: Song) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            let item = AVPlayerItem(url: file)
            self.isStarted = false
            self.player?.removeAllItems()
            self.player?.insert(item, after: nil)
            
            var start: Int?
            var end: Int?

            for entry in item.asset.metadata {
                if let entraAttributes = entry.extraAttributes {
                    for extra in entraAttributes {
                        print(extra.value)
                        if extra.value as! String == "loop_start" {
                            start = Int(entry.value! as! String)

                        } else if extra.value as! String == "loop_end" {
                            end = Int(entry.value! as! String)

                        }

                    }
                }
            }
            
            let sampleRate = self.player?.currentItem?.asset.tracks[0].naturalTimeScale

            let startTime = CMTime(seconds: Double(start!) / Double(sampleRate!), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let endTime = CMTime(seconds: Double(end!) / Double(sampleRate!), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self.playerLooper = AVPlayerLooper(player: self.player!, templateItem: item, timeRange: CMTimeRange(start: startTime, end: endTime))
            
            updateNowPlaying(title: song.title, artist: song.artist)
            setupRemoteTransportControls()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static let shared: AudioController = {
        let instance = AudioController()
        
        instance.player = AVQueuePlayer()
        
        let item = AVPlayerItem(url: Bundle.main.url(forResource: "rain", withExtension: ".aiff")!)
        instance.rainPlayer = AVQueuePlayer(playerItem: item)
        
        instance.rainPlayerLooper = AVPlayerLooper(player: instance.rainPlayer!, templateItem: item)
            

        
        return instance
    }()
    
}

extension AVPlayer {
    /// Fades player volume FROM any volume TO any volume
    /// - Parameters:
    ///   - from: initial volume
    ///   - to: target volume
    ///   - duration: duration in seconds for the fade
    ///   - completion: callback indicating completion
    /// - Returns: Timer?
    func fadeVolume(from: Float, to: Float, duration: Float, completion: (() -> Void)? = nil) -> Timer? {
        // 1. Set Initial volume
        volume = from
        
        // 2. There's no point in continuing if target volume is the same as initial
        guard from != to else { return nil }
        
        // 3. We define the time interval the interaction will loop into (fraction of a second)
        let interval: Float = 0.1
        // 4. Set the range the volume will move
        let range = to-from
        // 5. Based on the range, the interval and duration, we calculate how big is the step we need to take in order to reach the target in the given duration
        let step = (range*interval)/duration
        
        // internal function whether the target has been reached or not
        func reachedTarget() -> Bool {
            // volume passed max/min
            guard volume >= 0, volume <= 1 else {
                volume = to
                return true
            }
            
            // checks whether the volume is going forward or backward and compare current volume to target
            if to > from {
                return volume >= to
            }
            return volume <= to
        }
        
        // 6. We create a timer that will repeat itself with the given interval
        return Timer.scheduledTimer(withTimeInterval: Double(interval), repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // 7. Check if we reached the target, otherwise we add the volume
                if !reachedTarget() {
                    // note that if the step is negative, meaning that the to value is lower than the from value, the volume will be decreased instead
                    self.volume += step
                } else {
                    timer.invalidate()
                    completion?()
                }
            }
        })
    }
}
