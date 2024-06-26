//
//  Coordinator.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/27/24.
//

import SwiftUI

// MARK: - UIContextMenuInteractionDelegate
extension CustomContextMenuHelper {
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        var parent: CustomContextMenuHelper
        
        init(parent: CustomContextMenuHelper) {
            self.parent = parent
        }
        
        // Delegate methods
        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint
        ) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil) {
                // Views:
                let previewController = UIHostingController(rootView: self.parent.preview)
                previewController.view.backgroundColor = .clear
                return previewController
            } actionProvider: { items in
                // Actions
                return self.parent.actions
            }

        }
        // if need context menu to be expanded
        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
            animator: UIContextMenuInteractionCommitAnimating
        ) {
            animator.addCompletion {
                // tounch on context menu
                self.parent.onEnd()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}
