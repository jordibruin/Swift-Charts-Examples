//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import AVFoundation

class MicrophoneMonitor: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    @Published public var sample: Float
    var onUpdate: (() -> Void) = {} {
        didSet {
            // This should only be run once,
            // i.e when the SoundBars chart is first loaded
            startMonitoring()
        }
    }

    init() {
        self.sample = .zero

        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { isGranted in
                if !isGranted {
                    return
                }
            }
        }

        let url = URL(fileURLWithPath: NSTemporaryDirectory().appending("tmp.caf"))
        let recorderSettings: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.record, mode: .measurement, options: [])
        } catch {
            print(error.localizedDescription)
        }
    }

    private var generatedTimer: Timer {

        // If there is a timer retained, do not create a new one
        if let timer = timer { return timer }
        
       return  Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            
            guard let self = self else { return }
            
            self.audioRecorder?.updateMeters()
            let averagePower = self.audioRecorder?.averagePower(forChannel: 0) ?? -100
            let minDecibels: Float = -80.0

            if averagePower < minDecibels {
                self.sample = 0
            } else if averagePower >= 0 {
                self.sample = 1
            } else {
                let minAmp = pow(10.0, minDecibels * 0.05)
                let inverse = 1.0/(1.0 - minAmp)
                let amp = pow(10.0, averagePower * 0.05)
                let adjAmp = (amp - minAmp) * inverse
                let level = powf(Float(adjAmp), 1.0 / 2.0) * 2

                self.sample = level
            }
            
            // A sanity check to stop the chart fromo scrolling if we're not recording
            if self.audioRecorder?.isRecording ?? false {
                self.onUpdate()
            }
        }
    }
    
    private func startMonitoring() {
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = generatedTimer
    }

    deinit {
        timer?.invalidate()
        audioRecorder?.stop()
    }
    
    // MARK: - External methods
    
    func stopMonitoring() {
        guard
            let recorder = audioRecorder,
            recorder.isRecording
        else { return }
        
        timer?.invalidate()
        recorder.stop()
        timer = nil
    }
    
    func resumeMonitoring() {
        guard
            let recorder = audioRecorder,
            !recorder.isRecording
        else { return }
        
        recorder.record()
        timer = generatedTimer
    }
    
    func toggle() {
        guard
            let recorder = audioRecorder else { return }
        
        if recorder.isRecording {
            stopMonitoring()
        } else {
            resumeMonitoring()
        }
    }
    
}
