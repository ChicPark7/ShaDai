//
//  AVAnimationComposer.swift
//  ShaDai
//
//  Created by lsylove on 2017. 7. 12..
//  Copyright © 2017년 WebLinkTest. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class AVAnimationComposer {
    
    var composition: AVMutableComposition
    
    var parentLayer = CALayer()
    
    var videoLayerPlaceholder = CALayer()
    
    var instruction = AVMutableVideoCompositionInstruction()
    
    var layerInstruction: AVMutableVideoCompositionLayerInstruction?
    
    init(_ composition: AVMutableComposition) {
        self.composition = composition
    }
    
    func compose(_ objLayer: [CALayer], animation: [CAAnimation], superConfig: ((CALayer) -> Void)? = nil) -> AVMutableVideoComposition {
        let videoSize = composition.naturalSize
        
        let frameRect = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        parentLayer.frame = frameRect
        videoLayerPlaceholder.frame = frameRect
        
        parentLayer.addSublayer(videoLayerPlaceholder)
        superConfig?(parentLayer)
        
        for i in 0..<Swift.min(objLayer.count, animation.count) {
            objLayer[i].add(animation[i], forKey: nil)
            parentLayer.addSublayer(objLayer[i])
        }
        
        let layerComposition = AVMutableVideoComposition()
        layerComposition.renderSize = videoSize
        layerComposition.frameDuration = CMTimeMake(1, 30)
        layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayerPlaceholder, in: parentLayer)
        
        let targetTrack = composition.tracks(withMediaType: AVMediaTypeVideo).first!
        layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: targetTrack)
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        instruction.layerInstructions = [layerInstruction!]
        layerComposition.instructions = [instruction]
        return layerComposition
    }
    
    func pointObject() -> CALayer {
        let videoSize = composition.naturalSize
        let parameter = Swift.min(videoSize.width, videoSize.height)
        let pointObject = CALayer()
        pointObject.backgroundColor = UIColor.yellow.cgColor
        pointObject.frame = CGRect(x: 0, y: 0, width: parameter / 24, height: parameter / 24)
        pointObject.cornerRadius = parameter / 48
        return pointObject
    }
    
    func textObject(_ label: String = "Test String") -> CALayer {
        let videoSize = composition.naturalSize
        let textObject = CATextLayer()
        textObject.backgroundColor = UIColor.red.cgColor
        textObject.string = label
        textObject.font = "Helvetica" as CFTypeRef
        textObject.fontSize = videoSize.height / 18
        textObject.alignmentMode = kCAAlignmentCenter
        textObject.frame = CGRect(x: 0, y: 0, width: videoSize.width / 2, height: videoSize.height / 12)
        return textObject
    }
}
