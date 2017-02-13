//
//  ManagerBGM.swift
//  Reasons
//
//  Created by Daniel Pan on 13/02/2017.
//  Copyright © 2017 geekmouse. All rights reserved.
//

import Foundation
import AVFoundation


let managerBGM = ManagerBGM()

class ManagerBGM {
    public var isPlaying = true {
        didSet{
            if isPlaying{
                player?.play()
            }
            else{
                player?.pause()
            }
        }
    }
    
    
    var player: AVAudioPlayer?
    
    init() {
        if let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3"){
            do{
                player = try AVAudioPlayer(contentsOf: url)
            }catch{
            
            }
            
        }
        
        
    }
    
}
