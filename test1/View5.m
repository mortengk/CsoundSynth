//
//  View5.m
//  test1
//
//  Created by Morten Kleveland on 25.02.14.
//  Copyright (c) 2014 NTNU. All rights reserved.
//

#import "View5.h"

@implementation View5

@synthesize view;
@synthesize distortionPlaceholder;
@synthesize phaserPlaceholder;
@synthesize reverbPlaceholder;

CGPoint hei;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *a = [[UINib nibWithNibName:@"View5" bundle:nil]instantiateWithOwner:nil options:nil];
        self = a[0];
        self.backgroundColor = [UIColor clearColor];
        
        distortionPlaceholder.backgroundColor = [UIColor clearColor];
        self.distortionView = [[DistortionView alloc]initWithFrame:distortionPlaceholder.bounds];
        [distortionPlaceholder addSubview:self.distortionView];
        [view addSubview:distortionPlaceholder];
        
        phaserPlaceholder.backgroundColor = [UIColor clearColor];
        self.phaserView = [[PhaserView alloc]initWithFrame:phaserPlaceholder.bounds];
        [phaserPlaceholder addSubview:self.phaserView];
        [view addSubview:distortionPlaceholder];
        
        reverbPlaceholder.backgroundColor = [UIColor clearColor];
        self.reverbView = [[ReverbView alloc]initWithFrame:reverbPlaceholder.bounds];
        [reverbPlaceholder addSubview:self.reverbView];
        [view addSubview:reverbPlaceholder];
        
    }
    return self;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	// We only support single touches, so anyObject retrieves just that touch from touches.
//	UITouch *touch = [touches anyObject];
//	
//	// Only move the placard view if the touch was in the placard view.
//	if ([touch view] != self.reverbView) {
//		// In case of a double tap outside the placard view, update the placard's display string.
//		if ([touch tapCount] == 2)
//		return;
//	}
//    
//	// Animate the first touch.
//	CGPoint touchPoint = [touch locationInView:self];
//	[self animateFirstTouchAtPoint:touchPoint];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	UITouch *touch = [touches anyObject];
//	
//	// If the touch was in the placardView, move the placardView to its location.
//	if ([touch view] == self.reverbView) {
//		CGPoint location = [touch locationInView:self];
//		self.reverbView.center = location;
//		return;
//	}
//}
//
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	UITouch *touch = [touches anyObject];
//	
//	// If the touch was in the placardView, bounce it back to the center.
//	if ([touch view] == self.reverbView) {
//		/*
//         Disable user interaction so subsequent touches don't interfere with animation until the placard has returned to the center. Interaction is reenabled in animationDidStop:finished:.
//         */
//		self.userInteractionEnabled = NO;
//		//[self animatePlacardViewToCenter];
//		return;
//	}
//}
//
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	
//	/*
//     To impose as little impact on the device as possible, simply set the placard view's center and transformation to the original values.
//     */
//	self.reverbView.center = self.center;
//	self.reverbView.transform = CGAffineTransformIdentity;
//}

/*
 First of two possible implementations of animateFirstTouchAtPoint: illustrating different behaviors.
 To choose the second, replace '1' with '0' below.
 */

#define GROW_FACTOR 1.2f
#define SHRINK_FACTOR 1.1f

//#if 1

/**
 "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
 */

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	/*
	 This illustrates using UIView's built-in animation.  We want, though, to animate the same property (transform) twice -- first to scale up, then to shrink.  You can't animate the same property more than once using the built-in animation -- the last one wins.  So we'll set a delegate action to be invoked after the first animation has finished.  It will complete the sequence.
     
     The touch point is passed in an NSValue object as the context to beginAnimations:. To make sure the object survives until the delegate method, pass the reference as retained.
	 */
	
#define GROW_ANIMATION_DURATION_SECONDS 0.15
	
    hei = touchPoint;
	NSValue *touchPointValue = [NSValue valueWithCGPoint:touchPoint];
	[UIView beginAnimations:nil context:(__bridge_retained void *)touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
	self.reverbView.transform = transform;
	[UIView commitAnimations];
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
#define MOVE_ANIMATION_DURATION_SECONDS 0.15
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
	self.reverbView.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
	/*
	 Move the placardView to under the touch.
	 We passed the location wrapped in an NSValue as the context. Get the point from the value, and transfer ownership to ARC to balance the bridge retain in touchesBegan:withEvent:.
	 */
	NSValue *touchPointValue = (__bridge_transfer NSValue *)context;
    NSLog(@"%@", touchPointValue);
	//CGPoint asvc = [touchPointValue CGPointValue];
    CGPoint aaa2 = CGPointMake(hei.x - self.reverbView.bounds.size.width/2, hei.y);
    
    self.reverbView.center = aaa2;
    
	[UIView commitAnimations];
}

//#else

/*
 Alternate behavior.
 The preceding implementation grows the placard in place then moves it to the new location and shrinks it at the same time.  An alternative is to move the placard for the total duration of the grow and shrink operations; this gives a smoother effect.
 
 */


/**
 Create two separate animations. The first animation is for the grow and partial shrink. The grow animation is performed in a block. The method uses a completion block that itself includes an animation block to perform the shrink. The second animation lasts for the total duration of the grow and shrink animations and contains a block responsible for performing the move.
 */

//- (void)animatePlacardViewToCenter {
//	
//    ReverbView *reverbView = self.reverbView;
//    CALayer *welcomeLayer = reverbView.layer;
//	
//	// Create a keyframe animation to follow a path back to the center.
//	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	bounceAnimation.removedOnCompletion = NO;
//	
//	CGFloat animationDuration = 1.5f;
//    
//	
//	// Create the path for the bounces.
//	UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
//	
//    CGPoint centerPoint = self.center;
//	CGFloat midX = centerPoint.x;
//	CGFloat midY = centerPoint.y;
//	CGFloat originalOffsetX = reverbView.center.x - midX;
//	CGFloat originalOffsetY = reverbView.center.y - midY;
//	CGFloat offsetDivider = 4.0f;
//	
//	BOOL stopBouncing = NO;
//    
//	// Start the path at the placard's current location.
//	[bouncePath moveToPoint:CGPointMake(reverbView.center.x, reverbView.center.y)];
//	[bouncePath addLineToPoint:CGPointMake(midX, midY)];
//	
//	// Add to the bounce path in decreasing excursions from the center.
//	while (stopBouncing != YES) {
//        
//        CGPoint excursion = CGPointMake(midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
//        [bouncePath addLineToPoint:excursion];
//        [bouncePath addLineToPoint:centerPoint];
//        
//		offsetDivider += 4;
//		animationDuration += 1/offsetDivider;
//		if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
//			stopBouncing = YES;
//		}
//	}
//	
//	bounceAnimation.path = [bouncePath CGPath];
//	bounceAnimation.duration = animationDuration;
//	
//	// Create a basic animation to restore the size of the placard.
//	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//	transformAnimation.removedOnCompletion = YES;
//	transformAnimation.duration = animationDuration;
//	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//	
//	
//	// Create an animation group to combine the keyframe and basic animations.
//	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
//	
//	// Set self as the delegate to allow for a callback to reenable user interaction.
//	theGroup.delegate = self;
//	theGroup.duration = animationDuration;
//	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//	
//	theGroup.animations = @[bounceAnimation, transformAnimation];
//	
//	
//	// Add the animation group to the layer.
//	[welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
//	
//	// Set the placard view's center and transformation to the original values in preparation for the end of the animation.
//	reverbView.center = centerPoint;
//	reverbView.transform = CGAffineTransformIdentity;
//}


/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
	self.reverbView.transform = CGAffineTransformIdentity;
	self.userInteractionEnabled = YES;
}


@end
