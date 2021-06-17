//
//  ViewController.swift
//  BSimpleToast
//
//  Created by Yi-Cheng Lin on 2021/6/17.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var insideView: UIView!
	@IBAction func pressMeInside(_ sender: Any) {
		BSimpleToast(from: insideView).show(text: "This is a text")
	}
	
	@IBAction func pressMe(_ sender: Any) {
		BSimpleToast(from: view).show(text: "This is a text")
	}
}

