//
//  NSHyperLabel.swift
//  Pods
//
//  Created by Jack Colley on 20/07/2016.
//
//

import UIKit

open class HyperLabel: UILabel {
    
    @IBInspectable var hyperlinkColour: UIColor = UIColor(red: 64 / 255, green: 120 / 255, blue: 192 / 255, alpha: 1.0)
    
    open var linkAttributeDefault = [String: AnyObject]()
    open var urls = [URL]()
    fileprivate var ranges = [NSMutableDictionary]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupDefault()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupDefault()
    }
    
    func setupDefault() {
        self.linkAttributeDefault = NSDictionary(objects: [self.hyperlinkColour, NSUnderlineStyle.styleSingle.rawValue], forKeys: [NSForegroundColorAttributeName as NSCopying, NSUnderlineStyleAttributeName as NSCopying]) as! [String : AnyObject]
        
        self.isUserInteractionEnabled = true
    }
    
    open func setLinkForSubstring(_ substring: String, attributes: NSDictionary, url: URL) {
        let currentText = NSString(string: self.text!)
        
        let substringRange = currentText.range(of: substring)
        
        urls.append(url)
        
        if(substringRange.length > 0) {
            self.setLinkForRange(substringRange, attributes: attributes)
        }
    }
    
    fileprivate func setLinkForRange(_ range:NSRange, attributes: NSDictionary) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        
        
        if(attributes.count > 0) {
            
            mutableAttributedString.addAttributes(attributes as! [String : AnyObject], range: range)
        }
        
        let dictToAdd = NSMutableDictionary()
        dictToAdd["url_index"] = urls.count - 1
        dictToAdd["range"] = range
        
        self.ranges.append(dictToAdd)
        
        self.attributedText = mutableAttributedString
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let value = NSValue()
            let urlID = value.attributedTextRangeForPointInLabel(touch.location(in: self), label: self)
            
            if let urlID = urlID {
                if(self.urls.count > urlID) {
                    let url = self.urls[urlID]
                    
                    if(UIApplication.shared.canOpenURL(url)) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}

extension NSValue {
    func attributedTextRangeForPointInLabel(_ point: CGPoint, label: HyperLabel) -> Int? {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = 0
        textContainer.size = label.bounds.size
        
        layoutManager.addTextContainer(textContainer)
        
        // Text storage to calculate the position
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        textStorage.addLayoutManager(layoutManager)
        
        // Find the tapped character location and compare it to the specified range
        let locationInLabel = point
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (label.bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.minX, y: (label.bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.minY)
        let locationOfTouchInTextContainer = CGPoint(x: locationInLabel.x - textContainerOffset.x, y: locationInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for dict in label.ranges {
            let range = dict.object(forKey: "range") as! NSRange
            if (NSLocationInRange(indexOfCharacter, range)) {
                return dict["url_index"] as? Int;
            }
        }
        
        return nil
    }
}
