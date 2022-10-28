
public extension String {

    /// return true if the string is a number
    var isNumericString: Bool {
        rangeOfCharacter(from:CharacterSet(charactersIn: ".-0123456789").inverted) == nil
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    // Search for one string in another.
    // return the part of the string that is after delimtString.
    func subStringAfter(delimitString: String) -> String? {
        if  let range = self.range(of: delimitString,
                                    options: NSString.CompareOptions.literal,
                                    range: self.startIndex..<self.endIndex,
                                           locale: nil) {
            // Start of range for found string.
            let start = self.index(range.lowerBound, offsetBy: delimitString.count)
            return String(self[start..<self.endIndex])
        }
        return nil
    }

    // Search for one string in another.
    // return the part of the string that starts with the delimtString.
    func subStringFrom(delimitString: String) -> String? {
        if  let range = self.range(of: delimitString,
                                    options: NSString.CompareOptions.literal,
                                    range: self.startIndex..<self.endIndex,
                                           locale: nil) {
            // Start of range for found string.
            return String(self[range.lowerBound..<self.endIndex])
        }
        return nil
    }

    /// - Parameters:
    ///   - delimitString: delimitString
    ///   - inclueDelimit: the delimitString is return at the end of the string
    ///    - return the part of the string that is before the delimtString.
    func subStringTo(delimitString: String, inclueDelimit: Bool = true) -> String? {
        if  let range = self.range(of: delimitString,
                                    options: NSString.CompareOptions.literal,
                                    range: self.startIndex..<self.endIndex,
                                           locale: nil) {
            // end of range for found string.
            if inclueDelimit {
                return String(self[self.startIndex..<range.upperBound])
            }
            else {
                let endIndex = self.index(range.upperBound, offsetBy: -delimitString.count)
                return String(self[self.startIndex..<endIndex])
            }
        }
        return nil
    }

    // return the part of the string that starts with the delimtString.
    func subStringFromLast(delimitString: String, inclueDelimit: Bool = true) -> String? {
        if let lastDelimit = self.range(of: delimitString, options: NSString.CompareOptions.backwards) {
            if inclueDelimit {
                return String(self[lastDelimit.lowerBound..<self.endIndex])
            }
            else {
                let start = self.index(lastDelimit.lowerBound, offsetBy: delimitString.count)
                return String(self[start..<self.endIndex])
            }
        }
        return nil
    }

    // return the part of the string that is before the delimtString.
    func subStringToLast(delimitString: String) -> String? {
        if let lastDelimit = self.range(of: delimitString, options: NSString.CompareOptions.backwards) {
            return String(self[self.startIndex..<lastDelimit.lowerBound])
        }
        return nil
    }


}


extension StringProtocol where Index == String.Index {

    /// Find the index location of a string with a string.
    /// - Parameters:
    ///   - string: String to search
    ///   - options: String to find with in the string.
    /// - Returns: The index loction of the options string with in the string.
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
}
