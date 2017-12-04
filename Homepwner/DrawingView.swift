//
//  DrawableView.swift
//  Notey
//
//  Created by Ethan Schmalz on 10/20/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import Foundation
import UIKit

class DrawingView: UIView {
  
  @IBInspectable var lineWidth: CGFloat = 5.0
  
  private var path: UIBezierPath!
  private var currentPath_Array: [(UIColor, CGFloat, Bool, UIBezierPath)] = []
  private var previousPath_Array: [(UIColor, CGFloat, Bool, UIBezierPath)] = []
  private var isDrawing: Bool = true
  private var color: UIColor! = UIColor.black
  private var points = [CGPoint?](repeating: nil, count: 5)
  private var index: Int = 0
  private var layerArray = NSMutableArray()
  
  func clear() {
    currentPath_Array = []
    previousPath_Array = []
//    if (self.layer.sublayers != nil){
//        for layer in self.layer.sublayers! {
//            if (layerArray.contains(layer)){
//                layer.removeFromSuperlayer()
//                layerArray.remove(layer)
//            }
//        }
//    }
    setNeedsDisplay()
  }
    
    func drawCircle(sender: UITapGestureRecognizer){
        var touchLocation: CGPoint = sender.location(in: sender.view)
        touchLocation = self.convert(touchLocation, from: sender.view)
        
        
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: touchLocation.x,y: touchLocation.y), radius: 10, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: touchLocation.x,y: touchLocation.y), radius: 10, startAngle: -CGFloat(Double.pi/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: touchLocation.x,y: touchLocation.y), radius: 10, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: CGPoint(x: touchLocation.x,y: touchLocation.y), radius: 10, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        circlePath.close()
        
        
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: touchLocation.x ,y: touchLocation.y), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
//        
//        circlePath.lineWidth = lineWidth
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
//        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
//        shapeLayer.strokeColor = self.color.cgColor
        //you can change the line width
//        shapeLayer.lineWidth = self.lineWidth
        
//        layerArray.add(shapeLayer)
        
//        self.layer.addSublayer(shapeLayer)
        
        currentPath_Array.append((color, lineWidth, isDrawing, circlePath))

        setNeedsDisplay()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawingView.clear))
        longPressRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(longPressRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(DrawingView.drawCircle(sender:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
    }
	
    
  func changeColor(color: UIColor) {
    self.color = color
  }
  
  func undo() {
    guard currentPath_Array.last != nil else {
      return
    }
    previousPath_Array.append(currentPath_Array.last!)
    currentPath_Array.removeLast()
    setNeedsDisplay()
  }
  
  func redo() {
    guard previousPath_Array.last != nil else {
      return
    }
    currentPath_Array.append(previousPath_Array.last!)
    previousPath_Array.removeLast()
    setNeedsDisplay()
  }
  
  func drawOrErase(isDrawing: Bool) {
    self.isDrawing = isDrawing
  }
  
  override func awakeFromNib() {
    backgroundColor = UIColor.clear
    isMultipleTouchEnabled = false
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    for pathProperties in currentPath_Array {
      let color = pathProperties.0
      let width = pathProperties.1
      let isDrawing = pathProperties.2
      let path = pathProperties.3
      color.setStroke()
      path.lineWidth = width
      path.lineCapStyle = .round
      path.stroke(with: isDrawing ? .normal : .clear, alpha: 1.0)
    }
  }
  
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    path = UIBezierPath()
    previousPath_Array = []
    currentPath_Array.append((color, lineWidth, isDrawing, path))
    let point = touches.first?.location(in: self)
    index = 0
    points[index] = point
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    let point = touches.first?.location(in: self)
    index += 1
    points[index] = point
    if index == points.count - 1 {
      points[3] = CGPoint(x: (points[2]!.x + points[4]!.x) / 2.0,
                          y: (points[2]!.y + points[4]!.y) / 2.0)
      path.move(to: points[0]!)
      path.addCurve(to: points[3]!, controlPoint1: points[1]!, controlPoint2: points[2]!)
      setNeedsDisplay()
      points[0] = points[3]
      points[1] = points[4]
      index = 1
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard touches.first != nil else {
      return
    }
    setNeedsDisplay()
    index = 0
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
}

extension UIView {
    
    func createImage() -> UIImage {
        
        let rect: CGRect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
        
    }
    
}
