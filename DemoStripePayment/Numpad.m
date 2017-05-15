//
//  Numpad.m
//  TGFormaTraining
//
//  Created by Luca Giorgetti on 10/01/14.
//  Copyright (c) 2014 Fabio Masini. All rights reserved.
//

#import "Numpad.h"

@implementation Numpad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNib:frame];
    }
    return self;
}

-(void)loadNib:(CGRect)frame{
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    [mainBundle loadNibNamed:@"NumberKeyboard" owner:self options:nil];
    self.contentView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);

    [self.keyOne setBackgroundImage:[[self.keyOne backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyTwo setBackgroundImage:[[self.keyTwo backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyThree setBackgroundImage:[[self.keyThree backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyFour setBackgroundImage:[[self.keyFour backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyFive setBackgroundImage:[[self.keyFive backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keySix setBackgroundImage:[[self.keySix backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keySeven setBackgroundImage:[[self.keySeven backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyEight setBackgroundImage:[[self.keyEight backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyNine setBackgroundImage:[[self.keyNine backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyZero setBackgroundImage:[[self.keyZero backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyPeriod setBackgroundImage:[[self.keyPeriod backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyMinus setBackgroundImage:[[self.keyMinus backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyBack setBackgroundImage:[[self.keyBack backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:79] forState:UIControlStateNormal];
    [self.keyReturn setBackgroundImage:[[self.keyReturn backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:8 topCapHeight:251] forState:UIControlStateNormal];
    
    [self.keyBack addTarget:self action:@selector(keyBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyReturn addTarget:self action:@selector(keyReturnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyPeriod addTarget:self action:@selector(keyPeriodAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyMinus addTarget:self action:@selector(keyMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keyOne addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyTwo addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyThree addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyFour addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyFive addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keySix addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keySeven addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyEight addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyNine addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyZero addTarget:self action:@selector(keyNumberAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.keyPeriod.hidden = !self.showsPeriod;
    self.keyMinus.hidden = !self.showsMinus;
    self.keyMinus.selected = [self.textField.text hasPrefix:@"-"];
    
    [self initLayouts];
    [self addSubview:self.contentView];
}

-(void)initLayouts{
        self.keyOne.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyTwo.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyThree.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyFour.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyFive.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keySix.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keySeven.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyEight.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyNine.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyZero.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyPeriod.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyBack.titleLabel.font = [UIFont systemFontOfSize:24];
        self.keyReturn.titleLabel.font = [UIFont systemFontOfSize:24];
}

-(void)keyBackAction{
    if(self.textField.text.length > 0)
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length-1];
}

-(void)keyReturnAction{
    [self.textField.delegate textFieldShouldReturn:self.textField];
}

-(void)keyPeriodAction{
    if(!self.textField.text || [self.textField.text isEqualToString:@""])
        self.textField.text = @"0";
    
    if([self.textField.text isEqualToString:@"-"])
        self.textField.text = @"-0";
    
    self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    self.textField.text = [self.textField.text stringByAppendingString:@"."];
}

-(void)keyMinusAction{
    self.keyMinus.selected = !self.keyMinus.selected;
    
    if([self.textField.text hasPrefix:@"-"])
        self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    else
        self.textField.text = [@"-" stringByAppendingString:self.textField.text];
}

-(void)keyNumberAction:(UIButton*)sender{
    if([[self.textField.text stringByAppendingString:sender.titleLabel.text] length]>6)
        return;
    self.textField.text = [self.textField.text stringByAppendingString:sender.titleLabel.text];
}

@end
