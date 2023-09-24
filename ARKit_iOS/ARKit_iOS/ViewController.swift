//
//  ViewController.swift
//  ARKit_iOS
//
//  Created by Hai Phan Thanh on 04/09/2023.
//

import UIKit

enum ARType: Int {
    case draw, hitTest, ikea, planeDirection, textureSurface, physics, vehicle, distanceMeasurement, portal, baseketBall, collision
}

enum BaseShapeType: Int {
    case box, capsule, cone, cylinder, plane, pyramid, sphere, tour, tube, cusstom
}

class ViewController: UIViewController {
    
    let baseShape = ["SCNBox", "SCNCapsule", "SCNCone", "SCNCylinder", "SCNPlane", "SCNPyramid", "SCNSphere", "SCNTour", "SCNTube", "Custom with UIBezierPath"]
    let arType = ["Draw", "Hit-Test", "IKEA", "Plane Direction", "Texture & Surface", "physics", "vehicle", "distance measurement", "portal", "baseketBall", "collision"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return baseShape.count
        }
        return arType.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
            cell.textLabel?.text = baseShape[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
            cell.textLabel?.text = arType[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let shapeType = BaseShapeType(rawValue: indexPath.row),
           indexPath.section == 0 {
            let shapeVC = BaseShapeViewController.createVC()
            shapeVC.shapeType = shapeType
            self.navigationController?.pushViewController(shapeVC, animated: true)
        }
        
        if let type = ARType(rawValue: indexPath.row), indexPath.section == 1 {
            switch type {
            case .draw:
                let shapeVC = DrawViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .textureSurface:
                let shapeVC = TextureViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .planeDirection:
                let shapeVC = PlaneDirectionViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .hitTest:
                let shapeVC = HitTestViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .ikea:
                let shapeVC = IKEAViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .physics:
                let shapeVC = PhysicsViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .vehicle:
                let shapeVC = VehicleViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .distanceMeasurement:
                let shapeVC = DistanceViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .portal:
                let shapeVC = PortalViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .baseketBall:
                let shapeVC = BaseketBallViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            case .collision:
                let shapeVC = CollisionsViewController.createVC()
                self.navigationController?.pushViewController(shapeVC, animated: true)
            default: break
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Base Shape"
        }
        return "AR - Type"
    }
    
}
//
//  ViewControllerExtension.swift
//  Dayshee
//
//  Created by haiphan on 10/30/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import UIKit

protocol Weakifiable: AnyObject {}
extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            code(arg, self)
        }
    }
}
extension UIViewController: Weakifiable {}
extension UIViewController {
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
    }
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
    static func createVCfromStoryBoard() -> Self {
        let vc = UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier:  "\(self)") as! Self
        return vc
    }
    
    static func createVCfromStoryBoard(storyboard: String) -> Self {
        let vc = UIStoryboard(name: "\(storyboard)", bundle: nil).instantiateViewController(withIdentifier:  "\(self)") as! Self
        return vc
    }
    
    static func createVC() -> Self {
        let vc = Self.init(nibName: "\(self)", bundle: nil)
        return vc
    }
    
}


extension UIView {
    static var nib: UINib? {
        let bundle = Bundle(for: self)
        let name = "\(self)"
        guard bundle.path(forResource: name, ofType: "nib") != nil else {
            return nil
        }
        return UINib(nibName: name, bundle: nil)
    }
    
    
    static var identifier: String {
        return "\(self)"
    }
}

protocol LoadXibProtocol {}
extension LoadXibProtocol where Self: UIView {
    static func loadXib() -> Self {
        let bundle = Bundle(for: self)
        let name = "\(self)"
        guard let view = UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("error xib \(name)")
        }
        return view
    }
}
extension UIView: LoadXibProtocol {}
