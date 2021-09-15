//
//  ViewController.swift
//  boxes
//
//  Created by Osman Solomon on 13/09/2021.
//

import RealityKit
import UIKit

public class ARBoxes: UIViewController {
    @IBOutlet var arView: ARView!
    @IBOutlet var selectorCollectionView: UICollectionView!
    
    var largeBoxAnchor: LargeBox.Box!
    var mediumBoxAnchor: MediumBox.Box!
    var smallBoxAnchor: SmallBox.Box!
    
    var selectorData = [String]()
    var selectedIndex = 0
    public static let storyboardVC = UIStoryboard(name: "Main", bundle: Bundle.module).instantiateInitialViewController()!
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        largeSceneSetup()
        mediumSceneSetup()
        smallSceneSetup()
        selectorData = ["SMALL BOX", "MEDIUM BOX", "LARGE BOX"]
        addScene(scene: selectorData[0])
    }

    @IBAction func rightButtonTapped(_ sender: Any) {
        if selectedIndex < selectorData.count - 1 {
            selectedIndex += 1
            selectorCollectionView.reloadData()
        }
    }

    @IBAction func leftButtonTapped(_ sender: Any) {
        if selectedIndex > 0 {
            selectedIndex -= 1
            selectorCollectionView.reloadData()
        }
    }
}

extension ARBoxes {
    // MARK: - Scene Setup

    func largeSceneSetup() {
        // Load the "Box" scene from the "LargeBox" Reality File
        largeBoxAnchor = try! LargeBox.loadBox()
        // Generate Collision To Receive User Interactions
        largeBoxAnchor.generateCollisionShapes(recursive: true)
    }
    
    func mediumSceneSetup() {
        // Load the "Box" scene from the "LargeBox" Reality File
        mediumBoxAnchor = try! MediumBox.loadBox()
        // Generate Collision To Receive User Interactions
        mediumBoxAnchor.generateCollisionShapes(recursive: true)
    }
    
    func smallSceneSetup() {
        // Load the "Box" scene from the "LargeBox" Reality File
        smallBoxAnchor = try! SmallBox.loadBox()
        // Generate Collision To Receive User Interactions
        smallBoxAnchor.generateCollisionShapes(recursive: true)
    }
    
    func addScene(scene: String) {
        arView.scene.anchors.removeAll()
        switch scene {
        case "SMALL BOX":
            arView.scene.anchors.append(smallBoxAnchor)
        case "MEDIUM BOX":
            arView.scene.anchors.append(mediumBoxAnchor)
        case "LARGE BOX":
            arView.scene.anchors.append(largeBoxAnchor)
        default:
            break
        }
    }
}
 
extension ARBoxes: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectorData.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectorCollectionView.reloadData()
        addScene(scene: selectorData[indexPath.row])
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectorCollectionViewCell", for: indexPath) as? SelectorCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        cell.setUpView(isSelected: indexPath.row == selectedIndex, text: selectorData[indexPath.row])
        return cell
    }
}

extension ARBoxes: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 1.0, left: 11.0, bottom: 1.0, right: 11.0)
    }
 
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
//             the number 3 representing number of items in screen
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: 128)
    }
}
 
