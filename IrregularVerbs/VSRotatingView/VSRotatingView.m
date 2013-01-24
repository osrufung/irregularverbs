//
//  VSRotatingView.m
//  ImageScroller
//
//  Created by Anurag Solanki on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VSRotatingView.h"
#import "VSConstant.h"
#include <QuartzCore/QuartzCore.h>

@implementation VSRotatingView

@synthesize wellnessDial, wellnessDialOverlay;
@synthesize rotatingViewDelegate;

+ (VSRotatingView *)new
{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"VSRotatingView" owner:nil options:nil];
    return [array objectAtIndex:0]; // assume that VSRotatingView is the only object in the xib
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
 

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    // Create and initialize the audio player.
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DialClick" ofType:@"caf"] isDirectory:NO] error:&error];
    audioPlayer.volume = 1.0;
    [audioPlayer prepareToPlay];
    
    normalWellnessDialYPosition = self.wellnessDial.layer.position.y;
    normalWellnessDialOverlayYPosition = self.wellnessDialOverlay.layer.position.y;
    
    [self setupGestures];
}


- (void) setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDialViewPan:)];
    [self.wellnessDial addGestureRecognizer:panRecognizer];
   
}

- (void)handleDialViewPan:(UIPanGestureRecognizer *)panRecognizer {
    
    // Pull out the current touch location of the pan gesture.
    CGPoint location = [panRecognizer locationInView:panRecognizer.view.superview];
    CGFloat segmentAngle = (2 * M_PI / NUMBER_OF_SEGMENTS); // 7 Pieces in the Dial PNG.
    
    CGPoint dialCenter = self.wellnessDial.center;
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        // Remember some initial values.
        initialAngle = atan2f(location.y - dialCenter.y, location.x - dialCenter.x);
        initialTransform = self.wellnessDial.transform;
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        // Calculate the angle between the start of the pan gesture and the current pan gesture location.
        CGFloat currentAngle = atan2f(location.y - dialCenter.y, location.x - dialCenter.x);
        self.wellnessDial.transform = CGAffineTransformRotate(initialTransform, currentAngle - initialAngle);
        
        // Calculate the nearest segment the user left the dial on.
        CGFloat currentDialAngle = atan2(self.wellnessDial.transform.b, self.wellnessDial.transform.a);
        
        // Normalize the angle from 0 to 2Pi.
        currentDialAngle += M_PI;
        NSInteger currentSegment = currentDialAngle / segmentAngle;
        NSInteger newRotation = currentSegment - 3; // Correct for the normalization.

        // Match up negative numbers to the wellness numbers.
        if (newRotation < 0)
            newRotation += NUMBER_OF_SEGMENTS;
        
        if (newRotation != rotation) {
            // Set our iVar with this new value.
            rotation = newRotation;
            
            // And play the click noise.
            if(PLAY_AUDIO)
                [audioPlayer play];
        }
    } else {
        // Center on the nearest segment.
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.wellnessDial.transform = CGAffineTransformMakeRotation(rotation * segmentAngle);
                         }
                         completion:NULL];
        
        [self callDelegateMethods];
    }
}
-(void)setCurrentSegment:(int)segment
{
    NSLog(@"set to segment %d",segment);
    CGFloat segmentAngle = (2 * M_PI / NUMBER_OF_SEGMENTS); // 7 Pieces in the Dial PNG.
 
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.wellnessDial.transform = CGAffineTransformMakeRotation(-segment * segmentAngle);
                     }
                     completion:NULL];
}

- (void)callDelegateMethods {
    CGFloat segmentAngle = (2 * M_PI / NUMBER_OF_SEGMENTS); // 7 Pieces in the Dial PNG.
    CGFloat currentDialAngle = atan2(self.wellnessDial.transform.b, self.wellnessDial.transform.a);
    
    // Normalize the angle from 0 to 2Pi.
    currentDialAngle += M_PI;
    NSInteger currentSegment = currentDialAngle / segmentAngle;
    NSInteger newRotation = currentSegment - 3; // Correct for the normalization.

    if (SEGMENT_ROTATION_DIRECTION == 1) {
        if (newRotation <= 0)
            newRotation += NUMBER_OF_SEGMENTS;
        newRotation = NUMBER_OF_SEGMENTS - newRotation;
    }
    else {
        if (newRotation < 0)
            newRotation += NUMBER_OF_SEGMENTS;  // (segment index ranges from 0 to NUMBER_OF_SEGMENTS)
    }
    
    if ([rotatingViewDelegate respondsToSelector:@selector(viewCirculatedToSegmentIndex:)]) {
        [rotatingViewDelegate viewCirculatedToSegmentIndex:newRotation];
    }
}

 

@end
