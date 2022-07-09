import Foundation

let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

var barriers: [Shape] = []

var targets: [Shape] = []

let funnel = PolygonShape(points: funnelPoints)

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers {
        barrier.isDraggable = false
    }

}

fileprivate func setBall() {
    ball.position = Point(x: 259, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .orange
    ball.onCollision = collision(otherShape: )
    ball.isDraggable = false
    ball.onTapped = resetGame
    ball.bounciness = 1
    
    scene.trackShape(ball)
    ball.onExitedScene = ballExt
    
    scene.add(ball)
}

fileprivate func addBarrier(at pos: Point, width: Double, height: Double, angle: Double) {
    
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: 0),
        Point(x: width, y: height)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
    
    barrier.position = pos
    barrier.hasPhysics = true
    barrier.isImmobile = true
    barrier.angle = angle
    
    scene.add(barrier)
}

fileprivate func setFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.isDraggable = false
    
    scene.add(funnel)
}

fileprivate func addTarget(at pos: Point) {
    
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    
    targets.append(target)
    
    target.position = pos
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    target.isDraggable = false
    
    scene.add(target)
}

func collision(otherShape: Shape) {
    if otherShape.name != "target" {return}
    otherShape.fillColor = .green
}

func ballExt() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "Ni ying le!", completion: alertDismissed)
    }
}

func alertDismissed() {return}

func resetGame() {
    ball.position = Point(x: 0, y: -80)
    for barrier in barriers {
        barrier.isDraggable = true
    }
}

func setup() {
    setBall()
    addBarrier(at: Point(x: 150, y: 300), width: 150, height: 15, angle: 0.007)
    addBarrier(at: Point(x: 150, y: 300), width: 150, height: 15, angle: 0.007)
    setFunnel()
    addTarget(at: Point(x: 100, y: 250))
    addTarget(at: Point(x: 200, y: 200))
    resetGame()
}
