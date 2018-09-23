//
//  ViewController.swift
//  Camera
//
//  Created by Ting-Chun Yeh on 5/17/18.
//  Copyright © 2018 Ting-Chun Yeh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let captureSession = AVCaptureSession()
    
    @IBOutlet var videoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let authStatus = AVCaptureDevice.authorizationStatus(for:AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for:AVMediaType.video) {
                authorized in
                if authorized {
                    DispatchQueue.main.async {
                        self.displayCamera()
                    }
                } else {
                    print("Did not authorize")
                }
            }
        case .authorized:
            displayCamera()
        case .denied, .restricted:
            print("No access granted")
        }
    }
    
    func displayCamera() {
        
        // Select back-facing camera and its wide-angle camera
        let discoverySession =
            AVCaptureDevice.DiscoverySession(deviceTypes:
                [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let availableCameras = discoverySession.devices
        
        // If the camera is available, check the session receive output
        guard let backCamera = availableCameras.first,
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return }
        
        // Add the session
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Display the video output from the camera
        let preview = AVCaptureVideoPreviewLayer(session:captureSession)
        
        preview.frame = view.bounds
        
        // Display the video output
        videoView.layer.addSublayer(preview)
        
        // Start capturing the video output
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

