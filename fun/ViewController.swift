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
    

    @IBAction func longPressAction(sender: UILongPressGestureRecognizer) {
        pressed = true
        let point: CGPoint = sender.locationOfTouch(sender.numberOfTouches()-1, inView: sender.view)
        self.pX = point.x
        self.pY = point.y
        
        for i in 0..<enemies.count{
            enemies[i].updateLoc(self.pX, playerY: self.pY, mass: 50)
        }

        
    }
    
    
    @IBAction func startGame(sender: UIButton) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds) ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let mini = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.view.bounds)-10, y: CGRectGetMidX(self.view.bounds)-10 ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        let goalPath = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds) ), radius: CGFloat(200), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let goal = CAShapeLayer();
        goal.path = goalPath.CGPath;
        goal.fillColor = UIColor.clearColor().CGColor
        goal.strokeColor = UIColor.yellowColor().CGColor
        goal.borderWidth = 1
        self.view.layer.addSublayer(goal)

        self.shapejr = CAShapeLayer();
        self.shapejr.path = mini.CGPath
        self.shapejr.fillColor = UIColor.greenColor().CGColor
        self.view.layer.addSublayer(shapejr)
        
    

        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.path = circlePath.CGPath
        self.shapeLayer.fillColor = UIColor.cyanColor().CGColor
        self.view.layer.addSublayer(self.shapeLayer)
        
        self.updater = CADisplayLink(target: self, selector: #selector(ViewController.gameLoop))
        self.updater.frameInterval = 1
        self.updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        for i in 0...100{
            let test = BadBall.init()
            let pathz = UIBezierPath(arcCenter: test.location, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let shap = CAShapeLayer()
            shap.path = pathz.CGPath
            shap.fillColor = UIColor.redColor().CGColor
            self.view.layer.addSublayer(shap)
            enemies.append(test)
            enemyShapes.append(shap)
        }
        
        
        mass=0
        
        self.label = UILabel(frame: CGRectMake(0, 0, 200, 20))
        self.label.center = self.view.center
        self.label.text = String(mass)
        self.view.addSubview(self.label)
        
        sWidth = UIScreen.mainScreen().bounds.size.width
        sHeight = UIScreen.mainScreen().bounds.size.height
        
        xV = CGFloat(arc4random_uniform(2)+3)
        yV = CGFloat(arc4random_uniform(2)+3)


        sender.hidden = true
        self.started = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapEvent(sender: AnyObject) {
        if(started){
            polarity = polarity * -1
        }
    }
    func gameLoop(){
        y = y + polarity*10
        if(mass > 0 || polarity < 0){
            self.label.text = String(round(100*mass)/100);
            mass = mass - polarity
            if(mass > 100){
                mass = 100
            }
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds) ), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            self.shapeLayer.path = circlePath.CGPath;
        }else{
            self.label.text = "0.0"
        }
        let miniPath = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(self.view.bounds) + mass*2*cos(y/18), y: CGRectGetMidY(self.view.bounds) + 2*mass*sin(y/18) ), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        self.shapejr.path = miniPath.CGPath

        for i in 0..<enemies.count{
            enemies[i].updateLoc(miniPath.bounds.origin.x,playerY: miniPath.bounds.origin.y, mass: 10)
            let evilPath = UIBezierPath(arcCenter: enemies[i].location, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            enemyShapes[i].path = evilPath.CGPath
            let p = self.shapejr.presentationLayer() as? CAShapeLayer ?? self.shapejr
            if (CGPathContainsPoint(p?.path, nil, evilPath.bounds.origin, false)){
                //print("I touched you!")
            }
        }
            

        
//        if(mass == 100){
//            self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//
//        }
    
    }
    
    


}

