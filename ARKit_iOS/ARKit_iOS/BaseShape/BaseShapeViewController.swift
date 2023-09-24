//
//  BaseShapeViewController.swift
//  ARKit_iOS
//
//  Created by Hai Phan Thanh on 24/09/2023.
//

import UIKit
import ARKit

class BaseShapeViewController: UIViewController {

    var shapeType: BaseShapeType = .box
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var doorNode = SCNNode()
        switch shapeType {
        case .box:
            doorNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 1)
        case .capsule:
            doorNode.geometry = SCNCapsule(capRadius: 0.1, height: 0.1)
        case .cone:
            doorNode.geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.1, height: 0.1)
        case .cusstom:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x:0, y: 0.2))
            path.addLine(to: CGPoint(x: 0.2, y:0.3))
            path.addLine(to: CGPoint(x: 0.4, y: 0.2))
            path.addLine(to: CGPoint(x: 0.4, y: 0))
            let shape = SCNShape(path: path, extrusionDepth: 0.2)
            doorNode.geometry = shape
        case .cylinder:
            doorNode.geometry = SCNCylinder(radius: 0.1, height: 0.1)
        case .plane:
            doorNode.geometry = SCNPlane(width: 0.1, height: 0.1)
        case .pyramid:
            doorNode.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        case .sphere:
            doorNode.geometry = SCNSphere(radius: 0.1)
        case .tour:
            doorNode.geometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.1)
        case .tube:
            doorNode.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.1, height: 0.1)
        default: break
        }
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        doorNode.geometry?.firstMaterial?.specular.contents = UIColor.orange
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        doorNode.position = SCNVector3(0, -0.02, 0.053)
        self.sceneView.scene.rootNode.addChildNode(doorNode)
    }
}
extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
