//
//  AwesomeMenuItem.m
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AwesomeMenuItem.h"
static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}
@implementation AwesomeMenuItem

@synthesize contentImageView = _contentImageView;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = _delegate;

#pragma mark - initialization & cleaning up
- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg
label:(NSString *)labelString
{
    if (self = [super init]) 
    {
        self.image = img;
        self.highlightedImage = himg;
        self.userInteractionEnabled = YES;
        _contentImageView = [[UIImageView alloc] initWithImage:cimg];
        _contentImageView.highlightedImage = hcimg;
        [self addSubview:_contentImageView];
        CGRect labelFrame = CGRectMake(0, img.size.height - 15, img.size.width, 31);
        _menuItemLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _menuItemLabel.backgroundColor = [UIColor clearColor];
        _menuItemLabel.textColor = [UIColor whiteColor];
        _menuItemLabel.font = [UIFont systemFontOfSize:12.0f];
        _menuItemLabel.numberOfLines = 2;
        _menuItemLabel.textAlignment = NSTextAlignmentCenter;
        _menuItemLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _menuItemLabel.text = labelString;
        [self addSubview:_menuItemLabel];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(longPressAction:)];
        longPressRecognizer.delegate = self;
        [self addGestureRecognizer:longPressRecognizer];

    }
    return self;
}

- (void)updateLabel:(NSString *)labelString
{
    _menuItemLabel.text = labelString;
}

#pragma mark - UIView's methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}
// needed to enable edit menu
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
// edit menu callback to determine menu items
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        return YES;
    }
    if (action == @selector(delete:))
    {
        return YES;
    }
    if (action == @selector(editTitle:))
    {
        return YES;
    }

    return NO;
}
// show the edit menu on long press
- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self becomeFirstResponder];
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Edit Title" action:@selector(editTitle:)];
    UIMenuController *theMenu = [UIMenuController sharedMenuController];
    theMenu.menuItems = @[menuItem];
    [theMenu setTargetRect:self.frame inView:self.superview];
    [theMenu setMenuVisible:YES animated:YES];
}
- (void)copy:(id)sender
{
    if ([_delegate respondsToSelector:@selector(copyItem:)])
    {
        [_delegate copyItem:self];
    }
}

- (void)delete:(id)sender
{
    if ([_delegate respondsToSelector:@selector(deleteItem:)])
    {
        [_delegate deleteItem:self];
    }
}
- (void)editTitle:(id)sender
{
    if ([_delegate respondsToSelector:@selector(editItemTitle:)])
    {
    [_delegate editItemTitle:self];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesBegan:)])
    {
       [_delegate AwesomeMenuItemTouchesBegan:self];
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if move out of 2x rect, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        self.highlighted = NO;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    // if stop in the area of 2x rect, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
    {
        if ([_delegate respondsToSelector:@selector(AwesomeMenuItemTouchesEnd:)])
        {
            [_delegate AwesomeMenuItemTouchesEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [_contentImageView setHighlighted:highlighted];
}

@end
