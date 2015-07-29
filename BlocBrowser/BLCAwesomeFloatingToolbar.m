//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Brandon Wade on 7/28/15.
//  Copyright (c) 2015 Brandon Wade. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

@interface BLCAwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
//@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, weak) NSArray *buttons;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation BLCAwesomeFloatingToolbar

- (instancetype) initWithFourTitles: (NSArray *) titles {
    self = [super init];
    
    if (self) {
        
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        //make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            button.backgroundColor = colorForThisLabel;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
        
        /** self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture]; **/
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    
    }
    
    return self;
}

- (void) layoutSubviews {
    //set the frames for the 4 labels
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds)/2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds)/2;
        CGFloat labelX = 0;
        CGFloat labelY= 0;
        
        //adjust labelX and labelY for each label
        if (currentButtonIndex < 2) {
            //0 or 1, so on top
            labelY = 0;
        } else {
            //2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentButtonIndex % 2 == 0) { //if currentLabelIndex is evenly divisible by 2
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            //1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Gesture Handling

/** - (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.buttons containsObject:tappedView]) {
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
} **/

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.state ==  UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        
        self.transform = CGAffineTransformScale([[self.pinchGesture view]transform], self.pinchGesture.scale, self.pinchGesture.scale);
        
        [self.pinchGesture setScale:1];
    }
}

- (void)longPressFired:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        UIColor *touchColor = [[self.buttons objectAtIndex:0] backgroundColor];
        
        [[self.buttons objectAtIndex:0] setBackgroundColor:[[self.buttons objectAtIndex:1] backgroundColor]];
        [[self.buttons objectAtIndex:1] setBackgroundColor:[[self.buttons objectAtIndex:2] backgroundColor]];
        [[self.buttons objectAtIndex:2] setBackgroundColor:[[self.buttons objectAtIndex:3] backgroundColor]];
        [[self.buttons objectAtIndex:3] setBackgroundColor:touchColor];
    }
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}
@end
