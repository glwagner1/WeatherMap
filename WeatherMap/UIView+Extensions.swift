//
//  UIView+Extensions.swift
//  
//
//  Created by Gary L Wagner on 8/29/22.
//

import UIKit

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
