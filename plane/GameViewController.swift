//
//  GameViewController.swift
//  plane
//
//  Created by lg_jhkd on 2018/5/21.
//  Copyright © 2018年 lg_jhkd. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if view.scene == nil{
                let aspectRatio = view.bounds.size.height / view.bounds.size.width
                
                let scene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
                
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsPhysics = true
                view.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
