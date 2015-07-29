//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Brandon Wade on 7/28/15.
//  Copyright (c) 2015 Brandon Wade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

 - (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;

@end

@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;


@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;

@end
