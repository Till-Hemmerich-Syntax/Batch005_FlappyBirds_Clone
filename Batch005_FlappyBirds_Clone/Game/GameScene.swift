//
//  GameScene.swift
//  Batch005_FlappyBirds_Clone
//
//  Created by Till Hemmerich on 08.08.23.
//

import Foundation

import SpriteKit

enum GameState{
    case showLogo
    case playing
    case dead
}


class GameScene : SKScene, SKPhysicsContactDelegate{
    
        
    var player : SKSpriteNode!
    var gameState = GameState.showLogo
    var logoNode : SKLabelNode!
    var scoreNode : SKLabelNode!
    var fpsNode : SKLabelNode!
    
    var fps = 0.0{
        didSet{
            fpsNode.text = "FPS : \(fps)"
        }
    }
    var score = 0{
        didSet{
            scoreNode.text = "SCORE : \(score)"
        }
    }
    

    override func didMove(to view: SKView) {
        
        view.showsFPS = true
        
        createPlayer()
        createBackground()
        logoNode = createTextNode("Start Game", location: CGPoint(x: frame.midX, y: frame.midY))
        scoreNode = createTextNode("SCORE : \(score)", location: CGPoint(x: frame.midX, y: frame.maxY - 30))
        scoreNode.zPosition = 10
        
        
        addChild(logoNode)
        addChild(scoreNode)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    
        
        
        switch gameState {
            
        case .showLogo:
            gameState = .playing
            let activatePlayer = SKAction.run {
                self.player.physicsBody?.isDynamic = true
                self.startPipeLogic()
            }
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let sequence = SKAction.sequence([fadeOut,wait,activatePlayer,remove])
            logoNode.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            
            
        case .dead:
            let scene = GameScene()
            scene.size = CGSize(width: 300, height: 400)
            scene.scaleMode = .fill
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
            self.view?.presentScene(scene,transition: transition)
            
        }
        
        
        
    }
    
    
    
    func createPlayer(){
        let frame1 = SKTexture(imageNamed: "bluebird-upflap")
        let frame2 = SKTexture(imageNamed: "bluebird-midflap")
        let frame3 = SKTexture(imageNamed: "bluebird-downflap")
        player = SKSpriteNode(texture: frame1)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width/6, y: frame.height * 0.75)
        
        addChild(player)
        
      
        let animation = SKAction.animate(with: [frame1,frame2,frame3], timePerFrame: 0.1)
        player.run(SKAction.repeatForever(animation))
        
        player.physicsBody = SKPhysicsBody(texture: frame1, size: frame1.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        
        
    }
    
    func startPipeLogic(){
        let create = SKAction.run {
            self.createPipe()
        }
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeateForever = SKAction.repeatForever(sequence)
        
        run(repeateForever)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
        
        if contact.bodyA.node?.name == "Coin" || contact.bodyB.node?.name == "Coin"{
            
            if(contact.bodyA.node?.name == "Coin"){
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
            score += 1
            print("COIN COLLECTED")
            
            return
        }
        
        if contact.bodyA.node == player || contact.bodyB.node == player{
            
            player.removeFromParent()
            gameState = .dead
            let gameOverNode = createTextNode("GAME OVER", location: CGPoint(x: frame.midX, y: frame.midY))
            addChild(gameOverNode)
        }
        
    }
    
    func createPipe(){
        
       
        
        let pipeTexture = SKTexture(imageNamed: "pipe-green")
        
        let topPipe = SKSpriteNode(texture: pipeTexture)
        topPipe.zRotation = .pi
        topPipe.xScale = -1.0
        
        let xPosition = frame.width + topPipe.frame.width
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        let pipeDistance: CGFloat = 70

        
        let bottomPipe = SKSpriteNode(texture: pipeTexture)
        
        topPipe.position = CGPoint(x: xPosition, y: yPosition + topPipe.size.height + pipeDistance)
        bottomPipe.position = CGPoint(x: xPosition, y: yPosition - pipeDistance)
        
        let coinNode = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        coinNode.name = "Coin"
     
        
        coinNode.position = CGPoint(x: xPosition, y: yPosition + (coinNode.size.height/2) + (pipeDistance*2) )
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.isDynamic = false
        
        addChild(coinNode)
        addChild(topPipe)
        addChild(bottomPipe)
        
        
  
        
        
        
        let endPosition = frame.width + (topPipe.frame.width * 2 )
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 5)
        let moveSequence = SKAction.sequence([moveAction,SKAction.removeFromParent()])
        
        
        topPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: pipeTexture.size())
        bottomPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: pipeTexture.size())
        topPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.isDynamic = false
        
        
        
        topPipe.run(moveSequence)
        bottomPipe.run(moveSequence)
        coinNode.run(moveSequence)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("Update")
        
        guard player != nil else {return}
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        
        player.run(rotate)
        
        
        
    }
    
 
    
    
    func createBackground(){
        
        let backgroundTexture = SKTexture(imageNamed: "background-day")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(i * 1), y: 0)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft,moveReset])
            background.run(SKAction.repeatForever(moveLoop))
            
        }
        
        
    }
    
    func createTextNode(_ text : String, location : CGPoint) -> SKLabelNode{
         let node  = SKLabelNode(text: text)
         node.position = location
         node.fontColor = .black
         return node
    }
    
    func addBox(location : CGPoint,size : Int){
        let box = SKSpriteNode(color: .red, size: CGSize(width: size, height: size))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        addChild(box)
    }
    
   
    
}
