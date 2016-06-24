//
//  badBall.swift
//  fun
//
//  Created by TEAM-HLT on 6/22/16.
//  Copyright © 2016 TEAM-HLT. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class BadBall{
    var xV: CGFloat = 0;
    var yV: CGFloat = 0;
    var radius: CGFloat = 5;
    var location: CGPoint!
    var dVX: CGFloat = 0;
    var dVY: CGFloat = 0;
    
    var sWidth: UInt32 = 0
    var sHeight: UInt32 = 0
    
    init(){
        self.sWidth = UInt32(UIScreen.mainScreen().bounds.size.width)
        self.sHeight = UInt32(UIScreen.mainScreen().bounds.size.height)
        
        self.location = CGPointMake(CGFloat(arc4random_uniform(self.sWidth)), CGFloat(arc4random_uniform(sHeight)))
        self.xV = 0
        self.yV = 0
 


    }
    
    func updateLoc(playerX: CGFloat, playerY: CGFloat, mass: Int){
        
        //update acceleration
        updateAccel(playerX, y: playerY, mass: mass)
        xV += dVX
        yV += dVY
        
        //update location
        self.location.x += xV
        self.location.y += yV
        if(xV > 1){
            xV = sqrt(2)/5
        }
        if(yV > 1){
            yV = sqrt(2)/5
        }
        //handle wall collision
        if(self.location.x <= 0){
            self.xV = self.xV * -1
            self.location.x = self.location.x + 10
        }
        if(self.location.y <= 0){
            self.yV = self.yV * -1
            self.location.y = self.location.y + 7
        }
        if(self.location.x >= CGFloat(self.sWidth)){
            self.xV = self.xV * -1
            self.location.x = self.location.x - 10
        }
        if(self.location.y >= CGFloat(self.sHeight)){
            self.yV = self.yV * -1
            self.location.y = self.location.y - 7
            
        }
    }
    
    func updateAccel(x: CGFloat, y: CGFloat, mass: Int){
        let yDiff = y - self.location.y
        let xDiff = x - self.location.x
        let angle = atan2(Double(yDiff), Double(xDiff))

        
        var distanceSquared = xDiff*xDiff + yDiff*yDiff
        if(distanceSquared < 2000){
            distanceSquared = 2000
        }
        
        let acceleration = CGFloat(mass)*50/distanceSquared
        

        self.dVX = acceleration*cos(CGFloat(angle))
        self.dVY = acceleration*sin(CGFloat(angle))
        
    }
    
}
