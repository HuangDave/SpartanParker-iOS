//
//  SegmentedController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/8/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

// MARK: -
protocol SegmentedControllerDelegate: class {
    
    func segmentedController(_ segmentedController: SegmentedController, didSelectSegmentAtIndex index: Int)
}

// MARK: -
@IBDesignable
class SegmentedController: UIControl {
    
    weak var delegate: SegmentedControllerDelegate?
    
    /// Holds and evenly distributes individual segment controls.
    private var stackView: UIStackView?
    /// Array of all segment controls.
    private var segments: [UIButton] = []
    /// Indicates the current selected segment.
    private var highlightIndicator: UIView?
    /// Used to move the position of the _highlightIndicator_.
    private var highlightIndicatorLeftConstraint: NSLayoutConstraint?
    
    /// Comma seperated list of titles for each segment.
    @IBInspectable var commaSeparatedTitles: String = " " {
        didSet { updateView() }
    }
    
    @IBInspectable var highlightColor: UIColor = UIColor.spartanBlue {
        didSet { highlightIndicator?.backgroundColor = highlightColor }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.spartanGray {
        didSet {
            segments.forEach { segment in
                segment.setTitleColor(titleColor, for: .normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    func updateView() {
        
        removeSegmentControls()
        generateSegmentControls()
        
        /// initialize _stackView_ and set layout constraints
        stackView = UIStackView(arrangedSubviews: segments)
        stackView!.axis = .horizontal
        stackView!.alignment = .fill
        stackView!.distribution = .fillEqually
        stackView!.spacing = 0.0
        addSubview(stackView!)
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        /// initialize _highLightIndicator_ and set layout constraints
        highlightIndicator = UIView()
        highlightIndicator!.backgroundColor = highlightColor
        addSubview(highlightIndicator!)
        highlightIndicator!.backgroundColor = highlightColor
        highlightIndicator!.translatesAutoresizingMaskIntoConstraints = false
        highlightIndicator!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        highlightIndicator!.widthAnchor.constraint(equalToConstant: (frame.width / CGFloat(segments.count))).isActive = true
        highlightIndicator!.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
        
        highlightIndicatorLeftConstraint = highlightIndicator!.leftAnchor.constraint(equalTo: leftAnchor)
        highlightIndicatorLeftConstraint!.constant = 0
        highlightIndicatorLeftConstraint!.isActive = true
    }
    
    private func removeSegmentControls() {
        segments.forEach { segment in
            segment.removeFromSuperview()
        }
        segments.removeAll()
        highlightIndicator?.removeFromSuperview()
        stackView?.removeFromSuperview()
    }
    
    private func generateSegmentControls() {
        
        let segmentTitles: [String] = commaSeparatedTitles.components(separatedBy: ",")
        for i in 0..<segmentTitles.count {
            let segment = UIButton(type: .system)
            segment.setTitle(segmentTitles[i], for: .normal)
            segment.setTitleColor(titleColor, for: .normal)
            segment.titleLabel!.textAlignment = .center
            segment.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18.0)
            segment.tag = i
            segment.addTarget(self, action: #selector(userDidTap), for: .touchUpInside)
            segments.append(segment)
        }
    }
    
    @IBAction @objc func userDidTap(segment: UIButton) {
        //UIView.anima
        delegate?.segmentedController(self, didSelectSegmentAtIndex: segment.tag)
    }
    
}
