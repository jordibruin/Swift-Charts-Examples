//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Foundation
import AVFoundation

class MicrophoneMonitor: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    @Published public var sample: Float
    var onUpdate: (() -> Void) = {}

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
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            startMonitoring()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func startMonitoring() {
        guard let audioRecorder = audioRecorder else { return }
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
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
            self.onUpdate()
        }
    }

    deinit {
        timer?.invalidate()
        audioRecorder?.stop()
    }
}
