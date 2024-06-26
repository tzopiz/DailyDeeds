//
//  CustomContextMenu.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/26/24.
//

import SwiftUI

struct CustomContextMenu<Content: View, Preview: View>: View {
    
    var content: Content
    var preview: Preview
    var menu: UIMenu
    var onEnd: () -> Void
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder preview: @escaping () -> Preview,
        actoions: @escaping () -> UIMenu,
        onEnd: @escaping () -> Void
    ) {
        self.content = content()
        self.preview = preview()
        self.menu = actoions()
        self.onEnd = onEnd
    }
    
    var body: some View {
        ZStack {
            content
                .hidden()
                .overlay {
                    CustomContextMenuHelper(
                        content: content,
                        preview: preview,
                        actions: menu,
                        onEnd: onEnd
                    )
                }
        }
    }
}

struct CustomContextMenuHelper<Content: View, Preview: View>: UIViewRepresentable {
    var content: Content
    var preview: Preview
    var actions: UIMenu
    var onEnd: () -> Void
    
    init(
        content: Content,
        preview: Preview,
        actions: UIMenu,
        onEnd: @escaping () -> Void
    ) {
        self.content = content
        self.preview = preview
        self.actions = actions
        self.onEnd = onEnd
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        // FIXME: -
        // !!!: showing touching in some view
        // settings our content view as Main Interaction view
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        let constaints = [
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostView.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        hostView.view.backgroundColor = .clear
        view.addSubview(hostView.view)
        view.addConstraints(constaints)
        // setting interactions
        let interaction = UIContextMenuInteraction(
            delegate: context.coordinator
        )
        view.addInteraction(interaction)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}


#Preview {
    CustomContextMenu {
        Text("content")
    } preview: {
        VStack(spacing: 32) {
            Text("preview")
            Text("preview")
            Text("preview")
            Text("preview")
            Text("preview")
        }
    } actoions: {
        return UIMenu()
    } onEnd: {
        print("press smth")
    }
}
