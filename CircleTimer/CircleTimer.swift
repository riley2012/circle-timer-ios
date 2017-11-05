//
//  CircleTimer.swift
//  CircleTimer
//

import Foundation
import UIKit

@IBDesignable
open class CircleTimer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBaseLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpBaseLayer()
    }
    
    /** If true, use a mask to reveal the background of the timer, if the background is clear, the view beneath the timer will be revealed */
    @IBInspectable
    open var useMask: Bool = true {
        didSet {
            update()
        }
    }
    
    /** The color of the border around the circle */
    @IBInspectable
    open var timerBorderColor: UIColor = UIColor.white {
        didSet {
            update()
        }
    }
    
    /**
     The color of the background of the timer
     */
    @IBInspectable
    open var timerBackgroundColor: UIColor = UIColor.lightGray {
        didSet {
            update()
        }
    }
    
    /**
     The color of the timer when it's filled
     */
    @IBInspectable
    open var timerFillColor: UIColor = UIColor.blue {
        didSet {
            update()
        }
    }
    
    /**
     Shadow opacity
     */
    @IBInspectable
    open var timerShadowOpacity: CGFloat = 0.25 {
        didSet {
            update()
        }
    }
    
    /**
     ratio for shadow width. The ratio of the shadow width to the width of the view frame
     */
    @IBInspectable
    open var ratioForShadowWidth: CGFloat = 1 / 20 {
        didSet {
            update()
        }
    }
    
    /**
     The ratio that is used to determine the width of the border. It's the ratio of the border to the width of the view frame
     */
    @IBInspectable
    open var ratioForBorderWidth: CGFloat = 1 / 20 {
        didSet {
            update()
        }
    }
    
    /**
     The ratio that is used to determine the diameter of the timer. It's the ratio of the timer's diameter to the width of the view frame
     */
    @IBInspectable
    open var ratioForTimerDiameter: CGFloat = 16 / 20 {
        didSet {
            update()
        }
    }
    
    var filledLayer: CALayer? = nil
    
    var timerLayer: CALayer? = nil
    
    var timerFillDiameter: CGFloat = 0
    
    func setUpBaseLayer() {
        let l = self.layer
        l.backgroundColor = timerBackgroundColor.cgColor
        let bWidth = self.frame.width * ratioForBorderWidth
        l.borderWidth = bWidth
        l.cornerRadius = self.frame.width / 2
        l.borderColor = self.timerBorderColor.cgColor
        l.shadowOpacity = Float(self.timerShadowOpacity)
        l.shadowRadius = self.frame.width * ratioForShadowWidth
        // l.contentsGravity = kCAGravityCenter
        
        timerFillDiameter = self.frame.width * ratioForTimerDiameter
        
        self.contentMode = UIViewContentMode.redraw
    }
    
    func update() {
        var doFill = false
        if filledLayer != nil && timerLayer == nil {
            doFill = true
        }
        clear()
        setUpBaseLayer()
        if doFill {
            drawFilled()
        }
    }
    
    open func drawFilled() {
        clear()
        if filledLayer == nil {
            let parentLayer = self.layer
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = parentLayer.bounds
            circleLayer.position = CGPoint(x: parentLayer.bounds.midX, y: parentLayer.bounds.midY)
            let circleRadius = timerFillDiameter * 0.5
            let circleBounds = CGRect(x: parentLayer.bounds.midX - circleRadius, y: parentLayer.bounds.midY - circleRadius, width: timerFillDiameter, height: timerFillDiameter)
            circleLayer.fillColor = timerFillColor.cgColor
            circleLayer.path = UIBezierPath(ovalIn: circleBounds).cgPath
            
            parentLayer.addSublayer(circleLayer)
            filledLayer = circleLayer
        }
    }
    
    /**
     Clear the timer - if the timer had all or part of a fill, it will be cleared
     */
    open func clear() {
        removeTimerLayer()
        removeFilledLayer()
    }
    
    open func startTimer(duration: CFTimeInterval) {
        drawFilled()
        if useMask {
            runMaskAnimation(duration: duration)
        } else {
            runDrawAnimation(duration: duration)
        }
    }
    
    open func runMaskAnimation(duration: CFTimeInterval) {
        
        if let parentLayer = filledLayer {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = parentLayer.frame
            
            let circleRadius = timerFillDiameter * 0.5
            let circleHalfRadius = circleRadius * 0.5
            let circleBounds = CGRect(x: parentLayer.bounds.midX - circleHalfRadius, y: parentLayer.bounds.midY - circleHalfRadius, width: circleRadius, height: circleRadius)
            
            maskLayer.fillColor = UIColor.clear.cgColor
            maskLayer.strokeColor = UIColor.black.cgColor
            maskLayer.lineWidth = circleRadius
            
            let path = UIBezierPath(roundedRect: circleBounds, cornerRadius: circleBounds.size.width * 0.5)
            maskLayer.path = path.reversing().cgPath
            maskLayer.strokeEnd = 0
            
            parentLayer.mask = maskLayer
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 1.0
            animation.toValue = 0.0
            maskLayer.add(animation, forKey: "strokeEnd")
        }
        
    }
    
    open func runDrawAnimation(duration: CFTimeInterval) {
        
        // Create a circle path that is half the intended radius.
        // Give it a line width of the intended radius.
        // Animate the path by animating to strokeEnd
        if let parentLayer = filledLayer {
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = parentLayer.bounds
            circleLayer.position = CGPoint(x: parentLayer.bounds.midX, y: parentLayer.bounds.midY)
            let circleRadius = timerFillDiameter * 0.5
            let circleHalfRadius = circleRadius * 0.5
            let circleBounds = CGRect(x: parentLayer.bounds.midX - circleHalfRadius, y: parentLayer.bounds.midY - circleHalfRadius, width: circleRadius, height: circleRadius)
            
            // print("Timer circle Bounds = \(circleBounds.debugDescription)")
            let path = UIBezierPath(roundedRect: circleBounds, cornerRadius: circleBounds.size.width * 0.5)
            
            circleLayer.strokeColor = timerBackgroundColor.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            // add 1 pixel to the radius to make sure to cover the filled area
            circleLayer.lineWidth = circleRadius + 1
            circleLayer.path = path.cgPath
            parentLayer.addSublayer(circleLayer)
            circleLayer.strokeStart = 0
            circleLayer.strokeEnd = 1
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 0.0
            animation.toValue = 1.0
            circleLayer.add(animation, forKey: "strokeEnd")
        }
        
    }
    
    private func removeTimerLayer() {
        if let l = timerLayer {
            l.removeFromSuperlayer()
            timerLayer = nil
        }
    }
    
    private func removeFilledLayer() {
        if let l = filledLayer {
            l.removeFromSuperlayer()
            filledLayer = nil
        }
    }
    
    open func redraw() {
        timerLayer?.setNeedsDisplay()
        filledLayer?.setNeedsDisplay()
        self.layer.setNeedsDisplay()
    }
    
    
}
