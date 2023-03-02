//
//  ExampleData.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 8/1/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import Foundation

//
// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(name: "pload your receipt by clicking the Upload Receipt button on the Rewards page. If you subscribe to a business, you can also upload receipts when they ", items: [
        Item(name: "Upload your receipt by clicking the Upload Receipt button on the Rewards page. If you subscribe to a business, you can also upload receipts when they send you a special offer. Click the Activation button on the message to upload!"),
         Item(name: "Upload your receipt by clicking the Upload Receipt button on the Rewards page. If you subscribe to a business, you can also upload receipts when they send you a special offer. Click the Activation button on the message to upload!"),
         Item(name: "Upload your receipt by clicking the Upload Receipt button on the Rewards page. If you subscribe to a business, you can also upload receipts when they send you a special offer. Click the Activation button on the message to upload!")
        
    ]),
    Section(name: "test", items: [
        Item(name: "Only receipts from businesses in our directory can be approved for points on Townview."),
        Item(name: "Only receipts from businesses in our directory can be approved for points on Townview."),
        Item(name: "Only receipts from businesses in our directory can be approved for points on Townview."),
        
    ]),
    Section(name: "test", items: [
        Item(name: "Townview users will receive points each time they upload a receipt from a local business. Users can redeem these points for prizes from Townview!")
    ]),
   
    Section(name: "test", items: [
        Item(name: "Yes, online orders from locally owned businesses count as well. Screenshot your receipt and upload it for submission.")
        
    ]),
    Section(name: "test", items: [
        Item(name: "Tap Redeem on your Local Card to view the available rewards. Select the item and proceed to order confirmation.")
        
    ]),
    Section(name: "test", items: [
        Item(name: "On the Rewards tab, select the Redeem button found on your Local Card.")
    ]),
    
    Section(name: "test", items: [
        Item(name: "Each reward will have a detailed product or service description.")
        
    ]),
    Section(name: "Do my points expire?", items: [
        Item(name: "Loyalty points do not expire."),
        
    ]),
    Section(name: "test", items: [
        Item(name: "The status of your submission will be shown in your upload history section.")
    ]),
    
    Section(name: "test", items: [
        Item(name: "You can only earn points from businesses that are apart of Townview’s business directory.")
        
    ]),
    Section(name: "test", items: [
        Item(name: "Electronic gift card (next day) or shipped to the provided address (3-5 business days).")
        
    ]),
    Section(name: "How can I contact support?", items: [
        Item(name: "To contact support please \n email: info@townviewapp.com"),
    ])
]
