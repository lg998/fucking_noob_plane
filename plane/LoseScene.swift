//
//  LoseScene.swift
//  plane
//
//  Created by lg_jhkd on 2018/5/26.
//  Copyright © 2018年 lg_jhkd. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class LoseScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
    }
    
    func setupBackground(){
        let bgNode = SKSpriteNode.init(imageNamed: "gameover")
        bgNode.position = .zero
        bgNode.zPosition = 0
        bgNode.anchorPoint = .zero
        bgNode.size = size
        bgNode.zPosition = 0
        addChild(bgNode)
    }
}
