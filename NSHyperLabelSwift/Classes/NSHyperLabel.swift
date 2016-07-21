//
//  NSHyperLabel.swift
//  Pods
//
//  Created by Jack Colley on 20/07/2016.
//
//

import UIKit

public class HyperLabel: UILabel {
    
    @IBInspectable var hyperlinkColour: UIColor = UIColor(red: 64 / 255, green: 120 / 255, blue: 192 / 255, alpha: 1.0)
    
    public var linkAttributeDefault = [String: AnyObject]()
    
    public var urls = [NSURL]()
    var handlers: [(label: HyperLabel, substring: String)-> Void] = []
    private var ranges = [NSMutableDictionary]()
    private var stringHandlersDict = [NSAttributedString: Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupDefault()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupDefault()
    }
    
    func setupDefault() {
        self.linkAttributeDefault = NSDictionary(objects: [self.hyperlinkColour, NSUnderlineStyle.StyleSingle.rawValue], forKeys: [NSForegroundColorAttributeName, NSUnderlineStyleAttributeName]) as! [String : AnyObject]
        
        self.userInteractionEnabled = true
    }
    
    public func setLinkForSubstring(substring: String, attributes: NSDictionary, url: NSURL, linkHandler: (label: HyperLabel, substring: String)-> Void) {
        let currentText = self.text as! NSString
        
        let substringRange = currentText.rangeOfString(substring)
        
        urls.append(url)
        
        if(substringRange.length > 0) {
            self.setLinkForRange(substringRange, attributes: attributes, handler: linkHandler)
        }
    }
    
    private func setLinkForRange(range:NSRange, attributes: NSDictionary, handler:(label: HyperLabel, substring: String)-> Void) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        
        
        if(attributes.count > 0) {
            
            mutableAttributedString.addAttributes(attributes as! [String : AnyObject], range: range)
        }
        
        self.handlers.append(handler)
        self.stringHandlersDict[self.attributedText!.attributedSubstringFromRange(range)] = self.handlers.count - 1
        
        let dictToAdd = NSMutableDictionary()
        dictToAdd["url_index"] = urls.count - 1
        dictToAdd["range"] = range
        dictToAdd["handler_index"] = self.handlers.count - 1
        
        self.ranges.append(dictToAdd)
        
        self.attributedText = mutableAttributedString
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            var value = NSValue()
            let urlID = value.attributedTextRangeForPointInLabel(touch.locationInView(self), label: self)
            
            if let urlID = urlID {
                if(self.urls.count > urlID) {
                    let url = self.urls[urlID]
                    
                    if(UIApplication.sharedApplication().canOpenURL(url)) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            }
        }
    }

}

extension NSValue {
    func attributedTextRangeForPointInLabel(point: CGPoint, label: HyperLabel) -> Int? {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSizeZero)
        
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
        let textBoundingBox = layoutManager.usedRectForTextContainer(textContainer)
        let textContainerOffset = CGPointMake((CGRectGetWidth(label.bounds) - CGRectGetWidth(textBoundingBox)) * 0.5 - CGRectGetMinX(textBoundingBox), (CGRectGetHeight(label.bounds) - CGRectGetHeight(textBoundingBox)) * 0.5 - CGRectGetMinY(textBoundingBox))
        let locationOfTouchInTextContainer = CGPointMake(locationInLabel.x - textContainerOffset.x, locationInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndexForPoint(locationOfTouchInTextContainer, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for dict in label.ranges {
            let range = dict.objectForKey("range") as! NSRange
            if (NSLocationInRange(indexOfCharacter, range)) {
                return dict["url_index"] as? Int;
            }
        }
        
        return nil
    }
}
