//
//  GameScene.swift
//  MazeBattle
//
//  Created by Kazushi Iwamoto on 7/11/19.
//  Copyright © 2019 Kazushi Iwamoto. All rights reserved.
//

import SpriteKit
import GameplayKit

var backgroundColorCustom = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)

class GameScene: SKScene {
    
    var gameLogo1: SKLabelNode!
    var gameLogo2: SKLabelNode!
    var deathLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKLabelNode!
    var pauseButton: SKShapeNode!
    var resumeButton: SKLabelNode!
    var menuButton: SKLabelNode!
    var menuButton2: SKLabelNode!
    var game: GameManager!
    var color: UIColor!
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var enemyPositions:[(Int, Int)] = []
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var scorePos: CGPoint?
    var keyPos1: CGPoint?
    var keyPos2: CGPoint?
    var keyPos3: CGPoint?
    var keyPos4: CGPoint?
    var deadLogo: SKLabelNode!
    var pressPause: Bool = false

    
    override func didMove(to view: SKView) {
        
        backgroundColor = backgroundColorCustom
        
        initializeMenu()
        game = GameManager(scene:self)
        initializeGameView()
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    func fadeScreen() {
        let fadeAlpha = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
        
        for (node, x, y) in self.gameArray {
            if node.name == "resume_button" || node.name == "menu_button" {
                node.alpha = 1.0
            }
            else {
                node.run(fadeAlpha)
            }
        }
        backgroundColorCustom = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.3)
        backgroundColor = backgroundColorCustom
        
        currentScore.run(fadeAlpha)
        bestScore.run(fadeAlpha)
    }
    
    func unfadeScreen() {
        let unfadeAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        
        for (node, x, y) in self.gameArray {
            if node.name == "resume_button" || node.name == "menu_button" {
                node.alpha = 1.0
            }
            else {
                node.run(unfadeAlpha)
            }
        }
        backgroundColorCustom = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        backgroundColor = backgroundColorCustom
        
        currentScore.run(unfadeAlpha)
        bestScore.run(unfadeAlpha)
    }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func update(_ currentTime: TimeInterval) {
        game.update(time:currentTime)
    }
    
    //3
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
                else if node.name == "pause_button" {
                    print("Pause")
                    pressPause = true
                    createPauseView()
                    fadeScreen()
                    self.game.enemyMove = 1
                    self.game.playerMove = 1
                }
                else if node.name == "resume_button" {
                    self.game.enemyMove = 0
                    self.game.playerMove = 0
                    print("Resume")
                    self.pauseButton.isHidden = false
                    pauseButton.run(SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 0.3))
                    self.resumeButton.run(SKAction.scale(to: 0, duration: 0.3)) {
                        self.resumeButton.isHidden = true
                    }
                    self.menuButton.run(SKAction.scale(to: 0, duration: 0.3)) {
                        self.menuButton.isHidden = true
                    }
                    unfadeScreen()
                }
                else if node.name == "menu_button" {
                    self.unfadeScreen()
                    self.game.goToMenu()
                    self.resumeButton.run(SKAction.scale(to: 0, duration: 0.3)) {
                        self.resumeButton.isHidden = true
                    }
                    self.menuButton.run(SKAction.scale(to: 0, duration: 0.3)) {
                        self.menuButton.isHidden = true
                    }
                    print("Menu Button")
                }
                else if node.name == "menu_button2" {
                    print("Menu Button2")
                    self.unfadeScreen()
                    self.deathLogo.run(SKAction.scale(to: 0, duration: 0.3)){
                        self.deathLogo.isHidden = true
                    }
                    self.menuButton2.run(SKAction.scale(to: 0, duration: 0.3)){
                        self.menuButton2.isHidden = true
                    }
                    self.game.goToMenu()
                }
            }
        }
    }
    
    func createDeathView() {
        fadeScreen()
        deathLogo = SKLabelNode(fontNamed: "Chalkduster")
        deathLogo.zPosition = 2
        deathLogo.position = CGPoint(x: 0, y: 300)
        deathLogo.fontSize = 90
        deathLogo.text = "YOU DIED"
        deathLogo.fontColor = SKColor.red
        deathLogo.setScale(0)
        deathLogo.isHidden = true
        self.addChild(deathLogo)
        
        deathLogo.isHidden = false
        self.deathLogo.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        menuButton2 = SKLabelNode(fontNamed: "Chalkduster")
        menuButton2.name = "menu_button2"
        menuButton2.zPosition = 5
        menuButton2.position = CGPoint(x: 0, y: -50)
        menuButton2.fontSize = 50
        menuButton2.text = "MENU"
        menuButton2.fontColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
        menuButton2.setScale(0)
        menuButton2.isHidden = true
        self.addChild(menuButton2)
        
        menuButton2.isHidden = false
        self.menuButton2.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        pauseButton.run(SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.3)){
            self.pauseButton.isHidden = true
        }
    }

    private func createPauseView() {
        if pressPause == true {
            self.pauseButton.run(SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.3)) {
                self.pauseButton.isHidden = true
            }
            // add resume button
            resumeButton = SKLabelNode(fontNamed: "Chalkduster")
            resumeButton.name = "resume_button"
            resumeButton.zPosition = 5
            resumeButton.position = CGPoint(x: 0, y: 100)
            resumeButton.fontSize = 50
            resumeButton.text = "RESUME"
            resumeButton.fontColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
            /*resumeButton.fillColor = SKColor.blue
            let topLeftCorner1 = CGPoint(x: -100, y: 50)
            let bottomLeftCorner1 = CGPoint(x: -100, y: -50)
            let topRightCorner1 = CGPoint(x: -75, y: 50)
            let bottomRightCorner1 = CGPoint(x: -75, y: -50)
            let topLeftCorner2 = CGPoint(x: -25, y: 50)
            let bottomLeftCorner2 = CGPoint(x: -25, y: -50)
            let topRightCorner2 = CGPoint(x: 0, y: 50)
            let bottomRightCorner2 = CGPoint(x: 0, y: -50)
            let resumePath = CGMutablePath()
            resumePath.addLines(between: [topLeftCorner1, bottomLeftCorner1, bottomRightCorner1, topRightCorner1, topLeftCorner1])
            resumePath.addLines(between: [topLeftCorner2, bottomLeftCorner2, bottomRightCorner2, topRightCorner2, topLeftCorner2])
            resumeButton.path = resumePath*/
            self.addChild(resumeButton)
            
            // add menu button
            menuButton = SKLabelNode(fontNamed: "Chalkduster")
            menuButton.name = "menu_button"
            menuButton.zPosition = 5
            menuButton.position = CGPoint(x: 0, y: -100)
            menuButton.fontSize = 50
            menuButton.text = "MENU"
            menuButton.fontColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
            self.addChild(menuButton)
        }
        
    }
    
    private func initializeGameView() {
        //4
        currentScore = SKLabelNode(fontNamed: "Chalkduster")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / 2) - 100)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        //5
        let width = frame.size.width - 150
        let height = frame.size.height - 255
        print(width)
        print(height)
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0)
        gameBG.fillColor = SKColor.lightGray // color of grid
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: width, height: height)
    }
    
    //create a game board, initialize array of cells
    private func createGameBoard(width: CGFloat, height: CGFloat) {
        let cellWidth: CGFloat = 60
        let numRows = 18
        let numCols = 10
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...Int(numRows) - 1 {
            for j in 0...Int(numCols) - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.white // color of grid borders
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    
    private func startGame() {
        pauseButton = SKShapeNode()
        pauseButton.name = "pause_button"
        pauseButton.zPosition = 1
        pauseButton.position = CGPoint(x: 440, y: 300)
        pauseButton.fillColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
        let topLeftCorner1 = CGPoint(x: 135, y: 325)
        let bottomLeftCorner1 = CGPoint(x: 135, y: 275)
        let topRightCorner1 = CGPoint(x: 120, y: 325)
        let bottomRightCorner1 = CGPoint(x: 120, y: 275)
        let topLeftCorner2 = CGPoint(x: 145, y: 325)
        let bottomLeftCorner2 = CGPoint(x: 145, y: 275)
        let topRightCorner2 = CGPoint(x: 160, y: 325)
        let bottomRightCorner2 = CGPoint(x: 160, y: 275)
        let pausePath = CGMutablePath()
        pausePath.addLines(between: [topLeftCorner1, bottomLeftCorner1, bottomRightCorner1, topRightCorner1, topLeftCorner1])
        pausePath.addLines(between: [topLeftCorner2, bottomLeftCorner2, bottomRightCorner2, topRightCorner2, topLeftCorner2])
        pauseButton.path = pausePath
        self.addChild(pauseButton)
        
        print("start game")
        gameLogo1.run(SKAction.move(by: CGVector(dx: -500, dy: 0), duration: 0.5)) {
            self.gameLogo1.isHidden = true
        }
            gameLogo2.run(SKAction.move(by: CGVector(dx: 600, dy: 0), duration: 0.5)) {
            self.gameLogo2.isHidden = true
        }
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        self.pauseButton.isHidden = false
        pauseButton.run(SKAction.move(by: CGVector(dx: -300, dy: 0), duration: 1.0))
        let bottomCorner = CGPoint(x: 0, y: frame.size.height / -2 + 60 )
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
            self.currentScore.setScale(0)
            self.gameBG.isHidden = false
            self.currentScore.isHidden = false
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
        }
    }
    private func initializeMenu() {
        //Create game title
        gameLogo1 = SKLabelNode(fontNamed: "Chalkduster")
        gameLogo1.zPosition = 1
        gameLogo1.position = CGPoint(x: 0, y: 350)
        gameLogo1.fontSize = 90
        gameLogo1.text = "KEY"
        gameLogo1.fontColor = SKColor.blue
        self.addChild(gameLogo1)
        gameLogo2 = SKLabelNode(fontNamed: "Chalkduster")
        gameLogo2.zPosition = 1
        gameLogo2.position = CGPoint(x: 0, y: 250)
        gameLogo2.fontSize = 70
        gameLogo2.text = "QUEST"
        gameLogo2.fontColor = SKColor.blue
        self.addChild(gameLogo2)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "Chalkduster")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: -400)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKLabelNode(fontNamed: "Chalkduster")
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: -30)
        playButton.text = "PLAY"
        playButton.fontSize = 50
        playButton.fontColor = UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
        self.addChild(playButton)
    }
}


