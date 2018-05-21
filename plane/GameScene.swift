//
//  GameScene.swift
//  plane
//
//  Created by lg_jhkd on 2018/5/21.
//  Copyright © 2018年 lg_jhkd. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    private var hero=SKSpriteNode.init(imageNamed: "hero1")
    private var bullets = [SKSpriteNode]()

    override func didMove(to view: SKView) {
        setupBackground()
        setupPlayer()
    }
    
    func setupBackground(){
        let bgNode = SKSpriteNode.init(imageNamed: "background")
        bgNode.position = .zero
        bgNode.zPosition = 0
        bgNode.anchorPoint = .zero
        bgNode.size = size
        bgNode.zPosition = 0
        addChild(bgNode)
    }
    
    func setupPlayer(){
        hero.position = .init(x: size.width/2, y: hero.size.height/2)
        hero.size = CGSize(width: hero.size.width/2, height: hero.size.height/2)
        hero.zPosition = 1
        addChild(hero)
        

    }
    
    func startShoot(){
        let shootAction = SKAction.run {
            self.shoot()
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let repeatShootAction = SKAction.repeatForever(sequenceAction)
        run(repeatShootAction, withKey:"repeatShootAction")
    }
    
    func shoot(){
        let bullet = SKSpriteNode.init(imageNamed: "bullet")
        bullet.position = CGPoint(x: hero.position.x, y: hero.position.y+hero.size.height/2)
        bullet.zPosition = 1
        bullet.size = CGSize(width: hero.size.width/3, height: hero.size.height/3)
        addChild(bullet)
        bullets.append(bullet)
        let moveAction = SKAction.moveTo(y: size.height, duration: TimeInterval((size.height-bullet.position.y)/100))
        let deleteAction = SKAction.run{
            self.removeBullet(bullet: bullet)
        }
        let sequenceAction = SKAction.sequence([moveAction, deleteAction])
        bullet.run(sequenceAction)
    }
    
    func removeBullet(bullet:SKSpriteNode){
        bullet.removeFromParent()
        let index = self.bullets.index(of: bullet)
        if index != nil {
            self.bullets.remove(at: index!)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        hero.position = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.startShoot()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAction(forKey: "repeatShootAction")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
