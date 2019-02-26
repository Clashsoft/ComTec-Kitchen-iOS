//
//  ScanViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-26.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	@IBOutlet weak var infoLabel: UILabel!

	var captureSession: AVCaptureSession!
	var videoPreviewLayer: AVCaptureVideoPreviewLayer!
	var qrCodeFrameView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()

		captureSession = AVCaptureSession()

		// Device Setup

		let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)

		guard let captureDevice = deviceDiscoverySession.devices.first
		else {
			print("failed to get the camera device")
			return
		}

		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)

			captureSession.addInput(input)
		}
		catch {
			print(error)
			return
		}

		// Output Capture

		let captureMetadataOutput = AVCaptureMetadataOutput()
		captureSession.addOutput(captureMetadataOutput)

		captureMetadataOutput.metadataObjectTypes = [
			.upce,
			.code39,
			.code39Mod43,
			.ean13,
			.ean8,
			.code39,
			.code128
		]

		captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

		// Video Preview Layer

		videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		videoPreviewLayer.videoGravity = .resizeAspectFill
		videoPreviewLayer.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer)

		// Initialize Code Highlight Frame

		qrCodeFrameView = UIView()
		qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
		qrCodeFrameView.layer.borderWidth = 2
		view.addSubview(qrCodeFrameView)
		view.bringSubviewToFront(qrCodeFrameView)

		// Initialize Message Label

		infoLabel.text = nil
		view.bringSubviewToFront(infoLabel)
	}

	override func viewWillAppear(_ animated: Bool) {
		captureSession.startRunning()
	}

	override func viewDidDisappear(_ animated: Bool) {
		captureSession.stopRunning()
	}

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if metadataObjects.isEmpty {
			qrCodeFrameView.frame = .zero
			infoLabel.text = "No Barcode detected"
			return
		}

		guard let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
		else {
			return
		}

		infoLabel.text = metadataObject.stringValue

		if let frameObject = videoPreviewLayer.transformedMetadataObject(for: metadataObject) {
			qrCodeFrameView.frame = frameObject.bounds
		}
	}
}
