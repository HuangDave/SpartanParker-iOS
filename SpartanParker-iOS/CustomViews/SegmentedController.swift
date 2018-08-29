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
class SegmentedController: UIControl {
    
    static let defaultHeight: CGFloat = 44.0
    
    weak var delegate: SegmentedControllerDelegate?
    
    /// Holds and evenly distributes individual segment controls.
    private var stackView: UIStackView?
    
    /// Array of all segment controls.
    private(set) var segments: [UIButton] = []
    
    /// Indicates the current selected segment.
    private(set) var highlightIndicator: UIView = UIView()
    
    private var highlightIndicatorWidth:    NSLayoutConstraint?
    /// Used to move the position of the _highlightIndicator_.
    private var highlightIndicatorPosition: NSLayoutConstraint!
    
    /// Comma seperated list of titles for each segment.
    var commaSeparatedTitles: String = "" {
        didSet { updateView() }
    }
    
    var highlightColor: UIColor? {
        get { return highlightIndicator.backgroundColor     }
        set { highlightIndicator.backgroundColor = newValue }
    }
    
    var titleColor: UIColor = UIColor.spartanGray {
        didSet {
            segments.forEach { segment in
                segment.setTitleColor(titleColor, for: .normal)
            }
        }
    }
    
    private var segmentWidth: CGFloat {
        return frame.width / CGFloat(segments.count)
    }
    
    // MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        updateView()
    }
    
    func updateView() {
        
        invalidateView()
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
        stackView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let indicatorHeight: CGFloat = 6.0
        addSubview(highlightIndicator)
        highlightIndicator.translatesAutoresizingMaskIntoConstraints = false
        highlightIndicator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        highlightIndicator.heightAnchor.constraint(equalToConstant: indicatorHeight).isActive = true
        highlightIndicatorPosition = highlightIndicator.leftAnchor.constraint(equalTo: leftAnchor)
        highlightIndicatorPosition.isActive = true
        
        if highlightIndicatorWidth != nil {
            highlightIndicatorWidth!.isActive = false
            highlightIndicator.removeConstraint(highlightIndicatorWidth!)
        }
        highlightIndicatorWidth = highlightIndicator.widthAnchor.constraint(equalToConstant: segmentWidth)
        highlightIndicatorWidth!.isActive = true
    }
    
    func invalidateView() {
        removeSegmentControls()
    }
    
    private func removeSegmentControls() {
        segments.forEach { segment in
            segment.removeFromSuperview()
        }
        segments.removeAll()
        highlightIndicator.removeFromSuperview()
        stackView?.removeFromSuperview()
    }
    
    private func generateSegmentControls() {
        
        let segmentTitles: [String] = commaSeparatedTitles.components(separatedBy: ",")
        for i in 0..<segmentTitles.count {
            let segment = UIButton(type: .system)
            segment.setTitle(segmentTitles[i], for: .normal)
            segment.setTitleColor(titleColor, for: .normal)
            segment.titleLabel!.textAlignment = .center
            segment.titleLabel!.font = UIFont.titleFont
            segment.tag = i
            segment.addTarget(self, action: #selector(userDidTapSegment), for: .touchUpInside)
            segments.append(segment)
        }
    }
    
    @IBAction @objc func userDidTapSegment(_ segment: UIButton) {
        highlightIndicatorPosition.constant = CGFloat(segment.tag) * segmentWidth
        UIView.animate(withDuration: 0.30) {
            self.layoutIfNeeded()
        }
        delegate?.segmentedController(self, didSelectSegmentAtIndex: segment.tag)
    }
    
}
