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
    
    let playableRect: CGRect
    
    var lastTouchLocation: CGPoint?
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playerMovePointsPerSec: CGFloat = 480.0
    
    var velocity = CGPoint.zero
    
    let player = SKSpriteNode(imageNamed: "player")
    let demon = SKSpriteNode(imageNamed: "demon")
    let zombie = SKSpriteNode(imageNamed: "zombie")
    
    
    override init(size: CGSize){
        let maxAspectRatio: CGFloat = 16.0/6.2
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        
        
        playableRect = CGRect(x: 0, y:playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view:SKView) {
        
        debugDrawPlayableArea()
        let backgroundSound = SKAudioNode(fileNamed: "Test.mp3")
        self.addChild(backgroundSound)
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x:size.width/2, y:size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        
        player.position = CGPoint(x: 10000, y: 1000)
        addChild(player)
        
        zombie.position = CGPoint(x:500, y :500)
        addChild(zombie)
        
        demon.position = CGPoint(x:900, y:600)
        addChild(demon)
        
        
    }
    
    
    func movePlayerToward (_ location: CGPoint){
        let offset = CGPoint(x: location.x - player.position.x, y: location.y - player.position.y)
        let length = sqrt(Double(offset.x*offset.x + offset.y*offset.y))
        let direction = CGPoint (x: offset.x/CGFloat(length), y: offset.y/CGFloat(length))
        
        velocity = CGPoint(x: direction.x*playerMovePointsPerSec, y: direction.y*playerMovePointsPerSec)
        
    }
    
    
    func moveSprite(_ sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x:velocity.x * CGFloat(dt),
                                   y:velocity.y * CGFloat(dt))
        print ("Amount to move: \(amountToMove)")
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                  y: sprite.position.y + amountToMove.y)
        
    }
    
    func boundsCheckPlayer(){
        let bottomLeft = CGPoint(x:playableRect.minX, y:playableRect.minY)
        let topRight = CGPoint(x:playableRect.maxX, y:playableRect.maxY)
        
        if player.position.x <= bottomLeft.x{
            player.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if player.position.x >= topRight.x{
            player.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if player.position.y <= bottomLeft.y{
            player.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if player.position.y >= topRight.y{
            player.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        movePlayerToward(touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        movePlayerToward(touchLocation)
    }
    
    
    override func update (_ currentTime: TimeInterval){
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update")
        
        
        // moveSprite(player, velocity: CGPoint(x:playerMovePointsPerSec, y:0))
        
        if let lastTouchLocation = lastTouchLocation {
            let diff = lastTouchLocation - player.position
            if (diff.length() <= playerMovePointsPerSec * CGFloat (dt)){
                player.position = lastTouchLocation
                velocity = CGPoint.zero
            } else{
                moveSprite(player, velocity: velocity)
                
                
            }
        }
        boundsCheckPlayer()
        
        
    }
    
    
    func debugDrawPlayableArea(){
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
        
    }
    
    
    
    
    
    
    
    
    
}
