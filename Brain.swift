//
//  Brain.swift
//  PointTest
//
//  Created by Lir-x on 12.02.17.
//  Copyright © 2017 Lir-x. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    func minIndex(objects: [Element]) -> Int? {
        var i = [Int]()
        for object in objects {
            if let index = index(of: object) {
                i.append(index)
            }
        }
        return i.min()
    }
}

func distanceBetween(p1: CGPoint, p2: CGPoint) -> Float {
    let x = (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)
    return sqrtf(Float(x))
}
func distanceBetween(node1: Node, node2: Node) -> Float {
    return distanceBetween(p1: node1.position, p2: node2.position)
}
func heightToEdge(nodeA: Node, edge: Edge) -> Float {
    let nodeB = edge.sourse
    let nodeC = edge.destanation
    
    let ab = distanceBetween(node1: nodeA, node2: nodeB)
    let ac = distanceBetween(node1: nodeA, node2: nodeC)
    let bc = edge.distance
    let p = (ab + ac + bc) / 2
    let x = p * (p - bc) * (p - ac) * (p - ab)
    let res = (2/bc) * sqrtf(x)
    
    return res
}

func distanceFromPoint(p: CGPoint, toLineSegment l1: CGPoint, and l2: CGPoint) -> CGFloat {
    let A = p.x - l1.x
    let B = p.y - l1.y
    let C = l2.x - l1.x
    let D = l2.y - l1.y
    
    let dot = A * C + B * D
    let len_sq = C * C + D * D
    let param = dot / len_sq
    
    var xx, yy: CGFloat
    
    if param < 0 || (l1.x == l2.x && l1.y == l2.y) {
        xx = l1.x
        yy = l1.y
    } else if param > 1 {
        xx = l2.x
        yy = l2.y
    } else {
        xx = l1.x + param * C
        yy = l1.y + param * D
    }
    
    let dx = p.x - xx
    let dy = p.y - yy
    
    return sqrt(dx * dx + dy * dy)
}

func distanceFromNode(node: Node, toEdge e: Edge) -> Float {
    return Float(distanceFromPoint(p: node.position, toLineSegment: e.sourse.position, and: e.destanation.position))
}
protocol LXNode: Equatable {
    var name: String {get}
    var position: CGPoint {get}
    
}

protocol NodeDelegate {
    func nodeDidMoved(node: Node, oldPosition: CGPoint, toPosition: CGPoint)
    func nodeDidRenamed(node: Node, oldName: String, newName: String)
}
protocol PathDelegate {
    func nodeHasBeenAddedOnPath(path: Path, node: Node)
    func nodeHasBeenEditedOnPath(path: Path, node: Node)
    func nodeHasBeenRemovedOnPath(path: Path, node: Node)
    func partOfPathHasBeenSplitted(path: Path, oldEdge: Edge, newEdges: [Edge], byNode: Node)
}

class RouteModel {
    
    var name: String
    var distance: Float
    
    
    
    init(name: String, distance: Float) {
        self.name = name
        self.distance = distance
    }
}

class Node: LXNode {
    
    var name: String {
        didSet{
            self.delegate?.nodeDidRenamed(node: self, oldName: oldValue, newName: self.name)
        }
    }
    var position: CGPoint {
        didSet{
            self.delegate?.nodeDidMoved(node: self, oldPosition: oldValue, toPosition: self.position)
        }
    }
    var delegate: NodeDelegate?
    
    init(name: String, position: CGPoint) {
        self.name = name
        self.position = position
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.position == rhs.position
    }
}

class Edge: Equatable {
    var sourse: Node
    var destanation: Node
    var distance: Float {
        return distanceBetween(node1: self.sourse, node2: self.destanation)
        
    }
    
    var middlePoint: CGPoint {
        return CGPoint(x: (self.sourse.position.x + self.destanation.position.x) / 2,
                       y: (self.sourse.position.y + self.destanation.position.y) / 2)
    }
    init(sourse: Node, destanation: Node) {
        self.sourse = sourse
        self.destanation = destanation
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.sourse == rhs.sourse && lhs.destanation == rhs.destanation
    }
    
}
class Path: NodeDelegate {
    
    let firstNode: Node
    let lastNode: Node
    
    var partsOfPath: [Edge]
    
    var allNodes: [Node] {
        return self.partsOfPath.map({$0.sourse}) + [lastNode]
    }
    var distance: [Float] { return self.partsOfPath.map{$0.distance} + [Float(0)]}
    
    var delegate: PathDelegate?
    
    var totalDistance: Float {
        return self.partsOfPath.reduce(Float(0)) { (total: Float, edge: Edge) -> Float in
           return total + edge.distance
        }
    }
    
    init(first: Node, last: Node) {
        
        self.firstNode = first
        self.lastNode = last
        
        self.partsOfPath = [Edge(sourse: first, destanation: last)]
        
        for node in [self.firstNode, self.lastNode] {
            node.delegate = self
        }
    }
    
    init(first: Node, last: Node, moreNodes: [Node]) {
        self.firstNode = first
        self.lastNode = last
        self.partsOfPath = [Edge(sourse: first, destanation: last)]
        self.add(nodes:moreNodes.filter({$0 !== first || $0 !== last}))
        for node in moreNodes + [first, last] {
            node.delegate = self
        }
    }
    
    public func add(node: Node) {
        node.delegate = self
        let edge = nearestEdge(edges: self.partsOfPath, toNode: node)
        self.split(edge: edge, byNode: node)
        self.delegate?.nodeHasBeenAddedOnPath(path: self, node: node)
    }
    
    public func remove(node: Node) {
        node.delegate = nil
        let edge1 = self.partsOfPath.filter({ $0.sourse == node})[0]
        let edge2 = self.partsOfPath.filter({ $0.destanation == node})[0]
        edge2.destanation = edge1.destanation
        partsOfPath.remove(object: edge1)
        self.delegate?.nodeHasBeenRemovedOnPath(path: self, node: node)
    }
    
    public func add(nodes: [Node]) { for n in nodes { self.add(node: n) }}
    
    private func  nearestEdge(edges: [Edge], toNode: Node) -> Edge {
        
        return edges.min(by: { distanceFromNode(node: toNode, toEdge: $0.0) < distanceFromNode(node: toNode, toEdge: $0.1)})!
    }
    
    private func split(edge: Edge, byNode: Node) {
        let node1 = edge.sourse
        let node2 = byNode
        let node3 = edge.destanation
        let edge1 = Edge(sourse: node1, destanation: node2)
        let edge2 = Edge(sourse: node2, destanation: node3)
        if let index = self.partsOfPath.index(of: edge) {
            for newEdge in [edge2, edge1] {
                                self.partsOfPath.insert(newEdge, at: index)
            }
                        self.partsOfPath.remove(at: index + 2)
                        self.delegate?.partOfPathHasBeenSplitted(path: self, oldEdge: edge, newEdges: [edge2, edge1], byNode: byNode)
        }
    }
    
    // MARK: NodeDelegate
    
    func nodeDidRenamed(node: Node, oldName: String, newName: String) {
        self.delegate?.nodeHasBeenEditedOnPath(path: self, node: node)
    }
    
    func nodeDidMoved(node: Node, oldPosition: CGPoint, toPosition: CGPoint) {
        self.delegate?.nodeHasBeenEditedOnPath(path: self, node: node)
    }
    
}
