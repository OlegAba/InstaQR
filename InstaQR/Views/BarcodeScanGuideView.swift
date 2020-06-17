//
//  BarcodeScanGuideView.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

class BarcodeScanGuideView: UIView {
    
    // MARK: - Internal Properties
    
    var color = UIColor.white {
        didSet { roundedRectOutlineShapeLayer.strokeColor = color.cgColor }
    }
    
    var text: String? {
        didSet {
            instructionsLabel.text = text
            layoutSubviews()
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate lazy var roundedRectShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillRule = .evenOdd
        return shapeLayer
    }()
    
    fileprivate lazy var roundedRectOutlineShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    fileprivate lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifetime
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(System.shared.globalOpacity)
        clipsToBounds = true
        layer.mask = roundedRectShapeLayer
        layer.addSublayer(roundedRectOutlineShapeLayer)
        addSubview(instructionsLabel)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        if bounds.size == .zero { return }
        
        roundedRectShapeLayer.frame = bounds
        roundedRectOutlineShapeLayer.frame = bounds
        
        let length: CGFloat = bounds.width * 0.7
        let x: CGFloat = (bounds.width * 0.3) / 2.0
        let y: CGFloat = (bounds.height - length) / 2.0
        let cornerRadius = System.shared.globalCornerRadius
        
        let rectPath = CGMutablePath()
        rectPath.addRoundedRect(in: CGRect(x: x, y: y, width: length, height: length), cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        rectPath.addRect(CGRect(origin: .zero, size: bounds.size))
        roundedRectShapeLayer.path = rectPath
        
        let rectOutlinePath = CGMutablePath()
        rectOutlinePath.addRoundedRect(in: CGRect(x: x, y: y, width: length, height: length), cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        roundedRectOutlineShapeLayer.path = rectOutlinePath
        
        let inset = System.shared.globalInset
        instructionsLabel.frame.size.width = length - (inset * 2.0)
        instructionsLabel.sizeToFit()
        instructionsLabel.center.x = center.x
        instructionsLabel.frame.origin.y = y - (inset * 3.0)
    }
}
