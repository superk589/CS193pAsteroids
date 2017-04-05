//
//  AsteriodsViewController.swift
//  CS193pAsteroids
//
//  Created by zzk on 2017/4/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class AsteriodsViewController: UIViewController {

    private var asteroidField: AsteroidFieldView!
    
    private var ship: SpaceshipView!
    
    private var asteroidBehavior = AsteroidBehavior()
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator.init(referenceView: self.asteroidField)
    
    @IBAction func burn(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            ship.direction = (sender.location(in: view) - ship.center).angle
            burn()
        case .ended:
            endBurn()
        default:
            break
        }
    }
    
    private func burn() {
        ship.enginesAreFiring = true
        asteroidBehavior.acceleration.angle = ship.direction - CGFloat.pi
        asteroidBehavior.acceleration.magnitude = Constants.burnAcceleration
    }
    
    private func endBurn() {
        ship.enginesAreFiring = false
        asteroidBehavior.acceleration.magnitude = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeIfNeeded()
        animator.addBehavior(asteroidBehavior)
        asteroidBehavior.pushAllAsteroids()
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator.removeBehavior(asteroidBehavior)
    }
    
    private func initializeIfNeeded() {
        if asteroidField == nil {
            asteroidField = AsteroidFieldView(frame: CGRect.init(center: view.bounds.mid, size: view.bounds.size * Constants.asteroidFieldMagnitude))
            view.addSubview(asteroidField)
            
            let shipSize = view.bounds.size.minEdge * Constants.shipSizeToMinBoundsEdgeRatio
            ship = SpaceshipView(frame: CGRect(squareCenteredAt: view.bounds.mid, size: shipSize))
            view.addSubview(ship)
            repositionShip()
            asteroidField.asteroidBehavior = self.asteroidBehavior
            asteroidField.addAsteroids(count: Constants.initialAsteroidCount, exclusionZone: ship.convert(ship.bounds, to: asteroidField))
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        asteroidField?.center = view.bounds.mid
        repositionShip()
    }
    
    private func repositionShip() {
        if asteroidField != nil {
            ship.center = asteroidField.center
            asteroidBehavior.setBoundary(ship.shieldBoundary(in: asteroidField), named: Constants.shipBoundaryName, handler: { [weak self] in
                if let ship = self?.ship {
                    if !ship.shieldIsActive {
                        ship.shieldIsActive = true
                        ship.shieldLevel -= Constants.Shield.activationCost
                        Timer.scheduledTimer(withTimeInterval: Constants.Shield.duration, repeats: false, block: { (timer) in
                            ship.shieldIsActive = false
                            if ship.shieldLevel == 0 {
                                ship.shieldLevel = 100
                            }
                        })
                    }
                }
            })
        }
    }
    
    // MARK: Constants
    private struct Constants {
        static let initialAsteroidCount = 20
        static let shipBoundaryName = "Ship"
        static let shipSizeToMinBoundsEdgeRatio: CGFloat = 1/5
        static let asteroidFieldMagnitude: CGFloat = 10
        static let burnAcceleration: CGFloat = 0.07
        struct Shield {
            // as a multiple of view.bounds.size // points/s/s
            static let duration: TimeInterval = 1.0
            static let activationCost: Double = 15
            // how long shield stays up // per activation
        }
    }
}

