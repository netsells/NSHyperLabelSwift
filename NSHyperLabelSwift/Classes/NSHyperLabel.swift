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
    
    var handlers: [(label: HyperLabel, substring: String)-> Void] = []
    private var stringHandlersDict = [NSAttributedString: Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.checkInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.checkInitialization()
    }
    
    func checkInitialization() {
        self.linkAttributeDefault = NSDictionary(objects: [self.hyperlinkColour, NSUnderlineStyle.StyleSingle.rawValue], forKeys: [NSForegroundColorAttributeName, NSUnderlineStyleAttributeName]) as! [String : AnyObject]
    }
    
    public func setLinkForSubstring(substring: String, attributes: NSDictionary, linkHandler: (label: HyperLabel, substring: String)-> Void) {
        let currentText = self.text as! NSString
        
        let substringRange = currentText.rangeOfString(substring)
        
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
        
        self.attributedText = mutableAttributedString
    }

}
