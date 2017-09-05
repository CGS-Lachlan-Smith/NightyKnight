//
//  GameScene.swift
//  NightyKnight
//
//  Created by Lachlan Smith on 14/8/17.
//  Copyright © 2017 Lachlan Smith. All rights reserved.
//
//master

import SpriteKit
import GameplayKit

class GameScene: SKScene {


    
    let player = SKSpriteNode(imageNamed: "Player")
    
    override func didMove(to view:SKView) {
        setupBackground()
        let backgroundSound = SKAudioNode(fileNamed: "Test.mp3")
        self.addChild(backgroundSound)
    }
    
    
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x:size.width/2, y:size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        
    }
    
    
    func setupForeground() {
        
    }
    
}
