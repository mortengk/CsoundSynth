//
//  WhiteKeyView.m
//  mobilesynth
//
//  Created by Allen Porter on 4/5/09.
//  Copyright 2009 thebends. All rights reserved.
//

#import "WhiteKeyView.h"
//#include "CoreFoundation/CoreFoundation.h"
#include "CoreGraphics/CoreGraphics.h"
//#include "ApplicationServices/ApplicationServices.h"


@implementation WhiteKeyView

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

static const CGFloat kKeySideStartColor = 0.78;
static const CGFloat kKeySideEndColor = 0.95;
static const CGFloat kKeyTopColor = 0.98;
static const CGFloat kKeyPressedColor = .8;

- (void)drawRect:(CGRect)rect {
    if (keyPressed) {
        //    // When the key is pressed, draw an extra alpha gradient on top.
        //    CGFloat colors[8] = { 0.1, 0.1, 0.1, 0.0, 0.1, 0.1, 0.1, 0.8 };
        //    CGFloat locations[2] = { 1, 0 };
        //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //    CGGradientRef topGradient =
        //        CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        //
        //    CGPoint startPoint;
        //    startPoint.x = 1;
        //    startPoint.y = 1;
        //    CGPoint endPoint;
        //    endPoint.x = rect.size.width - 1;
        //    endPoint.y = rect.size.height - 1;
        //    CGContextDrawLinearGradient(context, topGradient, startPoint, endPoint, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat fillcolor[] = { kKeySideStartColor,
            kKeySideStartColor,
            kKeySideStartColor, 1.0 };
        
        // Setup a shadow
        CGContextSaveGState(context);
        CGContextSetShadow(context, CGSizeMake(0.0,  -3.0), 4.0);
        
        CGContextBeginPath(context);
        
        CGRect fillArea = [self shrinkRect:rect amount:4];
        //fillArea.size.width -= 2;
        
        fillArea.size.height -= 10;
        fillArea.size.width -= 8;
        fillArea.origin.x += 4;
        fillArea.origin.y += 0;
        
        //    // satt 10 til 1
        //  CGContextSetLineWidth(context, 1.0);
        //  CGContextSetLineJoin(context, kCGLineJoinRound);
        //  CGContextSetStrokeColor(context, fillcolor);
        //  CGContextAddRect(context, fillArea);
        //  CGContextStrokePath(context);
        
        // Turn off the shadow
        CGContextRestoreGState(context);
        
        fillcolor[0] = kKeyPressedColor;
        fillcolor[1] = kKeyPressedColor;
        fillcolor[2] = kKeyPressedColor;
        
        
        // amount is da shit
        fillArea = [self shrinkRect:fillArea amount:1];
        fillArea.origin.y -= 1;
        
        CGContextSetStrokeColor(context, fillcolor);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 7.0);
        CGContextAddRect(context, fillArea);
        CGContextStrokePath(context);
        
        CGContextSetFillColor(context, fillcolor);
        CGContextFillRect(context, fillArea);
        
        fillcolor[0] = kKeyPressedColor;
        fillcolor[1] = kKeyPressedColor;
        fillcolor[2] = kKeyPressedColor;
        
        fillArea = [self shrinkRect:fillArea amount:-2];
        
        CGContextSetStrokeColor(context, fillcolor);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddRect(context, fillArea);
        CGContextStrokePath(context);
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat fillcolor[] = { kKeySideStartColor,
            kKeySideStartColor,
            kKeySideStartColor, 1.0 };
        
        // Setup a shadow
        CGContextSaveGState(context);
        CGContextSetShadow(context, CGSizeMake(0.0,  -3.0), 4.0);
        
        CGContextBeginPath(context);
        
        CGRect fillArea = [self shrinkRect:rect amount:4];
        fillArea.size.width -= 2;
        
        //    // satt 10 til 1
        //  CGContextSetLineWidth(context, 1.0);
        //  CGContextSetLineJoin(context, kCGLineJoinRound);
        //  CGContextSetStrokeColor(context, fillcolor);
        //  CGContextAddRect(context, fillArea);
        //  CGContextStrokePath(context);
        
        // Turn off the shadow
        CGContextRestoreGState(context);
        
        fillcolor[0] = kKeyTopColor;
        fillcolor[1] = kKeyTopColor;
        fillcolor[2] = kKeyTopColor;
        
        
        // amount is da shit
        fillArea = [self shrinkRect:fillArea amount:1];
        fillArea.origin.y -= 1;
        
        CGContextSetStrokeColor(context, fillcolor);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 7.0);
        CGContextAddRect(context, fillArea);
        CGContextStrokePath(context);
        
        CGContextSetFillColor(context, fillcolor);
        CGContextFillRect(context, fillArea);
        
        fillcolor[0] = kKeySideEndColor;
        fillcolor[1] = kKeySideEndColor;
        fillcolor[2] = kKeySideEndColor;
        
        fillArea = [self shrinkRect:fillArea amount:-2];
        
        CGContextSetStrokeColor(context, fillcolor);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 0.0);
        CGContextAddRect(context, fillArea);
        CGContextStrokePath(context);
        
    }
}

@end
