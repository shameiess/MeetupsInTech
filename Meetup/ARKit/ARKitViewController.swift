//
//  ARKitViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 9/27/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//
//  Tutorial reference: http://dayoftheindie.com/tutorials/3d-games-graphics/tutorial-intro-arkit-scenekit/
//  TODO : Shoot objects 



import UIKit
import SceneKit
import ARKit

@available(iOS 11.0, *)
class ARKitViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var backLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/dragon/main.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        loadDragon()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backLabel.isUserInteractionEnabled = true
        backLabel.addGestureRecognizer(tap)
    }
    
    var dragonNode: SCNNode!
    
    func loadDragon() {
        let dragonScene = SCNScene(named: "art.scnassets/dragon/dragon.scn")!
        dragonNode =  dragonScene.rootNode.childNode(withName: "dragon", recursively: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            // Touch to 3D Object
            if let hit = sceneView.hitTest(touchLocation, options: nil).first {
                hit.node.removeFromParentNode()
                return
            }
            
            // Touch to Feature Point
            if let hit = sceneView.hitTest(touchLocation, types: .featurePoint).first {
                sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Clone a new dragon
        let dragonClone = dragonNode.clone()
        dragonClone.position = SCNVector3Zero
        
        // Add dragon as a child of node
        node.addChildNode(dragonClone)
        
        // Constrain dragon to camera pov
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        constraint.influenceFactor = 0.01
        node.constraints = [constraint]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func dismiss(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}


