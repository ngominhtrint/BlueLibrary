//
//  HorizontalScrollerView.swift
//  BlueLibrary
//
//  Created by TriNgo on 9/18/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

protocol HorizontalScrollerViewDataSource: class {
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}

protocol HorizontalScrollerViewDelegate: class {
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}

fileprivate enum ViewConstants {
    static let Padding: CGFloat = 10
    static let Dimensions: CGFloat = 100
    static let Offset: CGFloat = 100
}

class HorizontalScrollerView: UIView {
    
    weak var dataSource: HorizontalScrollerViewDataSource?
    weak var delegate: HorizontalScrollerViewDelegate?

    fileprivate let scroller = UIScrollView()
    fileprivate var contentViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        addSubview(scroller)
        
        scroller.delegate = self
        scroller.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroller.topAnchor.constraint(equalTo: self.topAnchor),
            scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped(gesture:)))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func scrollToView(at index: Int, animated: Bool = true) {
        let centralView = contentViews[index]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
    }
    
    @objc func scrollerTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scroller)
        guard let index = contentViews.index(where: { $0.frame.contains(location) }) else {
            return
        }
        
        delegate?.horizontalScrollerView(self, didSelectViewAt: index)
        scrollToView(at: index)
    }
    
    func view(at index: Int) -> UIView {
        return contentViews[index]
    }
    
    func reload() {
        guard let dataSource = dataSource else { return }
        
        contentViews.forEach { $0.removeFromSuperview() }
        
        var xValue = ViewConstants.Offset
        
        contentViews = (0..<dataSource.numberOfViews(in: self)).map { index in
            xValue += ViewConstants.Padding
            let view = dataSource.horizontalScrollerView(self, viewAt: index)
            view.frame = CGRect(x: CGFloat(xValue), y: ViewConstants.Padding, width: ViewConstants.Dimensions, height: ViewConstants.Dimensions)
            scroller.addSubview(view)
            xValue += ViewConstants.Dimensions + ViewConstants.Padding
            return view
        }
        
        scroller.contentSize = CGSize(width: CGFloat(xValue + ViewConstants.Offset), height: scroller.frame.size.height)
    }
    
    func centerCurrentView() {
        let centerRect = CGRect(origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0), size: CGSize(width: ViewConstants.Padding, height: scroller.bounds.height))
        
        guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(centerRect) }) else { return }
        let centralView = contentViews[selectedIndex]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
        
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
    }
}

extension HorizontalScrollerView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentView()
    }
}





