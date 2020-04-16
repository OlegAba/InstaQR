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
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: x, y: y, width: length, height: length), cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        path.addRect(CGRect(origin: .zero, size: frame.size))
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.black.cgColor
        shapeLayer.path = path
        shapeLayer.fillRule = .evenOdd
        return shapeLayer
    }()
    
    fileprivate lazy var roundedRectOutlineShapeLayer: CAShapeLayer = {
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: x, y: y, width: length, height: length), cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.frame = self.bounds
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
    
    fileprivate lazy var length: CGFloat = frame.width * 0.7
    fileprivate lazy var x: CGFloat = (frame.width * 0.3) / 2.0
    fileprivate lazy var y: CGFloat = (frame.height - length - 57) / 2.0
    fileprivate let cornerRadius = System.shared.globalCornerRadius
    
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
        let inset = System.shared.globalInset
        instructionsLabel.frame.size.width = length - (inset * 2.0)
        instructionsLabel.sizeToFit()
        instructionsLabel.center.x = center.x
        instructionsLabel.frame.origin.y = y - (inset * 3.0)
    }
    
    // MARK: - Setup
    
    func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        clipsToBounds = true
        layer.mask = roundedRectShapeLayer
        layer.addSublayer(roundedRectOutlineShapeLayer)
        addSubview(instructionsLabel)
    }
}
