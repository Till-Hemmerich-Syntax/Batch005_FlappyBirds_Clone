//
//  GameScene.swift
//  Batch005_FlappyBirds_Clone
//
//  Created by Till Hemmerich on 08.08.23.
//

import Foundation
import SpriteKit

class SimpleGameScene : SKScene{
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        addBox(location: touch.location(in: self),size : 50)
    }
    
    func createTextNode(_ text : String, location : CGPoint){
        let node = SKLabelNode(text: text)
        node.position = location
        addChild(node)
    }
    
    func addBox(location : CGPoint,size : Int){
        let box = SKSpriteNode(color: .red, size: CGSize(width: size, height: size))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size, height: size))
        addChild(box)
    }
    
}
