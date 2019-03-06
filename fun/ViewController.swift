//
//  ViewController.swift
//  fun
//
//  Created by TEAM-HLT on 6/21/16.
//  Copyright © 2016 TEAM-HLT. All rights reserved.
//

import UIKit
import QuartzCore


class ViewController: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    var started: Bool = false;
    
    var updater: CADisplayLink!
    
    var shapeLayer: CAShapeLayer!
    var label: UILabel!
    var shapejr: CAShapeLayer!

    
    var polarity: CGFloat = 0.1
    var mass: CGFloat = 0
    var y: CGFloat = 1
    var xV: CGFloat = 10
    var yV: CGFloat = 10
    var sWidth: CGFloat = 0
    var sHeight: CGFloat = 0
    
    var enemies: [BadBall] = []
    var enemyShapes: [CAShapeLayer] = []
    
    var pressed: Bool = false
    var pX: CGFloat = 0
    var pY: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func tapped(_ sender: Any) {
        tapEvent()
    }
    
    @IBAction func longPressed(_ sender: Any) {
        longPressAction((sender as? UILongPressGestureRecognizer)!)
    }
    
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        pressed = true
        let point: CGPoint = sender.location(ofTouch: sender.numberOfTouches-1, in: sender.view)
        self.pX = point.x
        self.pY = point.y
        
        for i in 0..<enemies.count{
            enemies[i].updateLoc(playerX: self.pX, playerY: self.pY, mass: 50)
        }

        
    }
    
    
    @IBAction func start(_ sender: Any) {
        startGame()
    }
    
    func startGame() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let mini = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.midX-10, y: self.view.bounds.midY-10 ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        
        let goalPath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY ), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let goal = CAShapeLayer();
        goal.path = goalPath.cgPath;
        goal.fillColor = UIColor.clear.cgColor
        goal.strokeColor = UIColor.yellow.cgColor
        goal.borderWidth = 1
        self.view.layer.addSublayer(goal)

        self.shapejr = CAShapeLayer();
        self.shapejr.path = mini.cgPath
        self.shapejr.fillColor = UIColor.green.cgColor
        self.view.layer.addSublayer(shapejr)
        
    

        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.path = circlePath.cgPath
        self.shapeLayer.fillColor = UIColor.cyan.cgColor
        self.view.layer.addSublayer(self.shapeLayer)
        
        self.updater = CADisplayLink(target: self, selector: #selector(gameLoop))
        self.updater.frameInterval = 1
        self.updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        for i in 0...100{
            let test = BadBall.init()
            let pathz = UIBezierPath(arcCenter: test.location, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shap = CAShapeLayer()
            shap.path = pathz.cgPath
            shap.fillColor = UIColor.red.cgColor
            self.view.layer.addSublayer(shap)
            enemies.append(test)
            enemyShapes.append(shap)
        }
        
        
        mass=0
        
        self.label = UILabel(frame: CGRect(x:0, y:0, width:200, height:20))
        self.label.center = self.view.center
        self.label.text = "\(mass)"
        self.view.addSubview(self.label)
        
        sWidth = UIScreen.main.bounds.size.width
        sHeight = UIScreen.main.bounds.size.height
        
        xV = CGFloat(arc4random_uniform(2)+3)
        yV = CGFloat(arc4random_uniform(2)+3)


        startBtn.isHidden = true
        self.started = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapEvent() {
        if(started){
            polarity = polarity * -1
        }
    }
    @objc func gameLoop(){
        y = y + polarity*10
        if(mass > 0 || polarity < 0){
            self.label.text = "\(round(100*mass)/100)";
            mass = mass - polarity
            if(mass > 100){
                mass = 100
            }
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            self.shapeLayer.path = circlePath.cgPath;
        }else{
            self.label.text = "0.0"
        }
        let miniPath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.midX + mass*2*cos(y/18), y: self.view.bounds.midY + 2*mass*sin(y/18) ), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        self.shapejr.path = miniPath.cgPath

        for i in 0..<enemies.count{
            enemies[i].updateLoc(playerX: miniPath.bounds.origin.x,playerY: miniPath.bounds.origin.y, mass: 10)
            let evilPath = UIBezierPath(arcCenter: enemies[i].location, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            enemyShapes[i].path = evilPath.cgPath
            let p = self.shapejr.presentation() ?? self.shapejr
            if ((p?.path?.contains(evilPath.bounds.origin))!){
//                print("I touched you!")
            }
        }
            

        
//        if(mass == 100){
//            self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//
//        }
    
    }
    
    


}

