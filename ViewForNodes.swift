//
//  ViewForNodes.swift
//  PointTest
//
//  Created by Lir-x on 12.02.17.
//  Copyright © 2017 Lir-x. All rights reserved.
//

import UIKit

class ViewForNodes: UIView, PathDelegate {
    
    
    var path: Path?
    
    func setup() {
        self.path?.delegate = self
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewForNodes.addNode(sender:))))

    }
    
    init(frame: CGRect, path: Path) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.path = path
        self.path?.delegate = self
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewForNodes.addNode(sender:))))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext(),
            let path = self.path {
            ctx.setFillColor(UIColor(hue:0.55, saturation:0.53, brightness:0.96, alpha:1.00).cgColor)
            ctx.fill(rect)
            self.draw(path: path, context: ctx)
        }
        
    }
    
    func addNode(sender: UITapGestureRecognizer) {
        
        let position = sender.location(in: self)

        let name = "Name"
        
        if let path = self.path {
            
            
                path.add(node: Node(name: name , position: position)) }
        
    }
    
    func draw(path: Path, context: CGContext) {
        context.saveGState()
        
        context.setLineWidth(3)
        for part in path.partsOfPath {
            context.setStrokeColor(UIColor.blue.cgColor)
            context.move(to: part.sourse.position)
            context.addLine(to: part.destanation.position)
            context.strokePath()
            self.drawPoint(point: part.middlePoint, color: UIColor.green, context: context)
            self.drawPoint(point: part.sourse.position, color: UIColor.red, context: context)
        }
        
        context.restoreGState()
    }
    
    func drawPoint(point: CGPoint, color: UIColor, context: CGContext) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(3)
        context.addArc(center: point, radius: 4, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        context.strokePath()
    }


    
    private func draw(node: Node, context: CGContext) {
        context.saveGState()
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.addArc(center: node.position,
                       radius: 5,
                       startAngle: 0,
                       endAngle: CGFloat.pi * 2,
                       clockwise: true)
        
        context.strokePath()
        
        context.restoreGState()
    }
    // MARK: PathDelegate
    
    func nodeHasBeenAddedOnPath(path: Path, node: Node) {
        self.setNeedsDisplay()
    }
    func partOfPathHasBeenSplitted(path: Path, oldEdge: Edge, newEdges: [Edge], byNode: Node) {
        
    }
    
    func nodeHasBeenRemovedOnPath(path: Path, node: Node) {
        self.setNeedsDisplay()
    }
    
    func nodeHasBeenEditedOnPath(path: Path, node: Node) {
        self.setNeedsDisplay()
    }
    
}
