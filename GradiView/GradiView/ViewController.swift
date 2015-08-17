//
//  ViewController.swift
//  GradiView
//
//  Created by Hufei on 15/8/17.
//  Copyright (c) 2015年 Hufei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
let grav = GradientView(frame: CGRectMake(0, 20, 320, 2.0))
        view.addSubview(grav)
        grav.performAnimation()
        grav.progress = 1.0
        grav.colorsDirection = Direction.horizontal
    }

}

