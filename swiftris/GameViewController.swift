//
//  GameViewController.swift
//  swiftris
//
//  Created by Donald Plummer on 7/11/15.
//  Copyright (c) 2015 Donald Plummer. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController, SwiftrisDelegate {
    var scene: GameScene!
    var swiftris: Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill

        scene.tick = didTick

        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        
        skView.presentScene(scene)

    }

    func didTick() {
        swiftris.letShapeFall()
    }

    func nextShape() {
        let newShapes = swiftris.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }

    func gameDidBegin(swiftris: Swiftris) {
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        }
    }

    func gameDidEnd(swiftris: Swiftris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
    }

    func gameDidLevelUp(swiftris: Swiftris) {

    }

    func gameShapeDidDrop(swiftris: Swiftris) {
    }

    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        nextShape()
    }

    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
