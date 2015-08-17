//
//  GradientView.swift
//  GradiView
//
//  Created by Hufei on 15/8/17.
//  Copyright (c) 2015年 Hufei. All rights reserved.
//

import UIKit
enum Direction{
  /** 水平方向 */  case horizontal
  /** 竖直方向 */  case vertical
  /** 斜上升 */    case assurgent
  /** 斜下降*/     case diagonal
}
@IBDesignable class GradientView: UIView {
    private let  maskLayer:CALayer = CALayer()
    @IBInspectable var colorsDirection: Direction = Direction.horizontal{
        didSet{
            switch colorsDirection{
            case .horizontal:
                starePoint = CGPointZero
                endPoint = CGPointMake(1.0, 0)
                break
            case .vertical:
                starePoint = CGPointZero
                endPoint = CGPointMake(0, 1.0)
            case .assurgent:
                starePoint = CGPointMake(0.0, 1.0)
                endPoint = CGPointMake(frame.width / frame.height, 0.0)
                break
            case .diagonal:
                starePoint = CGPointZero
                endPoint = CGPointMake(1.0, frame.height / frame.width)
            }
            setNeedsLayout()
        }
    }
    private var starePoint:CGPoint = CGPointZero
    private var endPoint:CGPoint = CGPointMake(1.0, 0.0)
    @IBInspectable var  progress:CGFloat = 0 {
        didSet{
            progress = min(1.0, fabs(progress))
            setNeedsLayout()
        }
    }
    /** from 0 to 1 */
    @IBInspectable var speed:CGFloat = 1.0{
        didSet{
            speed = max(0.0, min(1.0, fabs(speed)))
            setNeedsLayout()
        }
    
    }
    private var layerColors:[CGColor] = [CGColor]()
    //MARK: Override
    override func layoutSubviews() {
        var maskRect = maskLayer.frame
        maskRect.size.width = self.bounds.width * progress
        maskLayer.frame = maskRect
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = self.starePoint
        layer.endPoint = self.endPoint
    }
    override static func layerClass() -> AnyClass{
        return NSClassFromString("CAGradientLayer")
    }
    override  init(frame: CGRect) {
        super.init(frame: frame)
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = self.starePoint
        layer.endPoint = self.endPoint
        for  i in 0...36 {
            let color = UIColor(hue:CGFloat (10.0 * CGFloat(i) / 360.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.layerColors.append(color.CGColor)
        }
        layer.colors = self.layerColors
        self.maskLayer.frame = CGRectMake(0, 0, 0, frame.size.height)
        self.maskLayer.backgroundColor = UIColor.blackColor().CGColor
        layer.mask = self.maskLayer
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func performAnimation(){
        let layer = self.layer as! CAGradientLayer
        let lastColor = self.layerColors.removeLast()
        self.layerColors.insert(lastColor, atIndex: 0)
        let animation = CABasicAnimation(keyPath: "colors")
        animation.toValue = self.layerColors
        if 0 == speed {
            animation.duration = CFTimeInterval(Float.infinity)
        }
        else {
            animation.duration = CFTimeInterval(0.01/speed)
        }
        animation.removedOnCompletion = false
        animation.fillMode = "forwards"
        animation.delegate = self
        layer.addAnimation(animation, forKey: "animatedGradient")

    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let layer = self.layer as! CAGradientLayer
        layer.colors = self.layerColors
        performAnimation()
    }
}
