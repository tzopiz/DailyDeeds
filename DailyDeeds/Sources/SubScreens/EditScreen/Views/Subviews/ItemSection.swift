//
//  ItemSection.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/2/24.
//

import SwiftUI

struct ItemSection<Content: View, Header: View, Footer: View>: View {
    let content: Content
    let header: Header
    let footer: Footer
    let top: CGFloat
    let leading: CGFloat
    let bottom: CGFloat
    let trailing: CGFloat
    let vertical: CGFloat
    let horizontal: CGFloat

    init(
        top: CGFloat = 0, leading: CGFloat = 0,
        bottom: CGFloat = 0, trailing: CGFloat = 0,
        vertical: CGFloat = 0, horizontal: CGFloat = 0,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.content = content()
        self.header = header()
        self.footer = footer()
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
        self.horizontal = horizontal
        self.vertical = vertical
    }

    var body: some View {
        Section(
            header: header,
            footer: footer
        ) {
            content
        }
        .listRowBackground(Color.backSecondary)
        .listRowInsets(
            .init(
                top: max(top, vertical),
                leading: max(leading, horizontal),
                bottom: max(bottom, vertical),
                trailing: max(trailing, horizontal)
            )
        )
    }
}
