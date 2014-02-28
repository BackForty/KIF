//
//  UIScrollView-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/22/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UIScrollView-KIFAdditions.h"
#import "LoadableCategory.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-KIFAdditions.h"


MAKE_CATEGORIES_LOADABLE(UIScrollView_KIFAdditions)


@implementation UIScrollView (KIFAdditions)

- (void)scrollViewToVisible:(UIView *)view animated:(BOOL)animated;
{
    BOOL needsUpdate = NO;
    [view layoutSubviews];

    CGRect scrollFrame = self.frame;

    CGPoint viewOrigin = [self.window convertPoint:view.frame.origin fromView:view.superview];
    CGPoint scrollOrigin = [self.window convertPoint:scrollFrame.origin fromView:self.superview];

    CGPoint viewOuterCorner = CGPointMake(viewOrigin.x + view.frame.size.width, viewOrigin.y + view.frame.size.height);
    CGPoint scrollOuterCorner = CGPointMake(scrollOrigin.x + scrollFrame.size.width, scrollOrigin.y + scrollFrame.size.height);

    CGPoint offsetPoint = self.contentOffset;

    if (viewOuterCorner.x > scrollOuterCorner.x || viewOrigin.x < scrollOrigin.x) {
        // The view is to the right of the view port, scroll it into view
        CGPoint windowOffset = CGPointMake(viewOrigin.x, 0);
        windowOffset = [self.window convertPoint:windowOffset toView:self];

        offsetPoint.x = windowOffset.x;
        needsUpdate = YES;
    }

    if (viewOuterCorner.y > scrollOuterCorner.y || viewOrigin.y < scrollOrigin.y) {
        // The view is below the view port, so scroll it into view
        CGPoint windowOffset = CGPointMake(0, viewOrigin.y);
        windowOffset = [self.window convertPoint:windowOffset toView:self];

        offsetPoint.y = windowOffset.y;
        needsUpdate = YES;
    }

    if (needsUpdate) {
        offsetPoint.x = MIN(offsetPoint.x, self.contentSize.width - scrollFrame.size.width);
        offsetPoint.y = MIN(offsetPoint.y, self.contentSize.height - scrollFrame.size.height);

        [self setContentOffset:offsetPoint animated:animated];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.2, false);
    }
}

@end
