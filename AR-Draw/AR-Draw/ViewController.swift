//
//  ViewController.swift
//  AR-Draw
//
//  Created by Hai Phan Thanh on 10/09/2023.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneKit: ARSCNView!
    let ocnfiguration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sceneKit.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        self.sceneKit.showsStatistics = true
        self.sceneKit.session.run(ocnfiguration)
        self.sceneKit.delegate = self
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneKit.pointOfView else { return }
        let transform = pointOfView.transform
        //M31 is column three row 1
        //11 12 13
        //21 22 23
        //31 32 33
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let currentPositionOfCamera = orientation + location
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneKit.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            } else {
//                let poniter = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
                let poniter = SCNNode(geometry: SCNSphere(radius: 0.01))
                poniter.name = "pointer"
                poniter.position = currentPositionOfCamera
                self.sceneKit.scene.rootNode.enumerateChildNodes { node, _ in
//                    if node.geometry is SCNBox {
//                        node.removeFromParentNode()
//                    }
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                self.sceneKit.scene.rootNode.addChildNode(poniter)
                poniter.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
       
    }

}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

