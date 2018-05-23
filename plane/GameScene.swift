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
    
    private var hero=Hero.init(imageNamed: "hero1")
    private var bullets = [Bullet]()
    private var enemys = [Enemy]()
    private var bonuses = [Bonus]()
    private var enemyBullets = [Bullet]()

    override func didMove(to view: SKView) {
        setupBackground()
        setupPlayer()
        startSetupEnemys()
        startSetupBonus()
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
        hero.norTexture = SKTexture(imageNamed: "hero1")
        hero.injuredTexture = SKTexture(imageNamed: "hero_blowup_n1")
        hero.position = .init(x: size.width/2, y: hero.size.height/2)
        print (hero.position)
        hero.size = CGSize(width: hero.size.width/2, height: hero.size.height/2)
        hero.zPosition = 1
        addChild(hero)
    
    }
    
    func startSetupBonus(){
        let setupBonusAction = SKAction.run{
            self.setupBonus(type: bonusType.doubleShoot)
        }
        let wait = SKAction.wait(forDuration: 20)
        let sequenceAction = SKAction.sequence([setupBonusAction,wait])
        let repeatSetupAction = SKAction.repeatForever(sequenceAction)
        run(repeatSetupAction, withKey:"repeatSetupBonusAction")
    }
    
    func setupBonus(type: bonusType){
        let bonus = Bonus.init(imageNamed: "prop_type_0")
        bonus.position = CGPoint(x:CGFloat(drand48())*size.width, y:size.height)
        bonus.zPosition = 1.5
        bonus.type=type
        addChild(bonus)
        bonuses.append(bonus)
        let moveAction = SKAction.moveTo(y: -size.height, duration: 20)
        let deleteAction = SKAction.run{
            self.removeBonus(bonus:bonus)
        }
        let sequenceAction = SKAction.sequence([moveAction, deleteAction])
        bonus.run(sequenceAction)
    }
    
    func removeBonus(bonus:Bonus){
        bonus.removeFromParent()
        let index = self.bonuses.index(of: bonus)
        if index != nil {
            self.bonuses.remove(at: index!)
        }
    }
    
    func startSetupEnemys(){
        let setupEnemyAction = SKAction.run{
            let randomInt = arc4random()%100
            if randomInt<20 && randomInt>4{
                self.setupEnemy(type: "medium")
            }
            if randomInt>20{
                self.setupEnemy(type: "normal")
            }
        }
        let wait = SKAction.wait(forDuration: 0.7)
        let sequenceAction = SKAction.sequence([setupEnemyAction,wait])
        let repeatSetupAction = SKAction.repeatForever(sequenceAction)
        run(repeatSetupAction, withKey:"repeatSetupEnemyAction")
    }
    
    func setupEnemy(type: String){
        switch type{
            case "normal":
                let enemy = Enemy.init(imageNamed: "enemy0")
                enemy.norTexture = SKTexture(imageNamed: "enemy0")
                enemy.injuredTexture = SKTexture(imageNamed: "enemy0_down1")
                let deadTextures = [SKTexture(imageNamed: "enemy0_down1"),
                                    SKTexture(imageNamed: "enemy0_down2"),
                                    SKTexture(imageNamed: "enemy0_down3"),
                                    SKTexture(imageNamed: "enemy0_down4")]
                enemy.deadTextures = deadTextures
                enemy.position = CGPoint(x:CGFloat(drand48())*(size.width-enemy.size.width)+enemy.size.width/2, y:size.height)
                enemy.zPosition = 1.1
                addChild(enemy)
                enemys.append(enemy)
                let moveAction = SKAction.moveTo(y: -10, duration: 10)
                let deleteAction = SKAction.run{
                    self.removeEnemy(enemy: enemy)
                }
                let sequenceAction = SKAction.sequence([moveAction, deleteAction])
                enemy.run(sequenceAction)
                return
            case "medium":
                let enemy = Enemy.init(imageNamed: "enemy1")
                enemy.norTexture = SKTexture(imageNamed: "enemy1")
                enemy.injuredTexture = SKTexture(imageNamed: "enemy1_down1")
                let deadTextures = [SKTexture(imageNamed: "enemy1_down1"),
                                    SKTexture(imageNamed: "enemy1_down2"),
                                    SKTexture(imageNamed: "enemy1_down3"),
                                    SKTexture(imageNamed: "enemy1_down4")]
                enemy.deadTextures = deadTextures
                enemy.position = CGPoint(x:CGFloat(drand48())*(size.width-enemy.size.width)+enemy.size.width/2, y:size.height)
                enemy.zPosition = 1.05
                enemy.hp = 300
                addChild(enemy)
                enemys.append(enemy)
                let moveAction = SKAction.moveTo(y: -10, duration: 10)
                let shootAction = SKAction.run{
                    self.startEnemyShoot(enemy: enemy, damage: 30, imageNamed: "bullet2")
                }
                
                let sequenceAction = SKAction.sequence([moveAction, shootAction])
                enemy.run(sequenceAction)
                return
            default: return
        }
    
    }
    
    func startEnemyShoot(enemy: Enemy, damage:Int, imageNamed: String){
        let shootAction = SKAction.run {
            self.enemyShoot(enemy: enemy, damage: damage, imageNamed: imageNamed)
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let onceShootAction = SKAction.sequence([SKAction.repeat(sequenceAction, count:5), SKAction.wait(forDuration: 1.5)])
        let repeatShootAction = SKAction.repeatForever(onceShootAction)
        enemy.run(repeatShootAction)
    }
    
    func enemyShoot(enemy: Enemy, damage:Int, imageNamed: String){
        let bullet = Bullet.init(imageNamed: imageNamed)
        bullet.zPosition = 0.9
        bullet.size = CGSize(width: bullet.size.width/1.5, height: bullet.size.height/1.5)
        bullet.damage = damage
        bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
        addChild(bullet)
        enemyBullets.append(bullet)
        let moveAction = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y),duration: TimeInterval(sqrt((pow(bullet.position.x-hero.position.x, 2)+pow(bullet.position.y-hero.position.y, 2)))/200))
        let deleteAction = SKAction.run{
            self.removeEnemyBullet(enemyBullet: bullet)
        }
        let sequenceAction = SKAction.sequence([moveAction, deleteAction])
        bullet.run(sequenceAction)
    }
    
    func removeEnemyBullet(enemyBullet: Bullet){
        enemyBullet.removeFromParent()
        let index = enemyBullets.index(of: enemyBullet)
        if index != nil {
            enemyBullets.remove(at: index!)
        }
    }
    
    func removeEnemy(enemy: Enemy){
        enemy.removeFromParent()
        let index = enemys.index(of: enemy)
        if index != nil {
            enemys.remove(at: index!)
        }
    }
    
    func startShoot(){
        let shootAction = SKAction.run {
            self.Shoot(count: self.hero.shootCount)
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let repeatShootAction = SKAction.repeatForever(sequenceAction)
        run(repeatShootAction, withKey:"repeatShootAction")
    }
    
    func Shoot(count: Int){
        for i in 1...count{
            let bullet = Bullet.init(imageNamed: "bullet")
            bullet.zPosition = 1
            bullet.size = CGSize(width: bullet.size.width/1.5, height: bullet.size.height/1.5)
            bullet.damage = 30
            if count%2==0{
                if i<=count/2{
                    bullet.position = CGPoint(x: hero.position.x-hero.size.width/4*CGFloat(i), y: hero.position.y+hero.size.height/2)
                }
                else{
                    bullet.position = CGPoint(x: hero.position.x+hero.size.width/4*CGFloat(count-i+1), y: hero.position.y+hero.size.height/2)
                }    
            }
            else{
                if i<=count/2{
                    bullet.position = CGPoint(x: hero.position.x-hero.size.width/4*CGFloat(i), y: hero.position.y+hero.size.height/2)
                }
                else if i==count/2+1{
                    bullet.position = CGPoint(x: hero.position.x, y: hero.position.y+hero.size.height/2)
                }
                else if i>count/2+1{
                    bullet.position = CGPoint(x: hero.position.x+hero.size.width/4*CGFloat(count-i+1), y: hero.position.y+hero.size.height/2)
                }
            }
            addChild(bullet)
            bullets.append(bullet)
            let moveAction = SKAction.moveTo(y: size.height, duration: TimeInterval((size.height-bullet.position.y)/200))
            let deleteAction = SKAction.run{            self.removeBullet(bullet: bullet)
            }
            let sequenceAction = SKAction.sequence([moveAction, deleteAction])
            bullet.run(sequenceAction)
        }
        
    }
    

    
    func removeBullet(bullet:Bullet){
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
        for bonus in bonuses{
            if bonus.frame.intersects(hero.frame){
                getBonus(type: bonus.type)
                removeBonus(bonus: bonus)
            }
            
        }
        
        for enemy in enemys{
            for bullet in bullets{
                if enemy.frame.intersects(bullet.frame){
                    self.removeBullet(bullet: bullet)
                    if enemy.getDamage(damage: bullet.damage)==false{
                        blowupEnemy(enemy: enemy)
                    }
                }
            }
            if enemy.frame.intersects(hero.frame){
                if hero.getDamage(damage: enemy.damage)==false{
                    print ("game over")
                }
                if enemy.getDamage(damage: hero.damage)==false{
                    blowupEnemy(enemy: enemy)
                }
            }
        }
        
        for enemyBullet in enemyBullets{
            if enemyBullet.frame.intersects(hero.frame){
                if hero.getDamage(damage: enemyBullet.damage)==false{
                    print ("game over")
                }
                removeEnemyBullet(enemyBullet: enemyBullet)
            }
        }
        
    }
    
    func getBonus(type: bonusType){
        switch type{
            case .doubleShoot:
                hero.shootCount += 1
                return
        }
    }
    
    func blowupEnemy(enemy: Enemy){
        let index = self.enemys.index(of: enemy)
        if index != nil {
            self.enemys.remove(at: index!)
        }
        let blowupAction = SKAction.animate(with: enemy.deadTextures, timePerFrame: 0.1, resize: false, restore: false)
        let deleteAction = SKAction.run{
            enemy.removeFromParent()
        }
        let sequenceAction = SKAction.sequence([blowupAction, deleteAction])
        enemy.removeAllActions()
        enemy.run(sequenceAction)
    }
    
}
