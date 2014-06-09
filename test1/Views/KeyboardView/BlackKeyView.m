//
//  BlackKeyView.m
//  mobilesynth
//
//  Created by Allen Porter on 4/6/09.
//  Copyright 2009 thebends. All rights reserved.
//

#import "BlackKeyView.h"


@implementation BlackKeyView

- (id)initWithFrame:(CGRect)frame withKey:(int)keyNumber {
  return [super initWithFrame:frame withKey:keyNumber];
}

- (void)dealloc {
    //[super dealloc];
}

- (CGRect)shrinkRect:(CGRect)rect amount:(int)pixels{
  rect.origin.x += pixels;
  rect.origin.y += pixels;
  rect.size.width -= pixels * 2;
  rect.size.height -= pixels * 2;
  return rect;
}

static const CGFloat kKeySideStartColor = 0.05;
static const CGFloat kKeySideEndColor = 0.41;
static const CGFloat kKeyTopColor = 0.3;
static const CGFloat kKeyPressedColor = 0.5;
//static const int kKeyGradientSteps = 3;
int keyBorderWidth = 1;

- (void)drawRect:(CGRect)rect {

  
  if (keyPressed) {
    // When the key is pressed, draw an extra alpha gradient on top.
//    CGFloat colors[8] = { 0.1, 0.1, 0.1, 0.0, 0.1, 0.1, 0.1, 0.8 };
//      CGFloat colors[8] = { 1,0,1,.1,0,1,0,.4 };
//
//    CGFloat locations[2] = { 1, 0 };
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef topGradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
//    
//    CGPoint startPoint;
//    startPoint.x = 100;
//    startPoint.y = 100;
//    CGPoint endPoint;
//    endPoint.x = 100;
//    endPoint.y = rect.size.height - 100;
//    CGContextDrawLinearGradient(context, topGradient, startPoint, endPoint, 0);
      CGContextRef context = UIGraphicsGetCurrentContext();
      
      CGFloat fillcolor[] = { kKeySideStartColor, kKeySideStartColor,
          kKeySideStartColor, 1.0 };
      
      // Setup a shadow
      CGContextSaveGState(context);
      CGContextSetShadow(context, CGSizeMake(0.0,  -3.0), 4.0);
      
      CGContextBeginPath(context);
      
      CGRect fillRect = [self shrinkRect:rect amount:4];
//      fillRect.size.height -= 5;
//      fillRect.size.width -= 2;
      fillRect.size.height -= 12;
      fillRect.size.width -= 6;
      fillRect.origin.x += 3;
      fillRect.origin.y += 0;
      
      //  CGContextSetLineWidth(context, 1.0);
      //  CGContextSetLineJoin(context, kCGLineJoinRound);
      //  CGContextSetStrokeColor(context, fillcolor);
      //  CGContextAddRect(context, fillRect);
      //  CGContextStrokePath(context);
      
      // Turn off the shadow
      CGContextRestoreGState(context);
      
      fillcolor[0] = kKeyPressedColor;
      fillcolor[1] = kKeyPressedColor;
      fillcolor[2] = kKeyPressedColor;
      
      fillRect = [self shrinkRect:fillRect amount:keyBorderWidth];
      fillRect.origin.y -= 1;
      
      CGContextSetStrokeColor(context, fillcolor);
      CGContextSetLineJoin(context, kCGLineJoinRound);
      CGContextSetLineWidth(context, 7.0);
      CGContextAddRect(context, fillRect);
      CGContextStrokePath(context);
      
      CGContextSetFillColor(context, fillcolor);
      CGContextFillRect(context, fillRect);
      

  } else {
      CGContextRef context = UIGraphicsGetCurrentContext();
      
      CGFloat fillcolor[] = { kKeySideStartColor, kKeySideStartColor,
          kKeySideStartColor, 1.0 };
      
      // Setup a shadow
      CGContextSaveGState(context);
      CGContextSetShadow(context, CGSizeMake(0.0,  -3.0), 4.0);
      
      CGContextBeginPath(context);
      
      CGRect fillRect = [self shrinkRect:rect amount:4];
      fillRect.size.height -= 5;
      fillRect.size.width -= 2;
      
      //  CGContextSetLineWidth(context, 1.0);
      //  CGContextSetLineJoin(context, kCGLineJoinRound);
      //  CGContextSetStrokeColor(context, fillcolor);
      //  CGContextAddRect(context, fillRect);
      //  CGContextStrokePath(context);
      
      // Turn off the shadow
      CGContextRestoreGState(context);
      
      fillcolor[0] = kKeyTopColor;
      fillcolor[1] = kKeyTopColor;
      fillcolor[2] = kKeyTopColor;
      
      fillRect = [self shrinkRect:fillRect amount:keyBorderWidth];
      fillRect.origin.y -= 1;
      
      CGContextSetStrokeColor(context, fillcolor);
      CGContextSetLineJoin(context, kCGLineJoinRound);
      CGContextSetLineWidth(context, 7.0);
      CGContextAddRect(context, fillRect);
      CGContextStrokePath(context);
      
      CGContextSetFillColor(context, fillcolor);
      CGContextFillRect(context, fillRect);
      
      fillcolor[0] = kKeySideEndColor;
      fillcolor[1] = kKeySideEndColor;
      fillcolor[2] = kKeySideEndColor;
      
      fillRect = [self shrinkRect:fillRect amount:-2];
      
      CGContextSetStrokeColor(context, fillcolor);
      CGContextSetLineJoin(context, kCGLineJoinRound);
      CGContextSetLineWidth(context, 0.0);
      CGContextAddRect(context, fillRect);
      CGContextStrokePath(context);
  }
}

@end
