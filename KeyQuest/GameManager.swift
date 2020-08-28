//
//  GameManager.swift
//  MazeBattle
//
//  Created by Kazushi Iwamoto on 7/11/19.
//  Copyright © 2019 Kazushi Iwamoto. All rights reserved.
//

import SpriteKit

class GameManager {
    
    var scene: GameScene!
    
    var nextTime: Double?
    var timeExtension: Double = 0.2
    
    var playerDirection: Int = 5 //1 = left, 2 = up, 3 = right, 4 = down
    var enemyDirection1: Int = 5 //1 = left, 2 = up, 3 = right, 4 = down
    var enemyDirection2: Int = 5
    var enemyDirection3: Int = 5
    var enemyDirection4: Int = 5
    var enemyDirection5: Int = 5
    
    var currentScore: Int = 0
    
    var numKeys: Int = 0
    var numRounds: Int = 0
    
    var enemyMove: Int = 0
    var playerMove: Int = 0
    
    var count: Int = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }
    //init game view and player
    func initGame() {
        if scene.playerPositions.count > 0 {
            scene.playerPositions.remove(at: 0)
        }
        if scene.enemyPositions.count > 0 {
            scene.enemyPositions.removeAll()
        }
        currentScore = 0
        scene.currentScore.text = "Score: 0"
        
        count = 0
        
        enemyMove = 0
        playerMove = 0
        playerDirection = 5
        //starting player position
        scene.playerPositions.append((2, 2))
        scene.playerPositions.append((2, 3))
        scene.playerPositions.append((2, 4))
        scene.enemyPositions.append((8, 10))
        
        numKeys = 0
        
        renderChange()
        generateNewPoint()
    }
    // update -- called every frame
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        }
        else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                addEnemy()
                updatePlayerPosition()
                updateEnemyPosition()
                checkForScore()
                checkForDeath()
                finishAnimation()
            }
        }
    }
    
    private func checkForScore() {
        if scene.keyPos1 != nil && scene.keyPos2 != nil && scene.keyPos3 != nil && scene.keyPos4 != nil && scene.playerPositions.count > 0 {
            let x = scene.playerPositions[0].0 // x- value of playerPosition
            let y = scene.playerPositions[0].1 //y-value of playerPosition
            if numKeys < 4 {
                if Int((scene.keyPos1?.x)!) == y && Int((scene.keyPos1?.y)!) == x {
                    if numKeys == 3 {
                        currentScore += 100
                    }
                    else {
                        currentScore += 10
                    }
                    scene.currentScore.text = "Score: \(currentScore)"
                    //generateNewPoint()
                    scene.keyPos1 = CGPoint(x: -1.0,y: -1.0)
                    numKeys = numKeys + 1
                }
                else if Int((scene.keyPos2?.x)!) == y && Int((scene.keyPos2?.y)!) == x {
                    if numKeys == 3 {
                        currentScore += 100
                    }
                    else {
                        currentScore += 10
                    }
                    scene.currentScore.text = "Score: \(currentScore)"
                    scene.keyPos2 = CGPoint(x: -1.0,y: -1.0)
                    numKeys = numKeys + 1
                }
                else if Int((scene.keyPos3?.x)!) == y && Int((scene.keyPos3?.y)!) == x {
                    if numKeys == 3 {
                        currentScore += 100
                    }
                    else {
                        currentScore += 10
                    }
                    scene.currentScore.text = "Score: \(currentScore)"
                    //generateNewPoint()
                    scene.keyPos3 = CGPoint(x: -1.0,y: -1.0)
                    numKeys = numKeys + 1
                }
                else if Int((scene.keyPos4?.x)!) == y && Int((scene.keyPos4?.y)!) == x {
                    if numKeys == 3 {
                        currentScore += 100
                    }
                    else {
                        currentScore += 10
                    }
                    scene.currentScore.text = "Score: \(currentScore)"
                    //generateNewPoint()
                    scene.keyPos4 = CGPoint(x: -1.0,y: -1.0)
                    numKeys = numKeys + 1
                }
            }
            else {
                numKeys = 0
                numRounds += 1
                generateNewPoint()
            }
            //print(numRounds)
        }
    }
    
    private func checkForDeath() {
        if scene.playerPositions.count > 0 && scene.enemyPositions.count == 1 {
            var arrayOfPositions = scene.playerPositions
            var arrayOfEnemyPositions = scene.enemyPositions
            let headOfEnemy = arrayOfEnemyPositions[0]
            if contains(a: arrayOfPositions, v: headOfEnemy) /*|| ((scene.playerPositions[0].0 - scene.enemyPositions[0].0 == 1) && (scene.playerPositions[0].1 == scene.enemyPositions[0].1)) || (scene.playerPositions[0].0 - scene.enemyPositions[0].0 == -1) || (scene.playerPositions[0].1 - scene.enemyPositions[0].1 == 1) || (scene.playerPositions[0].1 - scene.enemyPositions[0].1 == -1) */{
                playerDirection = 0
                enemyMove = 1
            }
        }
        else if scene.playerPositions.count > 0 && scene.enemyPositions.count == 2 {
            var arrayOfPositions = scene.playerPositions
            var arrayOfEnemyPositions = scene.enemyPositions
            let headOfEnemy = arrayOfEnemyPositions[0]
            let headOfEnemy2 = arrayOfEnemyPositions[1]
            if contains(a: arrayOfPositions, v: headOfEnemy) || contains(a: arrayOfPositions, v: headOfEnemy2) /*|| (scene.playerPositions[0].0 - scene.enemyPositions[0].0 == 1) || (scene.playerPositions[0].0 - scene.enemyPositions[0].0 == -1) || (scene.playerPositions[0].1 - scene.enemyPositions[0].1 == 1) || (scene.playerPositions[0].1 - scene.enemyPositions[0].1 == -1) || (scene.playerPositions[0].0 - scene.enemyPositions[1].0 == 1) || (scene.playerPositions[0].0 - scene.enemyPositions[1].0 == -1) || (scene.playerPositions[0].1 - scene.enemyPositions[1].1 == 1) || (scene.playerPositions[0].1 - scene.enemyPositions[1].1 == -1)*/ {
                playerDirection = 0
                enemyMove = 1
            }
        }
        else if scene.playerPositions.count > 0 && scene.enemyPositions.count == 3 {
            var arrayOfPositions = scene.playerPositions
            var arrayOfEnemyPositions = scene.enemyPositions
            let headOfEnemy = arrayOfEnemyPositions[0]
            let headOfEnemy2 = arrayOfEnemyPositions[1]
            let headOfEnemy3 = arrayOfEnemyPositions[2]
            if contains(a: arrayOfPositions, v: headOfEnemy) || contains(a: arrayOfPositions, v: headOfEnemy2) || contains(a: arrayOfPositions, v: headOfEnemy3) {
                playerDirection = 0
                enemyMove = 1
            }
        }
        else if scene.playerPositions.count > 0 && scene.enemyPositions.count == 4 {
            var arrayOfPositions = scene.playerPositions
            var arrayOfEnemyPositions = scene.enemyPositions
            let headOfEnemy = arrayOfEnemyPositions[0]
            let headOfEnemy2 = arrayOfEnemyPositions[1]
            let headOfEnemy3 = arrayOfEnemyPositions[2]
            let headOfEnemy4 = arrayOfEnemyPositions[3]
            if contains(a: arrayOfPositions, v: headOfEnemy) || contains(a: arrayOfPositions, v: headOfEnemy2) || contains(a: arrayOfPositions, v: headOfEnemy3) || contains(a: arrayOfPositions, v: headOfEnemy4) {
                playerDirection = 0
                enemyMove = 1
            }
        }
        else if scene.playerPositions.count > 0 && scene.enemyPositions.count == 5 {
            var arrayOfPositions = scene.playerPositions
            var arrayOfEnemyPositions = scene.enemyPositions
            let headOfEnemy = arrayOfEnemyPositions[0]
            let headOfEnemy2 = arrayOfEnemyPositions[1]
            let headOfEnemy3 = arrayOfEnemyPositions[2]
            let headOfEnemy4 = arrayOfEnemyPositions[3]
            let headOfEnemy5 = arrayOfEnemyPositions[4]
            if contains(a: arrayOfPositions, v: headOfEnemy) || contains(a: arrayOfPositions, v: headOfEnemy2) || contains(a: arrayOfPositions, v: headOfEnemy3) || contains(a: arrayOfPositions, v: headOfEnemy4) || contains(a: arrayOfPositions, v: headOfEnemy5) {
                playerDirection = 0
                enemyMove = 1
            }
        }
    }
    
    private func finishAnimation() {
        
        if playerDirection == 0 && scene.playerPositions.count > 0 && count == 0 {
            var hasFinished = true
            let headOfSnake = scene.playerPositions[0]
            for position in scene.playerPositions {
                if headOfSnake != position {
                    hasFinished = false
                }
            }
            if hasFinished {
                print("end game")
                //scene.playerPositions.remove(at: 0)
                updateScore()
                playerDirection = 5
                //animation has completed
                scene.scorePos = nil
                renderChange()
                //return to menu
                scene.currentScore.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.currentScore.isHidden = true
                }
                //scene.initializeMenu()
                deathAnimation()
                count = count + 1
                print(count)
            }
        }
    }
    
    func goToMenu() {
        scene.currentScore.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.scene.currentScore.isHidden = true
        }
        //animation has completed
        if scene.playerPositions.count > 0 {
            let hasFinished = true
            
            if hasFinished == true{
                scene.playerPositions.removeAll()
                scene.enemyPositions.removeAll()
                print("end game")
                playerDirection = 5
                //animation has completed
                scene.scorePos = nil
                renderChange()
                //scene.initializeMenu()
                scene.gameBG.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.gameBG.isHidden = true
                }
                recreateMenu()
            }
        }
    }
    
    func recreateMenu() {
        self.scene.gameLogo1.isHidden = false
        self.scene.gameLogo2.isHidden = false
        self.scene.gameLogo1.run(SKAction.move(to: CGPoint(x: 0, y: 350), duration: 0.5)) {
            self.scene.gameLogo2.run(SKAction.move(to: CGPoint(x: 0, y : 250), duration: 0.5))
            self.scene.playButton.isHidden = false
            self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
            self.scene.pauseButton.run(SKAction.move(by: CGVector(dx: 300, dy: 0), duration: 0.3)) {
                self.scene.pauseButton.isHidden = true
            }
            self.scene.bestScore.run(SKAction.move(to: CGPoint(x: 0, y: -400), duration: 0.3))
        }
    }
    
    private func deathAnimation() {
        //var deathScreenTimes: Int = 0
        playerMove = 1
        enemyMove = 1
        scene.createDeathView()
        print("DADDY")
    }
    
    private func updateScore() {
        if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currentScore, forKey: "bestScore")
        }
        currentScore = 0
        scene.currentScore.text = "Score: 0"
        scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    private func generateNewPoint() {
        var randomX1 = Int.random(in: 0...9)
        var randomY1 = Int.random(in: 0...17)
        var randomX2 = Int.random(in: 0...9)
        var randomY2 = Int.random(in: 0...17)
        var randomX3 = Int.random(in: 0...9)
        var randomY3 = Int.random(in: 0...17)
        var randomX4 = Int.random(in: 0...9)
        var randomY4 = Int.random(in: 0...17)
        while contains(a: scene.playerPositions, v: (Int(randomX1), Int(randomY1))) || contains(a: scene.enemyPositions, v: (Int(randomX1), Int(randomY1))) || randomX1 == randomX2 || randomX1 == randomX3 || randomX1 == randomX4 || randomY1 == randomY2 || randomY1 == randomY3 && randomY1 == randomY4 {
            randomX1 = Int.random(in: 0...9)
            randomY1 = Int.random(in: 0...17)
        }
        while contains(a: scene.playerPositions, v: (Int(randomX1), Int(randomY1))) || contains(a: scene.enemyPositions, v: (Int(randomX1), Int(randomY1))) || randomX1 == randomX2 || randomX1 == randomX3 || randomX1 == randomX4 || randomY1 == randomY2 || randomY1 == randomY3 && randomY1 == randomY4 {
            randomX2 = Int.random(in: 0...9)
            randomY2 = Int.random(in: 0...17)
        }
        while contains(a: scene.playerPositions, v: (Int(randomX1), Int(randomY1))) || contains(a: scene.enemyPositions, v: (Int(randomX1), Int(randomY1))) || randomX1 == randomX2 || randomX1 == randomX3 || randomX1 == randomX4 || randomY1 == randomY2 || randomY1 == randomY3 && randomY1 == randomY4 {
            randomX3 = Int.random(in: 0...9)
            randomY3 = Int.random(in: 0...17)
        }
        while contains(a: scene.playerPositions, v: (Int(randomX1), Int(randomY1))) || contains(a: scene.enemyPositions, v: (Int(randomX1), Int(randomY1))) || randomX1 == randomX2 || randomX1 == randomX3 || randomX1 == randomX4 || randomY1 == randomY2 || randomY1 == randomY3 && randomY1 == randomY4 {
            randomX4 = Int.random(in: 0...9)
            randomY4 = Int.random(in: 0...17)
        }
        scene.keyPos1 = CGPoint(x: randomX1, y: randomY1)
        scene.keyPos2 = CGPoint(x: randomX2, y: randomY2)
        scene.keyPos3 = CGPoint(x: randomX3, y: randomY3)
        scene.keyPos4 = CGPoint(x: randomX4, y: randomY4)
    }
    
    func renderChange() {
        for (node, x, y) in scene.gameArray {
            if contains(a: scene.enemyPositions, v: (x,y)) { // image of enemy
                node.fillColor = SKColor.gray
                node.fillTexture = SKTexture(image: UIImage(named: "badguy.png")!)
            }
            else if contains(a: scene.playerPositions, v: (x,y)) { // image of self
                node.fillColor = SKColor.gray
                node.fillTexture = SKTexture(image: UIImage(named: "mario.png")!)
            }
            else {
                node.fillColor = SKColor.clear
                if scene.keyPos1 != nil {
                    if Int((scene.keyPos1?.x)!) == y && Int((scene.keyPos1?.y)!) == x {
                        node.fillColor = SKColor.gray
                        node.fillTexture = SKTexture(image: UIImage(named: "key.png")!)
                    }
                }
                if scene.keyPos2 != nil {
                    if Int((scene.keyPos2?.x)!) == y && Int((scene.keyPos2?.y)!) == x {
                        node.fillColor = SKColor.gray
                        node.fillTexture = SKTexture(image: UIImage(named: "key.png")!)
                    }
                }
                if scene.keyPos3 != nil {
                    if Int((scene.keyPos3?.x)!) == y && Int((scene.keyPos3?.y)!) == x {
                        node.fillColor = SKColor.gray
                        node.fillTexture = SKTexture(image: UIImage(named: "key.png")!)
                    }
                }
                if scene.keyPos4 != nil {
                    if Int((scene.keyPos4?.x)!) == y && Int((scene.keyPos4?.y)!) == x {
                        node.fillColor = SKColor.gray
                        node.fillTexture = SKTexture(image: UIImage(named: "key.png")!)
                    }
                }
            }
        }
    }
    
    func swipe(ID: Int) {
        if !(ID == 2 && playerDirection == 4) || !(ID == 4 && playerDirection == 2) {
            if !(ID == 1 && playerDirection == 3) || !(ID == 3 && playerDirection == 1) {
                if playerDirection != 0 {
                    playerDirection = ID
                }
            }
        }
    }
    
    private func updatePlayerPosition() {
        
        var xChange = 0
        var yChange = 0
        
        if playerMove == 1 {
            playerDirection = 5
        }
        
        switch playerDirection {
        case 1:
            //left
            xChange = -1
            yChange = 0
            break
        case 2:
            //up
            xChange = 0
            yChange = -1
            break
        case 3:
            //right
            xChange = 1
            yChange = 0
            break
        case 4:
            //down
            xChange = 0
            yChange = 1
            break
            
        case 5:
            //stopped moving
            xChange = 0
            yChange = 0
            break
            
        case 0:
            //dead
            xChange = 0
            yChange = 0
            break
        default:
            break
        }
        
        
        if scene.playerPositions.count > 0 {
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
        }
        if scene.playerPositions.count > 0 {
            let x = scene.playerPositions[0].1
            let y = scene.playerPositions[0].0
            if y > 17 {
                scene.playerPositions[0].0 = 17
            } else if y < 0 {
                scene.playerPositions[0].0 = 0
            } else if x > 9 {
                scene.playerPositions[0].1 = 9
            } else if x < 0 {
                scene.playerPositions[0].1 = 0
            }
        }
        
    }
    
    private func updateEnemyPosition() {
        var enemyXChange1 = 0
        var enemyYChange1 = 0
        var enemyXChange2 = 0
        var enemyYChange2 = 0
        var enemyXChange3 = 0
        var enemyYChange3 = 0
        var enemyXChange4 = 0
        var enemyYChange4 = 0
        
        if enemyMove == 0 {
            enemyDirection1 = Int.random(in: 0...4)
            enemyDirection2 = Int.random(in: 0...4)
            enemyDirection3 = Int.random(in: 0...4)
            enemyDirection4 = Int.random(in: 0...4)
        }
        else if enemyMove == 1 {
            enemyDirection1 = 5
            enemyDirection2 = 5
            enemyDirection3 = 5
            enemyDirection4 = 5
        }
        
        
        switch enemyDirection1 {
        case 1:
            //left
            enemyXChange1 = -1
            enemyYChange1 = 0
            break
        case 2:
            //up
            enemyXChange1 = 0
            enemyYChange1 = -1
            break
        case 3:
            //right
            enemyXChange1 = 1
            enemyYChange1 = 0
            break
        case 4:
            //down
            enemyXChange1 = 0
            enemyYChange1 = 1
            break
        case 5:
            // not moving
            enemyXChange1 = 0
            enemyYChange1 = 0
        default:
            break
        }
        
        switch enemyDirection2 {
        case 1:
            //left
            enemyXChange2 = -1
            enemyYChange2 = 0
            break
        case 2:
            //up
            enemyXChange2 = 0
            enemyYChange2 = -1
            break
        case 3:
            //right
            enemyXChange2 = 1
            enemyYChange2 = 0
            break
        case 4:
            //down
            enemyXChange2 = 0
            enemyYChange2 = 1
            break
        case 5:
            // not moving
            enemyXChange2 = 0
            enemyYChange2 = 0
        default:
            break
        }
        
        switch enemyDirection3 {
        case 1:
            //left
            enemyXChange3 = -1
            enemyYChange3 = 0
            break
        case 2:
            //up
            enemyXChange3 = 0
            enemyYChange3 = -1
            break
        case 3:
            //right
            enemyXChange3 = 1
            enemyYChange3 = 0
            break
        case 4:
            //down
            enemyXChange3 = 0
            enemyYChange3 = 1
            break
        case 5:
            // not moving
            enemyXChange3 = 0
            enemyYChange3 = 0
        default:
            break
        }
        
        switch enemyDirection4 {
        case 1:
            //left
            enemyXChange4 = -1
            enemyYChange4 = 0
            break
        case 2:
            //up
            enemyXChange4 = 0
            enemyYChange4 = -1
            break
        case 3:
            //right
            enemyXChange4 = 1
            enemyYChange4 = 0
            break
        case 4:
            //down
            enemyXChange4 = 0
            enemyYChange4 = 1
            break
        case 5:
            // not moving
            enemyXChange4 = 0
            enemyYChange4 = 0
        default:
            break
        }
        
        if scene.enemyPositions.count == 1 {
            scene.enemyPositions[0] = (scene.enemyPositions[0].0 + enemyYChange1, scene.enemyPositions[0].1 + enemyXChange1)
        }
        else if scene.enemyPositions.count == 2 {
            scene.enemyPositions[0] = (scene.enemyPositions[0].0 + enemyYChange1, scene.enemyPositions[0].1 + enemyXChange1)
            scene.enemyPositions[1] = (scene.enemyPositions[1].0 + enemyYChange2, scene.enemyPositions[1].1 + enemyXChange2)
        }
        else if scene.enemyPositions.count == 3 {
            scene.enemyPositions[0] = (scene.enemyPositions[0].0 + enemyYChange1, scene.enemyPositions[0].1 + enemyXChange1)
            scene.enemyPositions[1] = (scene.enemyPositions[1].0 + enemyYChange2, scene.enemyPositions[1].1 + enemyXChange2)
            scene.enemyPositions[2] = (scene.enemyPositions[2].0 + enemyYChange3, scene.enemyPositions[2].1 + enemyXChange3)
        }
        else if scene.enemyPositions.count == 4 {
            scene.enemyPositions[0] = (scene.enemyPositions[0].0 + enemyYChange1, scene.enemyPositions[0].1 + enemyXChange1)
            scene.enemyPositions[1] = (scene.enemyPositions[1].0 + enemyYChange2, scene.enemyPositions[1].1 + enemyXChange2)
            scene.enemyPositions[2] = (scene.enemyPositions[2].0 + enemyYChange3, scene.enemyPositions[2].1 + enemyXChange3)
            scene.enemyPositions[3] = (scene.enemyPositions[3].0 + enemyYChange4, scene.enemyPositions[3].1 + enemyXChange4)
        }
        
        
        if scene.enemyPositions.count == 1 {
            let x1 = scene.enemyPositions[0].1
            let y1 = scene.enemyPositions[0].0
            
            if y1 > 17 {
                scene.enemyPositions[0].0 = 17
            } else if y1 < 0 {
                scene.enemyPositions[0].0 = 0
            } else if x1 > 9 {
                scene.enemyPositions[0].1 = 9
            } else if x1 < 0 {
                scene.enemyPositions[0].1 = 0
            }
        }
        else if scene.enemyPositions.count == 2 {
            let x1 = scene.enemyPositions[0].1
            let y1 = scene.enemyPositions[0].0
            let x2 = scene.enemyPositions[1].1
            let y2 = scene.enemyPositions[1].0
            
            if y1 > 17 {
                scene.enemyPositions[0].0 = 17
            } else if y1 < 0 {
                scene.enemyPositions[0].0 = 0
            } else if x1 > 9 {
                scene.enemyPositions[0].1 = 9
            } else if x1 < 0 {
                scene.enemyPositions[0].1 = 0
            }
            
            if y2 > 17 {
                scene.enemyPositions[1].0 = 17
            } else if y2 < 0 {
                scene.enemyPositions[1].0 = 0
            } else if x2 > 9 {
                scene.enemyPositions[1].1 = 9
            } else if x2 < 0 {
                scene.enemyPositions[1].1 = 0
            }
        }
        else if scene.enemyPositions.count == 3 {
            let x1 = scene.enemyPositions[0].1
            let y1 = scene.enemyPositions[0].0
            let x2 = scene.enemyPositions[1].1
            let y2 = scene.enemyPositions[1].0
            let x3 = scene.enemyPositions[2].1
            let y3 = scene.enemyPositions[2].0
            
            if y1 > 17 {
                scene.enemyPositions[0].0 = 17
            } else if y1 < 0 {
                scene.enemyPositions[0].0 = 0
            } else if x1 > 9 {
                scene.enemyPositions[0].1 = 9
            } else if x1 < 0 {
                scene.enemyPositions[0].1 = 0
            }
            
            if y2 > 17 {
                scene.enemyPositions[1].0 = 17
            } else if y2 < 0 {
                scene.enemyPositions[1].0 = 0
            } else if x2 > 9 {
                scene.enemyPositions[1].1 = 9
            } else if x2 < 0 {
                scene.enemyPositions[1].1 = 0
            }
            
            if y3 > 17 {
                scene.enemyPositions[2].0 = 17
            } else if y3 < 0 {
                scene.enemyPositions[2].0 = 0
            } else if x3 > 9 {
                scene.enemyPositions[2].1 = 9
            } else if x3 < 0 {
                scene.enemyPositions[2].1 = 0
            }
        }
        else if scene.enemyPositions.count == 4 {
            let x1 = scene.enemyPositions[0].1
            let y1 = scene.enemyPositions[0].0
            let x2 = scene.enemyPositions[1].1
            let y2 = scene.enemyPositions[1].0
            let x3 = scene.enemyPositions[2].1
            let y3 = scene.enemyPositions[2].0
            let x4 = scene.enemyPositions[3].1
            let y4 = scene.enemyPositions[3].0
            
            if y1 > 17 {
                scene.enemyPositions[0].0 = 17
            } else if y1 < 0 {
                scene.enemyPositions[0].0 = 0
            } else if x1 > 9 {
                scene.enemyPositions[0].1 = 9
            } else if x1 < 0 {
                scene.enemyPositions[0].1 = 0
            }
            
            if y2 > 17 {
                scene.enemyPositions[1].0 = 17
            } else if y2 < 0 {
                scene.enemyPositions[1].0 = 0
            } else if x2 > 9 {
                scene.enemyPositions[1].1 = 9
            } else if x2 < 0 {
                scene.enemyPositions[1].1 = 0
            }
            
            if y3 > 17 {
                scene.enemyPositions[2].0 = 17
            } else if y3 < 0 {
                scene.enemyPositions[2].0 = 0
            } else if x3 > 9 {
                scene.enemyPositions[2].1 = 9
            } else if x3 < 0 {
                scene.enemyPositions[2].1 = 0
            }
            if y4 > 17 {
                scene.enemyPositions[3].0 = 17
            } else if y4 < 0 {
                scene.enemyPositions[3].0 = 0
            } else if x4 > 9 {
                scene.enemyPositions[3].1 = 9
            } else if x4 < 0 {
                scene.enemyPositions[3].1 = 0
            }
        }
        renderChange()
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    private func addEnemy() {
        var newEnemyX = Int.random(in: 0...9)
        var newEnemyY = Int.random(in: 0...17)
        if numRounds == 1 && scene.enemyPositions.count < 4 {
            while contains(a: scene.enemyPositions, v: (Int(newEnemyX), Int(newEnemyY))) || (Int((scene.keyPos1?.x)!) == (Int(newEnemyX)) && Int((scene.keyPos1?.y)!) == (Int(newEnemyY))) || (Int((scene.keyPos2?.x)!) == (Int(newEnemyX)) && Int((scene.keyPos2?.y)!) == (Int(newEnemyY))) || (Int((scene.keyPos3?.x)!) == (Int(newEnemyX)) && Int((scene.keyPos3?.y)!) == (Int(newEnemyY))) || (Int((scene.keyPos4?.x)!) == (Int(newEnemyX)) && Int((scene.keyPos4?.y)!) == (Int(newEnemyY))) {
                newEnemyX = Int.random(in: 0...9)
                newEnemyY = Int.random(in: 0...17)
            }
            scene.enemyPositions.append((newEnemyX, newEnemyY))
            numRounds = 0
        }
    }
}
