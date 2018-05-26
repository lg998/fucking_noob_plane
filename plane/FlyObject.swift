//
//  FlyObject.swift
//  plane
//
//  Created by lg_jhkd on 2018/5/21.
//  Copyright © 2018年 lg_jhkd. All rights reserved.
//

import Foundation
import GameplayKit

enum bonusType: Int{
    case doubleShoot
}


class Bullet: SKSpriteNode{
    var damage = 10
}

class Bonus: SKSpriteNode{
    var type = bonusType.doubleShoot
}

class Flyobject: SKSpriteNode{
    var hp = 100
    var invincible = false
    var norTexture = SKTexture(imageNamed: "")
    var injuredTexture = SKTexture(imageNamed: "")
    var deadTextures = [SKTexture()]
    
    
    public func isAlive()->Bool{
        print (hp)
        return hp>0
    }
    

    
}

class Hero: Flyobject{
    var shootCount = 1
    var damage = 100
    
    public func getDamage(damage: Int)->Bool{
        if invincible == false{
            hp-=damage
            if isAlive()==false{
                return false
            }
            self.invincible = true
            self.texture = injuredTexture
            let wait = SKAction.wait(forDuration: 0.3)
            let setNotInvincibleAction = SKAction.run{
                self.invincible=false
                self.texture = self.norTexture
            }
            let sequenceAction = SKAction.sequence([wait, setNotInvincibleAction])
            self.run(sequenceAction)
            
        }
        return true
    }
}

class Enemy: Flyobject{
    var damage = 10
    var type = "normal"
    var score = 100
    public func getDamage(damage: Int)->Bool{
        hp-=damage
        if isAlive()==false{
            return false
        }
        self.texture = injuredTexture
        let wait = SKAction.wait(forDuration: 0.1)
        let setAction = SKAction.run{
            self.texture = self.norTexture
        }
        let sequenceAction = SKAction.sequence([wait, setAction])
        self.run(sequenceAction)
        return true
    }
}
