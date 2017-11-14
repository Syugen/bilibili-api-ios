//
//  UserLevelInfoView.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/14.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserLevelInfoView: UIView {
    
    var curExp: Int!
    var nextExp: Int!
    var curLevel: Int!

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if curExp == nil {
            return
        }
        
        let height = rect.size.height
        let totalWidth = rect.size.width
        
        // Drawing and filling level rectangle
        var levelRect = CGRect(x: 0, y: 0, width: height * 2, height: height)
        var path = UIBezierPath(roundedRect: levelRect, cornerRadius: 10)
        path.lineWidth = 1
        UIColor(red: 1, green: 144/256, blue: 90/256, alpha: 1).setFill()
        path.fill()
        
        // Drawing experience rectangle
        let expTotalWidth = totalWidth - 2 * height
        levelRect = CGRect(x: height * 2, y: 0, width: expTotalWidth, height: height)
        path = UIBezierPath(roundedRect: levelRect, cornerRadius: 10)
        path.lineWidth = 1
        UIColor(red: 1, green: 144/256, blue: 90/256, alpha: 1).setStroke()
        path.stroke()
        
        // Filling experience rectangle
        let expPercent = (nextExp != nil) ? Float(curExp) / Float(nextExp) : 1.0
        let expWidth = expTotalWidth * CGFloat(expPercent)
        levelRect = CGRect(x: height * 2, y: 0, width: expWidth, height: height)
        path = UIBezierPath(roundedRect: levelRect, cornerRadius: 10)
        path.lineWidth = 1
        UIColor(red: 1, green: 144/256, blue: 90/256, alpha: 1).setFill()
        path.fill()
        
        // Drawing labels
        let attr = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)] as [NSAttributedStringKey: Any]
        let levelText = "LV" + String(self.curLevel!)
        let levelNSText = NSAttributedString(string: levelText, attributes: attr)
        levelNSText.draw(at: CGPoint(x: 10, y: 2))
        
        let expText = (nextExp != nil) ? (String(curExp) + "/" + String(nextExp)) : (String(curExp) + " (Max Level)")
        let expNSText = NSAttributedString(string: expText, attributes: attr)
        expNSText.draw(at: CGPoint(x: 10 + height * 2, y: 2))
    }

}
