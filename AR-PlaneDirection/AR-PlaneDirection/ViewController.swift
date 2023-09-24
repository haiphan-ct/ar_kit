//
//  ViewController.swift
//  AR-PlaneDirection
//
//  Created by Hai Phan Thanh on 16/09/2023.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
//        let lavaNode = createLava()
//        sceneView.scene.rootNode.addChildNode(lavaNode)
    }
    
    private func createLava(arplaneAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode(geometry: SCNPlane(width: CGFloat(arplaneAnchor.extent.x),
                                              height: CGFloat(arplaneAnchor.extent.z)))
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "lava")
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(arplaneAnchor.center.x, arplaneAnchor.center.y, arplaneAnchor.center.z)
        node.eulerAngles = SCNVector3(90.degreeToRadians, 0, 0)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planceAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let lavaNode = createLava(arplaneAnchor: planceAnchor)
        node.addChildNode(lavaNode)
        print("add new plane anchor")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planceAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        node.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        let lavaNode = createLava(arplaneAnchor: planceAnchor)
        node.addChildNode(lavaNode)
        print("didUpdate plane anchor")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planceAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        node.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        print("remove plane anchor")
    }


}

extension Int {
    
    var degreeToRadians: Double { return Double(self) * .pi/180 }
}
