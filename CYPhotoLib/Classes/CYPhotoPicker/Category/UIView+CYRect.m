//
//  UIView+CYRect.m
//  PhotoLibDemo
//
//  Created by Cyrill on 16/7/18.
//  Copyright © 2016年 Cyrill. All rights reserved.
//

#import "UIView+CYRect.h"

@implementation UIView (CYRect)

//h
- (void)setH:(float)h {
    CGRect frm = self.frame;
    frm.size.height = h;
    self.frame = frm;
}

- (float)h {
    return self.frame.size.height;
}

//w
- (void)setW:(float)w {
    CGRect frm = self.frame;
    frm.size.width = w;
    self.frame = frm;
}

- (float)w {
    return self.frame.size.width;
}


//x
- (void)setX:(float)x {
    CGRect frm = self.frame;
    frm.origin.x = x;
    self.frame = frm;
}

- (float)x {
    return self.frame.origin.x;
}

//y
- (void)setY:(float)y {
    CGRect frm = self.frame;
    frm.origin.y = y;
    self.frame = frm;
}

- (float)y {
    return self.frame.origin.y;
}


@end
