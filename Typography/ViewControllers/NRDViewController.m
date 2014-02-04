//
//  NRDViewController.m
//  Typography
//
//  Created by Ben Dolmar on 1/14/14.
//  Copyright (c) 2014 Ben Dolmar. All rights reserved.
//

#import "NRDViewController.h"
#import <CoreText/SFNTLayoutTypes.h>

const double kMillilitersPerHogshead = 238480.942;
NSString *const kStringTemplate = @"There are %@\nmilliliters in a hogshead.";
NSString *const kFontName = @"HoeflerText-Regular";
const CGFloat kKerningAmount = -20.0f;
const CGFloat kLineSpacingFactor = 0.25f;

@interface NRDViewController ()

@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.groupingSize = 3;
    self.formatter.usesGroupingSeparator = YES;
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;

    [self updateLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredContentSizeChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)preferredContentSizeChanged:(NSNotification *)note
{
    [self updateLabel];
}

- (void)updateLabel
{
    UIFont *preferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    CGFloat fontSize = preferredFont.pointSize;
    UIFont *labelFont = [self modifyFont:[UIFont fontWithName:kFontName size:fontSize]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kLineSpacingFactor * fontSize;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSNumber *kerning = @(fontSize * (kKerningAmount / 1000));
    NSDictionary *attributes = @{NSKernAttributeName : kerning,
                                 NSFontAttributeName : labelFont,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    
    NSString *formattedNumber = [[self.formatter stringFromNumber:@(kMillilitersPerHogshead)] lowercaseString];
    NSString *labelString = [NSString stringWithFormat:kStringTemplate, formattedNumber];
    NSAttributedString *labelAttribString = [[NSAttributedString alloc] initWithString:labelString
                                                                            attributes:attributes];
    self.label.attributedText = labelAttribString;
}

- (UIFont *)modifyFont:(UIFont *)font
{
    UIFontDescriptor *baseDescriptor = font.fontDescriptor;
    
    NSArray *fontFeatures = @[@{UIFontFeatureTypeIdentifierKey:@(kNumberCaseType),
                                UIFontFeatureSelectorIdentifierKey:@(kUpperCaseNumbersSelector)}];
    
    UIFontDescriptor *modifiedDescriptor = [baseDescriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute: fontFeatures}];
    
    return [UIFont fontWithDescriptor:modifiedDescriptor size:0.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
