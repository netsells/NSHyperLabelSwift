# NSHyperLabelSwift

[![CI Status](http://img.shields.io/travis/Jack Colley/NSHyperLabelSwift.svg?style=flat)](https://travis-ci.org/Jack Colley/NSHyperLabelSwift)
[![Version](https://img.shields.io/cocoapods/v/NSHyperLabelSwift.svg?style=flat)](http://cocoapods.org/pods/NSHyperLabelSwift)
[![License](https://img.shields.io/cocoapods/l/NSHyperLabelSwift.svg?style=flat)](http://cocoapods.org/pods/NSHyperLabelSwift)
[![Platform](https://img.shields.io/cocoapods/p/NSHyperLabelSwift.svg?style=flat)](http://cocoapods.org/pods/NSHyperLabelSwift)

## Description
NSHyperLabel is a small utility that enables you to add hyperlinks to a UILabel. You can also specify as many or as little attributes for the links. 

A Netsells Project

## Example

```swift
testLabel.text = "Netsells is a leading digital agency"
testLabel.setLinkForSubstring("Netsells", attributes: testLabel.linkAttributeDefault, url: URL(string: "http://netsells.co.uk")!)
```

## Requirements
iOS 8.0 or greater
## Installation

NSHyperLabelSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NSHyperLabelSwift"
```

## Roadmap for next version

- [ ] Unit Tests
- [ ] Thorough Documentation
- [ ] Better syntax for default attributes

## Author

Jack Colley, jack.colley@netsells.co.uk

## License

NSHyperLabelSwift is available under the MIT license. See the LICENSE file for more info.
