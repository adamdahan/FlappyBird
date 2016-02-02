//
//  GameScene.swift
//  FlappyBrid
//
//  Created by Daniel on 2/2/16.
//  Copyright (c) 2016 XcodeYang. All rights reserved.
//

import SpriteKit

struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Line : UInt32 = 0x1 << 4
}


class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    
    var wallPair = SKNode()

    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    override func didMoveToView(view: SKView) {
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width/2, y: ground.frame.height/2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.affectedByGravity = false
        
        ground.zPosition = 3
        
        self.addChild(ground)
        
        
        
        ghost = SKSpriteNode(imageNamed: "ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width/2 - ghost.frame.width, y: self.frame.height/2)
        
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height/2)
        ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        ghost.physicsBody?.dynamic = true
        ghost.physicsBody?.affectedByGravity = false
        
        ghost.zPosition = 2
        
        self.addChild(ghost)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameStarted == false {
            
            gameStarted = true
            
            ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                self.creatWalls()
            })
            
            let delay = SKAction.waitForDuration(2.0)
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))

        } else {
            ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        }
        
    }
    
    
    func creatWalls() {
        
        wallPair = SKNode()
        
        let topwall = SKSpriteNode(imageNamed: "wall")
        let btmwall = SKSpriteNode(imageNamed: "wall")
        
        topwall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 + 350)
        btmwall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 - 350)
        
        topwall.setScale(0.5)
        btmwall.setScale(0.5)
        
        topwall.physicsBody = SKPhysicsBody(rectangleOfSize: topwall.size)
        topwall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topwall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topwall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topwall.physicsBody?.dynamic = false
        topwall.physicsBody?.affectedByGravity = false
        
        btmwall.physicsBody = SKPhysicsBody(rectangleOfSize: btmwall.size)
        btmwall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmwall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmwall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmwall.physicsBody?.dynamic = false
        btmwall.physicsBody?.affectedByGravity = false
        
        
        topwall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topwall)
        wallPair.addChild(btmwall)
        
        wallPair.zPosition = 1
        wallPair.runAction(moveAndRemove)

        self.addChild(wallPair)
    }
    
    
    override func update(currentTime: CFTimeInterval) {
    }
}
