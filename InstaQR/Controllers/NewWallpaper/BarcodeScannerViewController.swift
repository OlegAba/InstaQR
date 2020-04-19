//
//  BarcodeScannerViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeScannerDelegate {
    func barcodeScannerShouldDismiss(_ barcodeScannerViewController: BarcodeScannerViewController, error: Bool)
    func barcodeScannerCodeFound(_ barcodeScannerViewController: BarcodeScannerViewController, codeData: String)
}

class BarcodeScannerViewController: ViewController {
    
    // MARK: - Internal Properties
    
    var delegate: BarcodeScannerDelegate!
    var instructionText = "Scan QR Barcode"
    
    // MARK: - Private Properties
    
    fileprivate lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem()
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonWasTapped))
        navItem.rightBarButtonItem = cancelBarButtonItem
        navigationBar.setItems([navItem], animated: false)
        return navigationBar
    }()
    
    fileprivate lazy var captureSession: AVCaptureSession? = {
        let avCaptureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return nil }
        if !avCaptureSession.canAddInput(videoInput) { return nil }
        avCaptureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if !avCaptureSession.canAddOutput(metadataOutput) { return nil }
        avCaptureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        return avCaptureSession
    }()
    
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        if self.captureSession == nil { failed() }
        let captureSession = self.captureSession ?? AVCaptureSession()
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoPreviewLayer.frame = view.frame
        captureVideoPreviewLayer.videoGravity = .resizeAspectFill
        return captureVideoPreviewLayer
    }()
    
    fileprivate lazy var barcodeScanGuideView: BarcodeScanGuideView = {
        let scanGuideView = BarcodeScanGuideView(frame: view.frame)
        scanGuideView.text = instructionText
        scanGuideView.isHidden = true
        scanGuideView.translatesAutoresizingMaskIntoConstraints = false
        return scanGuideView
    }()
    
    fileprivate lazy var captureVideoPermissionHandlerView: PermissionHandlerView = {
        let permissionHandlerVideo = PermissionHandlerView()
        permissionHandlerVideo.permissionType = .cameraUsage
        permissionHandlerVideo.addAccessButtonTarget(self, action: #selector(permissionAccessButtonWasTapped), for: .touchUpInside)
        permissionHandlerVideo.isHidden = true
        permissionHandlerVideo.translatesAutoresizingMaskIntoConstraints = false
        return permissionHandlerVideo
    }()
    
    fileprivate lazy var flashButton: FlashButton = {
        let flashButton = FlashButton()
        flashButton.isHidden = true
        flashButton.addTarget(self, action: #selector(flashButtonWasTapped), for: .touchUpInside)
        return flashButton
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRequisiteViews(for: AVCaptureDevice.authorizationStatus(for: .video))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if let captureSession = captureSession, !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if let captureSession = captureSession, captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(captureVideoPermissionHandlerView)
        view.addSubview(barcodeScanGuideView)
        view.addSubview(flashButton)
        view.addSubview(navigationBar)
    }
    
    fileprivate func setupRequisiteViews(for authorizationStatus: AVAuthorizationStatus) {
        
        switch authorizationStatus {
            
        case .authorized:
            view.layer.addSublayer(previewLayer)
            barcodeScanGuideView.isHidden = false
            view.bringSubviewToFront(barcodeScanGuideView)
            flashButton.isHidden = false
            view.bringSubviewToFront(flashButton)
            view.bringSubviewToFront(navigationBar)
            
        case .denied, .restricted:
            captureVideoPermissionHandlerView.buttonType = .settings
            captureVideoPermissionHandlerView.isHidden = false
            
        case .notDetermined:
            captureVideoPermissionHandlerView.buttonType = .access
            captureVideoPermissionHandlerView.isHidden = false
            
        default:
            break
        }
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            captureVideoPermissionHandlerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            captureVideoPermissionHandlerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            captureVideoPermissionHandlerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            captureVideoPermissionHandlerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            barcodeScanGuideView.topAnchor.constraint(equalTo: view.topAnchor),
            barcodeScanGuideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barcodeScanGuideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barcodeScanGuideView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            flashButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.layoutMargins.left * 2.0)),
            flashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    fileprivate func failed() {
        captureSession = nil
        delegate.barcodeScannerShouldDismiss(self, error: true)
    }
    
    // MARK: - Actions
    
    @objc fileprivate func cancelButtonWasTapped() {
        delegate.barcodeScannerShouldDismiss(self, error: false)
    }
    
    @objc fileprivate func permissionAccessButtonWasTapped() {
        captureVideoPermissionHandlerView.isHidden = true
        
        AVCaptureDevice.requestAccess(for: .video) { (success: Bool) in
            DispatchQueue.main.async {
                if success {
                    self.setupRequisiteViews(for: .authorized)
                    self.captureSession?.startRunning()
                } else {
                    self.setupRequisiteViews(for: .denied)
                }
            }
        }
    }
    
    @objc fileprivate func flashButtonWasTapped() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        guard ((try? device.lockForConfiguration()) != nil) else { return }
        
        if (device.torchMode == AVCaptureDevice.TorchMode.on) {
            device.torchMode = AVCaptureDevice.TorchMode.off
            flashButton.stateType = .off
        } else {
            guard ((try? device.setTorchModeOn(level: 1.0)) != nil) else { return }
            flashButton.stateType = .on
        }
        
        device.unlockForConfiguration()
    }
    
    // MARK: - Internal Methods
    
    func success() {
        barcodeScanGuideView.color = .systemGreen
        guard let captureSession = captureSession else { return }
        captureSession.stopRunning()
        System.shared.triggerFeedbackGenerator()
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BarcodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            delegate.barcodeScannerCodeFound(self, codeData: stringValue)
        }
    }
}
