//
//  SoundController.swift
//  plane
//
//  Created by lg_jhkd on 2018/5/26.
//  Copyright © 2018年 lg_jhkd. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import GameplayKit

class SoundController{
    var bgMusicPlayer = AVAudioPlayer()
    
    func playBackGroundMusic(){
        let bgMusicUrl = Bundle.main.url(forResource: "game_music", withExtension: "mp3")!
        try! bgMusicPlayer = AVAudioPlayer (contentsOf: bgMusicUrl)
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.volume = 0.5
        bgMusicPlayer.prepareToPlay()
        bgMusicPlayer.play()
    }
    
    var shootSoundAction = SKAction.playSoundFileNamed("bullet", waitForCompletion: false)
    let bonusSoundAction = SKAction.playSoundFileNamed("get_double_laser.mp3", waitForCompletion: false)
    let blowupNormalAction = SKAction.playSoundFileNamed("enemy0_down.mp3", waitForCompletion: false)
    let blowupMediumAction = SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false)
    let gameOverAction = SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: false)
    

}
