# SBTween

[![Version](https://img.shields.io/cocoapods/v/SBTween.svg?style=flat)](http://cocoapods.org/pods/SBTween)
[![License](https://img.shields.io/cocoapods/l/SBTween.svg?style=flat)](http://cocoapods.org/pods/SBTween)
[![Platform](https://img.shields.io/cocoapods/p/SBTween.svg?style=flat)](http://cocoapods.org/pods/SBTween)

Note: As most of the projects I work on now are in Swift, I have decided to stop working on SBTween.

I have developed a production ready tweening library written in Swift called [TweenKit](https://github.com/SteveBarnegren/TweenKit)

SBTween does work, and I've used it in a couple of shipping apps, but it was never quite finished, so it's a bit rough around the edges.

###About

SBTween is a functional, but not quite finished, tweening library for iOS.

SBTween was initially designed to facilitate the development of the 'scrubbable animation' on-boarding experiences that have become popular in mobile applications recently. These usually involve a UIPageViewController with text on each page. As the user scrolls, animations are played in sync with the user's scrolling. The Philips Hue app has a good example of this type of on-boarding experience.

As is the case with any flexible tweening library, SBTween allows for the construction of complex animations by playing different actions in sequence or parallel. Where SBTween's approach differs from other animation systems, is that the end state for a complex set of actions is calculated at the point where the animation is first added to the system. This allows animations to be run in reverse, or to be scrubbed, as the resulting state at any point during the animation's timeline can be easily calculated by the system.

This makes SBTween a good fit for uses where the entire animation is known upfront, as is often the case with non-game applications. SBTween is not a good fit for uses where animations will need to be run in an additive fashion. For example, a game where an object moves along a path, but then subsequently also requires a 'shake' animation as the result of user input that was not known at the beginning of the animation. 

SBTween imposes no restrictions on what can be animated, and isn't designed simply to provide animations for UIKit. You can use SBTween to animate UIView frames, autolayout constraints, a float property, paragraph spacing, your AVAudioPlayer volume, or any other value you want to animate over time!

SBTween animations are:

- Scrubbable
- Pause-able
- Cancellable
- Reversible
- Repeatable
- Sequence-able
- Group-able
- platform / framework agnostic (Mostly, soon fully)

If you would like to contribute to SBTween, please do! For the most recent changes, use the development branch.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Create varibles / actions:

```ObjC
// Create context
    SBTContext *context = [[SBTContext alloc]init];
    
// Add variables to context
     SBTVariable *variable = [[SBTVariable alloc]initWithName:@"SomeVariable" doubleValue:0];
    [context addVariable:variable];

// Create actions
    SBTActionInterpolate *interpolateAction = 
    [[SBTActionInterpolate alloc]initWithVariableName:@"SomeVariable" doubleValue:1 duration:5];
   
    SBTActionYoYo *yoyoAction = [[SBTActionYoYo alloc]initWithAction:interpolateAction];
    SBTActionRepeatForever *repeatAction = [[SBTActionRepeatForever alloc]initWithAction:yoyoAction];

// Add actions to context
     [context addAction:repeatAction reverse:NO updateBlock:^{
        // Perform updates here
    } startRunning:YES];
    
```

Update:

```ObjC
    SBTVariable *variable = [context variableWithName:@"SomeVariable"];
    double result = variable.value.doubleValue;
    // Do something with result
```
## Installation

SBTween is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SBTween"
```

## Future Improvements

Want to contribute to SBTween? Here's a quick list of features that are on my todo list:

- Mac support (requires use of CVDisplayLink rather than CADisplayLink)
- Catmull-Rom action
- Bezier path action
- Fully featured demo application
- Documentation
- Tests (yeah, I know...)

## Author

Steve Barnegren, steve.barnegren@gmail.com

https://twitter.com/SteveBarnegren

## License

SBTween is available under the MIT license. See the LICENSE file for more info.

