//
//  ViewControllerResolver.swift
//  SDK Test
//
//  Created by Tyler Hendrickson on 5/30/25.
//


import SwiftUI

struct ViewControllerResolver: UIViewControllerRepresentable {
    var onResolve: (UIViewController) -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        ResolverViewController(onResolve: onResolve)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    private class ResolverViewController: UIViewController {
        let onResolve: (UIViewController) -> Void

        init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError() }

        override func viewDidLoad() {
            super.viewDidLoad()
            DispatchQueue.main.async {
                self.onResolve(self)
            }
        }
    }
}