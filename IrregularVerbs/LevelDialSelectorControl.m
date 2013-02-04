//
//  LevelDialSelectorControl.m
//  IrregularVerbs
//
//  Created by Oswaldo Rubio on 28/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "LevelDialSelectorControl.h"
#import "UIColor+IrregularVerbs.h"
#import <QuartzCore/QuartzCore.h>


@interface LevelDialSelectorControl()
- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;
@end
static float deltaAngle;

@implementation LevelDialSelectorControl
@synthesize delegate, container, numberOfSections,startTransform,sectors,currentSector;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber  initialSection:(int) initSection;{
    // 1 - Call super init
    if ((self = [super initWithFrame:frame])) {
        // 2 - Set properties
         self.currentSector = initSection;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        // 3 - Draw wheel
        [self drawWheel];

	}
    return self;
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // 1 - Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    // 1.1 - Get the distance from the center
    float dist = [self calculateDistanceFromCenter:touchPoint];
    // 1.2 - Filter out touches too close to the center
    if (dist < 20 || dist > 200)
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    // 2 - Calculate distance from center
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    // 3 - Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    // 4 - Save current transform
    startTransform = container.transform;
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
     
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x  - container.center.x;
    float dy = pt.y  - container.center.y;
    float ang = atan2(dy,dx);
     
    float angleDifference = deltaAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference*1.5);
    return YES;
}
 

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (SectorDial *s in sectors) {
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sector;
        }
    }
    // 7 - Set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    
     [self.delegate dialDidChangeValue:currentSector];
}
-(void)turnLeft
{
 if(currentSector ==0)
     currentSector =numberOfSections -1;
 else
    currentSector--;
     CGFloat angleSize = 2*M_PI/numberOfSections;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, angleSize);
    container.transform = t;
    [UIView commitAnimations];
 
      [self.delegate dialDidChangeValue:currentSector];
    
}
-(void)turnRight
{
   if(currentSector == numberOfSections-1)
       currentSector = 0;
    else
        currentSector++;
    CGFloat angleSize = 2*M_PI/numberOfSections;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -angleSize);
    container.transform = t;
    [UIView commitAnimations];
 
    [self.delegate dialDidChangeValue:currentSector];
}
 
- (void) drawWheel {
    //the initial angle offset (top of the dial)
    CGFloat offsetAngle = M_PI/2;
    // 1
    container = [[UIView alloc] initWithFrame:self.frame];
    // 2
    int labelWidth= 130;
    int labelHeight= 30;
    CGFloat angleSize = 2*M_PI/numberOfSections;
    for (int i = 0; i < numberOfSections; i++) {
        // 4 - Create image view
        int absIndex = (i+currentSector)%numberOfSections ;
        
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"sectorImage%i.png",absIndex ]]];
        UILabel *lbltxt = [[UILabel alloc] init];
        
        NSString *txt = [NSString stringWithFormat:@"LevelLabel_%i",absIndex];
        [lbltxt setText:NSLocalizedString(txt,nil) ];
        [lbltxt setFont:[UIFont fontWithName:@"Signika" size:16]];
        [lbltxt setBackgroundColor:[UIColor appTintColor]];
        [lbltxt setTextColor:[UIColor whiteColor]];
        [lbltxt setShadowColor:[UIColor lightGrayColor]];
        [lbltxt setShadowOffset:CGSizeMake(1.0, 1.0)];
        [lbltxt setAccessibilityHint:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(txt,nil) , NSLocalizedString(@"accesibility_dialselectorhint",nil)]];

        [im addSubview:lbltxt];
        
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
       
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                        container.bounds.size.height/2.0-container.frame.origin.y);
        
        [[lbltxt layer] setAnchorPoint:CGPointMake(0.0f, 1.0f)];
        [[lbltxt layer] setPosition:CGPointMake(64,im.bounds.size.height/2.0+labelWidth/2.0)];
        [lbltxt setBounds:CGRectMake(0, 0, labelWidth, labelHeight)];
        lbltxt.textAlignment = NSTextAlignmentCenter;
       
        
        
        lbltxt.transform = CGAffineTransformMakeRotation(-M_PI/2);
        im.transform = CGAffineTransformMakeRotation(angleSize*(i) +offsetAngle );
 
        im.tag = i;
   
 
        // 6 - Add image view to container
        [container addSubview:im];
	}
 
    
    // 7
    container.userInteractionEnabled = NO;
    [self addSubview:container];
 
    // 8 - Initialize sectors
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
     
    [self.delegate dialDidChangeValue:currentSector];
}
- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}
- (void) buildSectorsOdd {
	// 1 - Define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
	// 2 - Set initial midpoint
    CGFloat mid = 0;
	// 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        SectorDial *sector = [[SectorDial alloc] init];
		// 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = (i+currentSector)%numberOfSections;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
		// 5 - Add sector to array
        [sectors addObject:sector];

    }
}
- (void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        SectorDial *sector = [[SectorDial alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
            
        }
        mid -= fanWidth;
        
        // 5 - Add sector to array
        [sectors addObject:sector];
    }
}
@end
