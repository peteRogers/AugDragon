 
import UIKit
import AVFoundation

final class CameraPreview: UIView {
  var previewLayer: AVCaptureVideoPreviewLayer {
    // swiftlint:disable:next force_cast
    layer as! AVCaptureVideoPreviewLayer
  }

  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }
}

//
//class DrawingLayer: CALayer {
//	override func draw(in ctx: CGContext) {
//		// Custom drawing code here
//		// You can use CGContext functions to draw on this layer
//		// For example, drawing a red circle in the center of the layer:
//		
//		ctx.setFillColor(UIColor.red.cgColor)
//		ctx.addEllipse(in: CGRect(x: bounds.midX - 25, y: bounds.midY - 25, width: 50, height: 50))
//		ctx.fillPath()
//	}
//}
