//
//  LSAudioManager.swift
//  CloudEnjoy
//
//  Created by liubitao on 2023/5/3.
//

import Foundation
import AVFAudio

public final class LSAudioOperation: NSObject {
    var audioName: String = ""
    var isCanceled = false
    var isFinished = false
    var didCallCompletion = false
    var completion: ((LSAudioOperation) -> Void)!
    var audioPlayer: AVAudioPlayer!
    
    init(audioName: String) {
        self.audioName = audioName
    }
    
    func run(_ completion: @escaping (LSAudioOperation) -> Void) {
        self.completion = completion
        
        if isCanceled {
            self.finish()
            return
        }

        guard  let urlString = Bundle.main.path(forResource: self.audioName, ofType: "mp3") else {
            self.finish()
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: urlString))
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }catch {
            completion(self)
        }
    }
    
    func finish() {
        if !didCallCompletion {
            didCallCompletion = true
            completion(self)
        }
    }
}

extension LSAudioOperation: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.finish()
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}

// MARK: - QueueManager

public final class LSAudioQueueManager {
    public static let shared = LSAudioQueueManager()
    private var pendingRequests = [LSAudioOperation]()
    public var currentRequest: LSAudioOperation? = nil
    
    let lock: NSLock = NSLock()

    func killAllOperations() {
        pendingRequests.forEach { $0.isCanceled = true }
        currentRequest = nil
        pendingRequests = [LSAudioOperation]()
    }

    func enqueueToQueue(_ operation: LSAudioOperation) {
        lock.lock()
        pendingRequests.append(operation)
        runNextRequestIfNeeded()
        lock.unlock()
    }
}

private extension LSAudioQueueManager {

    func runNextRequestIfNeeded() {
        removeCanceledAndFinishedRequests()
        guard currentRequest == nil, let requestToRun = pendingRequests.first else {
            return
        }

        currentRequest = requestToRun
        pendingRequests.removeFirst()
        currentRequest!.run { (fetchRequestOperation) in
            self.currentRequest = nil
            self.runNextRequestIfNeeded()
        }
    }

    func removeCanceledAndFinishedRequests() {
        pendingRequests = pendingRequests.filter{ !$0.isCanceled && !$0.isFinished }
    }
}

