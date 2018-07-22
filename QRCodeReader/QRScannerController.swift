//
//  QRScannerController.swift
//  QRCodeReader
//
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var QRCodeFrameView : UIView?
    
//==============================================================
    override func viewDidLoad() {
//---------------------------------------------------------------------
        super.viewDidLoad()
//Finding camera within the device
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
        }
        catch {
           
            print(error)
            return
        }
        
//output device to capture the session
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
// setting the captureMetaDataOutput delegate
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
// assigning to scan for QR
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//to display the video captured by the device’s camera on screen
     
       
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        videoPreviewLayer?.frame = view.layer.bounds
       
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()  //--start video capture
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)
        
        QRCodeFrameView = UIView()
        
        if let qrCodeFrameView = QRCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                QRCodeFrameView?.frame = CGRect.zero
                messageLabel.text = "No QR code is detected"
                return
            }
            
            // Get the metadata object.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                QRCodeFrameView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    messageLabel.text = metadataObj.stringValue
                }
            }
        }
        
        
        
    }
//==============================================================
    

    
}
