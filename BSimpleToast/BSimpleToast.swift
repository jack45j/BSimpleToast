//
//  BSimpleToast.swift
//  BSimpleToast
//
//  Created by Benson Lin on 2021/6/17.
//

import UIKit


class BSimpleToast: UIView {
	
	struct BSimpleToastConfiguration {
		var width: CGFloat = 382
		var height: CGFloat = 38
		var edgeSpace: CGFloat = 16
		var bottomSpace: CGFloat = 22
		var borderWidth: CGFloat = 1.5
		var bgColor: UIColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
		var borderColor: CGColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
		var autoDismiss: Bool = true
		var autoDismissSeconds: Double = 2
	}
	
	var config = BSimpleToastConfiguration()
	
	lazy var textLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = .systemFont(ofSize: 15)
		label.textColor = .black
		label.textAlignment = .center
		label.backgroundColor = .clear
		label.isUserInteractionEnabled = false
		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.topAnchor.constraint(equalTo: topAnchor).isActive = true
		label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.0).isActive = true
		label.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor).isActive = true
		return label
	}()
	
	lazy var dismissButton: UIButton = {
		let btn = UIButton(frame: .zero)
		btn.setImage(UIImage(named: "btnBubbleClose"), for: .normal)
		btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
		addSubview(btn)
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		btn.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
		btn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
		return btn
	}()
	
	@objc private func dismiss() {
		dismiss {
			self.dismissAction?()
		}
	}
	
	@objc private func tap() {
		tapAction?()
	}
	
	private var dismissAction: (() -> Void)?
	private var tapAction: (() -> Void)?
	
	init(from view: UIView) {
		super.init(frame: .zero)
		view.addSubview(self)
		setupConstraints(superView: view)
		
		backgroundColor = config.bgColor
		layer.borderWidth = config.borderWidth
		layer.borderColor = config.borderColor
		layer.cornerRadius = config.height / 2
		dismiss(withDuration: 0, onComplete: nil)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
		self.addGestureRecognizer(tapGesture)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints(superView view: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(config.edgeSpace * 2)).isActive = true
		let widthConstraint = widthAnchor.constraint(equalToConstant: config.width)
		widthConstraint.priority = .defaultHigh
		widthConstraint.isActive = true
		
		heightAnchor.constraint(equalToConstant: config.height).isActive = true
		
		let leadingConstraint = leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: config.edgeSpace)
		leadingConstraint.priority = .defaultHigh
		leadingConstraint.isActive = true
		
		let trailingConstraint = trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -config.edgeSpace)
		trailingConstraint.priority = .defaultHigh
		trailingConstraint.isActive = true
		
		bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -config.bottomSpace).isActive = true
		centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func show(withDuration duration: Double = 0.3, text: String, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
		textLabel.text = text
		tapAction = onTapAction
		dismissAction = onDismiss
		
		guard duration != 0 else {
			alpha = 1
			isHidden = false
			return
		}
		
		self.transform = .init(translationX: 0, y: self.config.bottomSpace)
		UIView.animate(withDuration: duration) { [weak self] in
			self?.alpha = 1
			self?.isHidden = false
			self?.transform = .init(translationX: 0, y: 0)
		} completion: { _ in
			guard self.config.autoDismiss else {
				return
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + self.config.autoDismissSeconds) {
				self.dismiss()
			}
		}
	}
	
	func dismiss(withDuration duration: Double = 0.3, onComplete: (() -> Void)? = nil) {
		guard duration != 0 else {
			alpha = 0
			isHidden = true
			onComplete?()
			return
		}
		
		
		UIView.animate(withDuration: duration) { [weak self] in
			guard let self = self else { return }
			self.alpha = 0
			self.transform = .init(translationX: 0, y: self.config.bottomSpace)
		} completion: { [weak self] _ in
			self?.isHidden = true
			onComplete?()
		}
	}
}
