//
//  SoundEngine.swift
//  Docsink
//
//  Created by Amit Kumar Shukla on 3/17/17.
//  Copyright (c) 2017 Docsink. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox
import AudioToolbox.AudioServices

class SoundEngine: NSObject {
    
    //properties and methods
    static let sharedEngine = SoundEngine()
    
    var player:AVAudioPlayer?
    
    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
        
        }
    }
    
    func play(_ path:URL?) {
        self.stop()
        do {
            self.player = try AVAudioPlayer(contentsOf: path!)
            self.player!.volume = 1.0
            self.player!.numberOfLoops = 0
            self.player!.prepareToPlay()
            self.player!.play()
        } catch {
            
        }
    }
    
    func stop() {
        if self.player != nil {
            if self.player!.isPlaying {
                self.player!.stop()
            }
            self.player = nil
        }
    }
    
    func playSound(for filename: String, with system:Bool = true) {
        
        let pathExtention = (filename as NSString).pathExtension
        let pathPrefix = (filename as NSString).deletingPathExtension
       
        let mySoundEffectPath = Bundle.main.path(forResource: pathPrefix, ofType: pathExtention)
        let mySoundEffectUrl = URL(fileURLWithPath: mySoundEffectPath!)
        
        if system {
           
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(mySoundEffectUrl as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
            
        } else {
            // Play custom sounds
            self.play(mySoundEffectUrl)
            // Vibrate phone
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

}
