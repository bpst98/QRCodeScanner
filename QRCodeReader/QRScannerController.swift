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
//----------Finding camera within the device---------------------------------------------

        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first
            else{
                print("Camera Not detetced")
                return}
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch{
            print("Error Not RECOGNIZING")
            return
        }
        
 //---------------------------------------------------------------------
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
        
        
    }
//==============================================================
    

    
}
