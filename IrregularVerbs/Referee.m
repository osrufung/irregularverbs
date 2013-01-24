//
//  Referee.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 08/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "Referee.h"
#import "HomeViewController.h"

#define MAX_TEST_TIME   10.f

@interface Referee()
{
    NSArray *_colors;
}

@end

@implementation Referee

@synthesize maxValue = _maxValue;

+ (Referee *)sharedReferee {
    static Referee *_sharedReferee = nil;
    if (!_sharedReferee) {
        _sharedReferee = [[super allocWithZone:nil] init];
    }
    return _sharedReferee;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedReferee];
}

- (id)init {
    self = [super init];
    if (self) {
        _colors = @[TURQUESATINT, TURQUESATINT, [UIColor orangeColor], ROJOTINT];
    }
    return self;
}

- (float)maxValue {
    if (_maxValue==0) {
        _maxValue = [[NSUserDefaults standardUserDefaults] floatForKey:@"refereeMaxValue"];
        if (_maxValue==0) _maxValue = MAX_TEST_TIME;
    }
    return _maxValue;
}

- (void)setMaxValue:(float)maxValue {
    if(_maxValue!=maxValue){
        _maxValue=maxValue;
        [[NSUserDefaults standardUserDefaults] setFloat:_maxValue forKey:@"refereeMaxValue"];
    }
}

- (float)performanceForValue:(float)value {
    return value/self.maxValue;
}

- (UIColor *)colorForFail {
    return _colors[_colors.count-1];
}

- (UIColor *)colorForValue:(float)value {
    float per = [self performanceForValue:value];
    float rf = 1.0f/(_colors.count-1);
    
    for (int i=0; i<_colors.count-1; i++) {
        float limInf = i*rf;
        float limSup = (i+1)*rf;
        if ((limInf<=per)&&(per<limSup)) {
            return [self interpolateBetween:_colors[i] and:_colors[i+1] atMix:(per-limInf)/rf];
        }
    }
    return _colors[_colors.count-1];
}

- (UIImage *)imageForFail {
    return [UIImage imageNamed:@"check_nok_red.png"];
    //return [self paintImage:[UIImage imageNamed:@"check_nok_red.png"] withColor:_colors[_colors.count-1]];
}

- (UIImage *)imageForValue:(float)value {
    return [UIImage imageNamed:@"check_ok_green.png"];
    //return [self paintImage:[UIImage imageNamed:@"check_ok_green.png"] withColor:[self colorForValue:value]];
}

- (UIColor *)interpolateBetween:(UIColor *)c1 and:(UIColor *)c2 atMix:(float)mix {
    float r1,g1,b1,a1,r2,g2,b2,a2;
    
    [c1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return [UIColor colorWithRed:r1+(r2-r1)*mix
                           green:g1+(g2-g1)*mix
                            blue:b1+(b2-b1)*mix
                           alpha:a1+(a2-a1)*mix];
}

-(UIImage *)paintImage:(UIImage *)image withColor:(UIColor *)color
{
    UIImage *img;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    [image drawAtPoint:CGPointZero blendMode:kCGBlendModeDestinationIn alpha:0.4];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
