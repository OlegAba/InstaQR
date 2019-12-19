//
//  FAQSection.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import Foundation

struct FAQ {
    let question: String
    let answer: String
}

let FAQSection = [
    
    FAQ(question: "What does SuperQR do?",
        answer: """
        \(System.shared.appName) generates a live wallpaper that combines an image of your choice \
        with a share action (QR barcode). The barcode remains hidden until you reveal the card by \
        long-pressing your lock screen.\n\nThe barcode is recognized by most smart phone cameras to \
        directly get your share action.
        """
    ),
    FAQ(question: "How to change accidentally denied app permissions?",
        answer: """
        \(System.shared.appName) generates a live wallpaper that combines an image of your choice \
        with a share action (QR barcode). The barcode remains hidden until you reveal the card by \
        long-pressing your lock screen. The barcode is recognized by most smart phone cameras to \
        directly get your share action.
        """
    ),
    FAQ(question: "How do I share my action with another person?",
        answer: """
        While your phone is locked, firmly long-press on the screen. This will reveal your share \
        action (QR Barcode). If the other person has an iPhone, all he/she has to do is lanuch the \
        camera app and point it at the barcode. The camera automatically detects the QR code and \
        activates the share action.
        """
    ),
    FAQ(question: "Why is my wallpaper low resolution on lockscreen?",
        answer: """
        During the wallpaper setup, iOS preprocesses the live photos which causes a distortion \
        compared to the orginal. Unfortunantly, this is managed by the phone's operating system, \
        which means we currently can not provide a fix for it.
        """
    ),
]
