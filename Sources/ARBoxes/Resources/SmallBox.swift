//
// SmallBox.swift
// GENERATED CONTENT. DO NOT EDIT.
//

import Combine
import Foundation
import RealityKit
import simd

@available(iOS 13.0, macOS 10.15, *)
public enum SmallBox {
    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadBox() throws -> SmallBox.Box {
        guard let realityFileURL = Bundle.module.url(forResource: "Scenes/SmallBox", withExtension: "reality") else {
            throw SmallBox.LoadRealityFileError.fileNotFound("SmallBox.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let anchorEntity = try SmallBox.Box.loadAnchor(contentsOf: realityFileSceneURL)
        return createBox(from: anchorEntity)
    }

    public static func loadBoxAsync(completion: @escaping (Swift.Result<SmallBox.Box, Swift.Error>) -> Void) {
        guard let realityFileURL = Bundle.module.url(forResource: "Scenes/SmallBox", withExtension: "reality") else {
            completion(.failure(SmallBox.LoadRealityFileError.fileNotFound("SmallBox.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Box", isDirectory: false)
        let loadRequest = SmallBox.Box.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(SmallBox.createBox(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createBox(from anchorEntity: RealityKit.AnchorEntity) -> SmallBox.Box {
        let box = SmallBox.Box()
        box.anchoring = anchorEntity.anchoring
        box.addChild(anchorEntity)
        return box
    }

    public class Box: RealityKit.Entity, RealityKit.HasAnchoring {
        public var steelBox: RealityKit.Entity? {
            return findEntity(named: "Steel Box")
        }
    }
}
