//
//  CreditCardFormatter.swift
//  schat
//
//  Created by peter on 2020/4/8.
//  Copyright © 2020 SWAG. All rights reserved.
//

import Foundation

@objcMembers
public class CreditCardFormatter : NSObject
{
    public static let shared : CreditCardFormatter = CreditCardFormatter()

    public func formatToCreditCardNumber(isAmex: Bool, textField: UITextField, withPreviousTextContent previousTextContent : String?, andPreviousCursorPosition previousCursorSelection : UITextRange?) {
        var selectedRangeStart = textField.endOfDocument
        if textField.selectedTextRange?.start != nil {
            selectedRangeStart = (textField.selectedTextRange?.start)!
        }
        if  let textFieldText = textField.text
        {
            var targetCursorPosition : UInt = UInt(textField.offset(from:textField.beginningOfDocument, to: selectedRangeStart))
            let cardNumberWithoutSpaces : String = removeNonDigitsFromString(string: textFieldText, andPreserveCursorPosition: &targetCursorPosition)
            if cardNumberWithoutSpaces.count > 19
            {
                textField.text = previousTextContent
                textField.selectedTextRange = previousCursorSelection
                return
            }
            var cardNumberWithSpaces = ""

            if isAmex {
                cardNumberWithSpaces = insertSpacesInAmexFormat(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
            }
            else
            {
                cardNumberWithSpaces = insertSpacesIntoEvery4DigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
            }
            textField.text = cardNumberWithSpaces
            if let finalCursorPosition = textField.position(from:textField.beginningOfDocument, offset: Int(targetCursorPosition))
            {
                textField.selectedTextRange = textField.textRange(from: finalCursorPosition, to: finalCursorPosition)
            }
        }
    }

    public func removeNonDigitsFromString(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var digitsOnlyString : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            let charToAdd : Character = Array(string)[index]
            if isDigit(character: charToAdd)
            {
                digitsOnlyString.append(charToAdd)
            }
            else
            {
                if index < Int(cursorPosition)
                {
                    cursorPosition -= 1
                }
            }
        }
        return digitsOnlyString
    }

    private func isDigit(character : Character) -> Bool
    {
        return "\(character)".containsOnlyDigits()
    }

    public func insertSpacesInAmexFormat(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var stringWithAddedSpaces : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            if index == 4
            {
                stringWithAddedSpaces += " "
                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index == 10 {
                stringWithAddedSpaces += " "
                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index < 15 {
               let characterToAdd : Character = Array(string)[index]
                stringWithAddedSpaces.append(characterToAdd)
            }
        }
        return stringWithAddedSpaces
    }


    public func insertSpacesIntoEvery4DigitsIntoString(string : String, andPreserveCursorPosition cursorPosition : inout UInt) -> String {
        var stringWithAddedSpaces : String = ""
        for index in stride(from: 0, to: string.count, by: 1)
        {
            if index != 0 && index % 4 == 0 && index < 16
            {
                stringWithAddedSpaces += " "

                if index < Int(cursorPosition)
                {
                    cursorPosition += 1
                }
            }
            if index < 16 {
                let characterToAdd : Character = Array(string)[index]
                stringWithAddedSpaces.append(characterToAdd)
            }
        }
        return stringWithAddedSpaces
    }

}
