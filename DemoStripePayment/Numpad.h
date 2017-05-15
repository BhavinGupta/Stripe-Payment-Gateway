//
//  Numpad.h
//  TGFormaTraining
//
//  Created by Luca Giorgetti on 10/01/14.
//  Copyright (c) 2014 Fabio Masini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Numpad : UIView


@property(nonatomic, strong) IBOutlet UIView *contentView;
@property(nonatomic, strong) IBOutlet UIButton *keyBack;
@property(nonatomic, strong) IBOutlet UIButton *keyPeriod;
@property(nonatomic, strong) IBOutlet UIButton *keyMinus;
@property(nonatomic, strong) IBOutlet UIButton *keyReturn;

@property(nonatomic, strong) IBOutlet UIButton *keyOne;
@property(nonatomic, strong) IBOutlet UIButton *keyTwo;
@property(nonatomic, strong) IBOutlet UIButton *keyThree;
@property(nonatomic, strong) IBOutlet UIButton *keyFour;
@property(nonatomic, strong) IBOutlet UIButton *keyFive;
@property(nonatomic, strong) IBOutlet UIButton *keySix;
@property(nonatomic, strong) IBOutlet UIButton *keySeven;
@property(nonatomic, strong) IBOutlet UIButton *keyEight;
@property(nonatomic, strong) IBOutlet UIButton *keyNine;
@property(nonatomic, strong) IBOutlet UIButton *keyZero;

@property (nonatomic, assign) UITextField *textField;
@property (nonatomic) BOOL showsPeriod;
@property (nonatomic) BOOL showsMinus;

@end
