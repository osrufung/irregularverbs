//
//  VSRotatingView.h
//  ImageScroller
//
//  Created by Anurag Solanki on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol RotatingViewDelegate

- (void)viewCirculatedToSegmentIndex:(NSUInteger)index;

@end

@interface VSRotatingView : UIView
{
    CGFloat normalWellnessDialYPosition, normalWellnessDialOverlayYPosition;
    int rotation;
    CGFloat initialAngle;
    CGAffineTransform initialTransform;

    AVAudioPlayer *audioPlayer;

}

@property (nonatomic, retain) IBOutlet UIImageView *wellnessDial;
@property (nonatomic, retain) IBOutlet UIImageView *wellnessDialOverlay;
@property (nonatomic, assign) id rotatingViewDelegate;

-(void) setupGestures;
//-(void) rotate:(int) move;


@end
