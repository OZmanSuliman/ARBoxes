//
// MediumBox.swift
// GENERATED CONTENT. DO NOT EDIT.
//

import Foundation
import RealityKit
import simd
import Combine

@available(iOS 13.0, macOS 10.15, *)
public enum MediumBox {

    public class NotifyAction {

        public let identifier: Swift.String

        public var onAction: ((RealityKit.Entity?) -> Swift.Void)?

        private weak var root: RealityKit.Entity?

        fileprivate init(identifier: Swift.String, root: RealityKit.Entity?) {
            self.identifier = identifier
            self.root = root

            Foundation.NotificationCenter.default.addObserver(self, selector: #selector(actionDidFire(notification:)), name: Foundation.NSNotification.Name(rawValue: "RealityKit.NotifyAction"), object: nil)
        }

        deinit {
            Foundation.NotificationCenter.default.removeObserver(self, name: Foundation.NSNotification.Name(rawValue: "RealityKit.NotifyAction"), object: nil)
        }

        @objc
        private func actionDidFire(notification: Foundation.Notification) {
            guard let onAction = onAction else {
                return
            }

            guard let userInfo = notification.userInfo as? [Swift.String: Any] else {
                return
            }

            guard let scene = userInfo["RealityKit.NotifyAction.Scene"] as? RealityKit.Scene,
                root?.scene == scene else {
                    return
            }

            guard let identifier = userInfo["RealityKit.NotifyAction.Identifier"] as? Swift.String,
                identifier == self.identifier else {
                    return
            }

            let entity = userInfo["RealityKit.NotifyAction.Entity"] as? RealityKit.Entity

            onAction(entity)
        }

    }

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadBox() throws -> MediumBox.Box {
        guard let realityFileURL = Bundle.module.url(forResource: "Scenes/MediumBox", withExtension: "reality") else {
            throw MediumBox.LoadRealityFileError.fileNotFound("MediumBox.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let anchorEntity = try MediumBox.Box.loadAnchor(contentsOf: realityFileSceneURL)
        return createBox(from: anchorEntity)
    }

    public static func loadBoxAsync(completion: @escaping (Swift.Result<MediumBox.Box, Swift.Error>) -> Void) {
        guard let realityFileURL = Bundle.module.url(forResource: "Scenes/MediumBox", withExtension: "reality") else {
            completion(.failure(MediumBox.LoadRealityFileError.fileNotFound("MediumBox.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let loadRequest = MediumBox.Box.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(MediumBox.createBox(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createBox(from anchorEntity: RealityKit.AnchorEntity) -> MediumBox.Box {
        let box = MediumBox.Box()
        box.anchoring = anchorEntity.anchoring
        box.addChild(anchorEntity)
        return box
    }

    public class Box: RealityKit.Entity, RealityKit.HasAnchoring {

        public var steelBox: RealityKit.Entity? {
            return self.findEntity(named: "Steel Box")
        }



        public private(set) lazy var actions = MediumBox.Box.Actions(root: self)

        public class Actions {

            fileprivate init(root: RealityKit.Entity) {
                self.root = root
            }

            private weak var root: RealityKit.Entity?

            public private(set) lazy var tapped = MediumBox.NotifyAction(identifier: "tapped", root: root)

            public private(set) lazy var allActions = [ tapped ]

        }

    }

}
