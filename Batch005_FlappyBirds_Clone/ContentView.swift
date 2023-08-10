//
//  ContentView.swift
//  Batch005_FlappyBirds_Clone
//
//  Created by Till Hemmerich on 08.08.23.
//

import SwiftUI
import SpriteKit
struct ContentView: View {
    var scene : SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        scene.view?.showsFPS = true
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene,debugOptions: [.showsFPS])
            .frame(width: .infinity,height: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
