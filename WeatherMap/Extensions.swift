public extension JSONSerialization {

    /// Loading resource test files (JSON)
    /// - Parameters:
    ///   - fileName: resource referrence
    ///   - bundle: resource bundle
    ///   - logManager:
    /// - Returns: JSON data bundle
    static func loadJsonDataFromJSON(fileName: String, bundle: Bundle?) -> Data? {
        let bundle = bundle ?? Bundle.allFrameworks.first { $0.path(forResource: fileName, ofType: "json") != nil }
        if let path = bundle?.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return data
            } catch {
                Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 1 :: Failure | fileName: \(fileName): error: \(error)")
            }
        }

        Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 2 :: Failure - not found | fileName : \(fileName)")
        return nil

    }

    static func getResourcePath(fileName: String, bundle: Bundle?, type: String = "json") -> String? {
        let bundle = bundle ?? Bundle.allFrameworks.first { $0.path(forResource: fileName, ofType: type) != nil }
        if let path = bundle?.path(forResource: fileName, ofType: type) {
            return path
        }

        Provider.logManager?.LogWarn("Resources :: JSONSerialization :: getResourcePath :: 3 :: Failure - not found | fileName : \(fileName).\(type)")
        return nil

    }

    static func loadJsonDataFromResource(path: String) -> Data? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            return data
        } catch {
            Provider.logManager?.LogWarn("Resources :: JSONSerialization :: loadJsonDataFromJSON :: 4 :: Failure | path: \(path): error: \(error.localizedDescription)")
        }
        return nil

    }

}
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

internal struct AnchorOffsets {
    var leading: CGFloat
    var trailing: CGFloat
    var top: CGFloat
    var bottom: CGFloat
    static var zero: Self { .init(leading: 0.0, trailing: 0.0, top: 0.0, bottom: 0.0) }
}

extension UIView {
    // MARK: - Internal Variables
    /// safe area bounds
    internal var safeAreaBounds: CGRect {
        return self.bounds
    }

    ///enclosing collection view
    internal var parentCollectionView: UICollectionView? {
        var nextResponder = next
        while (nextResponder != nil) {
            if let collectionView = nextResponder as? UICollectionView {
                return collectionView
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    ///enclosing Collection view cell
    internal var parentCollectionViewCell: UICollectionViewCell? {
        var nextResponder = next
        while (nextResponder != nil) {
            if let collectionViewCell = nextResponder as? UICollectionViewCell {
                return collectionViewCell
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    ///enclosing table view
    internal var parentTableView: UITableView? {
        var nextResponder = next
        while (nextResponder != nil) {
            if let tableView = nextResponder as? UITableView {
                return tableView
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    ///enclosing table view cell
    internal var parentTableViewCell: UITableViewCell? {
        var nextResponder = next
        while (nextResponder != nil) {
            if let tableViewCell = nextResponder as? UITableViewCell {
                return tableViewCell
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    ///enclosing view controller
    internal var parentViewController: UIViewController? {
        var nextResponder = next
        while (nextResponder != nil) {
            if let viewController = nextResponder as? UIViewController { return viewController }
            nextResponder = nextResponder?.next
        }
        return nil
    }


    ///Rectangle coords of parent view
    internal var translatedFrame: CGRect? {
        if let controller = self.parentViewController, let parentView = controller.view {
            return parentView.convert(self.bounds, from: self)
        }
        return nil
    }

    ///safe are intersection
    internal var parentViewControllerSafeAreaIntersection: CGRect? {
        return safeAreaIntersection()
    }


    // MARK: - Private Methods
    /// Intersection of view with parent view
    /// - Returns: Intersection rectangle
    private func safeAreaIntersection() -> CGRect? {
        if let parentView = self.parentViewController?.view,
           let frame = self.translatedFrame,
           parentView.safeAreaBounds.intersects(frame) {
            return parentView.safeAreaBounds.intersection(frame)
        }
        return nil
    }

    func pin(to view: UIView, anchorOffsets: AnchorOffsets = AnchorOffsets.zero) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: anchorOffsets.leading),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: anchorOffsets.trailing),
            topAnchor.constraint(equalTo: view.topAnchor, constant: anchorOffsets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: anchorOffsets.bottom)
        ])
        self.setNeedsLayout()
    }
}

