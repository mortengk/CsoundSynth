
#import <UIKit/UIKit.h>

typedef enum
{
	RotaryKnobInteractionStyleRotating,
	RotaryKnobInteractionStyleSliderHorizontal,
	RotaryKnobInteractionStyleSliderVertical
}
RotaryKnobInteractionStyle;

@interface RotaryKnob : UIControl

@property (nonatomic, assign) RotaryKnobInteractionStyle interactionStyle;
@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, strong) UIImage* foregroundImage;
@property (nonatomic, strong, readonly) UIImage* currentKnobImage;
@property (nonatomic, assign) CGPoint knobImageCenter;
@property (nonatomic, assign) float maximumValue;
@property (nonatomic, assign) float minimumValue;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float defaultValue;
@property (nonatomic, assign) BOOL resetsToDefault;
@property (nonatomic, assign) BOOL continuous;
@property (nonatomic, assign) float scalingFactor;

- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setKnobImage:(UIImage *)image forState:(UIControlState)state;
- (UIImage *)knobImageForState:(UIControlState)state;

@end
