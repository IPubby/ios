# Lab 4.2

## Objectives

- Implement an awesome CoreAnimation wait spinner
- Use both UIView block-based and CoreAnimation style animations

## Suggested Resources

- [Cubic-bezier](http://cubic-bezier.com/)
- [View Programming Guide for iOS: Animations](https://developer.apple.com/library/ios/documentation/windowsviews/conceptual/viewpg_iphoneos/animatingviews/animatingviews.html)
- [Core Animation Programming Guide](https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)

## Setup

1. In the SmarticleLab4.2 folder from the repo, open Smarticle.xcodeproj in Xcode.
2. Find and open LoadingSpinnerView.h.  Take note of the public interface to this class.
3. Switch to the implementation.  Notice that a number of the methods have already been filled in but some of the implementations are missing and marked with TODOs.
4. Run the project and click through to some articles.  A white screen should appear briefly when articles are loading and then disappear when they finally load without animation.

>This lab will be more involved and open-ended than previous labs so just let us know if you get stuck.  You can also refer to the SmarticleComplete project in the repo which contains the full implementation of LoadingSpinnerView.

## Animation

The animation we'll be implementing has multiple phases:

1. The two bolt halves should start just off the top and bottom of the screen, fully transparent.
2. Animate both halves to meet at the center
3. Rotate both halves 360 degrees around the center
4. Repeat the rotation animation, pausing for 1 second between each rotation.
5. When stopped, remove the rotation animation
6. Fade both halves out
7. Fade the LoadingSpinnerView itself out.

## 1. Bolt positioning

Use `self.boltContainerView.bounds` to position each half of the lightning bolt at their respective positions just outside of the visible area.  Also, make sure to center each bolt horizontally.  We recommend using the `center` property of each view to accomplish this.

>Hint: If your articles are loading too quickly and you can't see your animation, comment out the line in ListingViewController `-viewDidLoad` method where we set the ArticleProvider as our delegate.  That should slow things down. You can also slow down the animation itself in the simulator (Debug -> Toggle Slow Animations in Frontmost App).

## 2. When two halves meet

Using UIView's `-animateWithDuration:delay:options:animations:completion:`, animate each half of the bolt to the center, offsetting them slightly so that they actually look like a lightning bolt.  Also, fade both bolt halves to be fully opaque.  In the completion block, make sure to call `-startRotation` so that the rotation will begin once the bolts are at the center.

## 3. Spin cycle

For variety, implement `-startRotation` by using a CABasicAnimation to create a rotation animation that rotates `self.boltContainerView` around its center 360 degrees.  Use a duration of 0.5 seconds for the rotation and make the rotation go counter-clockwise.

> Rotation in UIKit uses radians, so if you remember your trig you'll already know that 360 degrees is equivalent to 2 * pi.  You can use the builtin C define `M_PI` to represent pi, no need to import anything.

### 3.1 Optional enhancement

Use `CAMediaTimingFunction` to create your own animation curve and set it as `timingFunction` on your rotation animation to make it more interesting.  See [http://cubic-bezier.com/](http://cubic-bezier.com/) to quickly approximate what setting different control points will look like.

## 4. Rinse and repeat

Figure out how to make the rotation animation repeat and pause for 1 second in between repetitions.  There are several different ways to do this, so now's your chance to get creative.

## 5. Stop it

In `-stopAnimation`, within the if statement, stop the infinitely repeating rotation animation.

### 5.1 Optional enhancement

Instead of stopping immediately, figure out a way to stop the animation only after one complete rotation has occured.  That way the user has a chance to see the awesome animation you've just made.  One way of accomplishing this uses `self.startedAnimatingDate`, which represents the moment when the animation began.  You might find a different (better) way.

## 6. Fade

As soon as rotation stops, start an animation to fade `self.boltContainerView` to transparency.  You'll likely use UIView block-based animation for this again. Use BoltAppearanceAnimationDuration for the duration.

## 7. Fade more

When the first fade animation completes, fade out the entire view, i.e. `self`.