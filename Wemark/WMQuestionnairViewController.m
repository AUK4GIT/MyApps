//
//  WMQuestionnairViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 27/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMQuestionnairViewController.h"
#import "WMDataHelper.h"
#import "WMWebservicesHelper.h"
#import "ActionSheetPicker.h"
#import "ACFloatingTextField.h"
#import <ACFloatingTextfield_Objc/ACFloatingTextField.h>

@interface WMQuestionnairViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
    @property(nonatomic, strong) NSArray *questionnaireArray;
    @property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
    @property (strong, nonatomic) IBOutlet ACFloatingTextField *dobTextField;
    @property (strong, nonatomic) ActionSheetDatePicker *actionSheetPicker;
    @property (strong, nonatomic) NSString *selectedDate;
@end

@implementation WMQuestionnairViewController
    {
        IBOutlet UIStackView *stackView;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:236/255.0 blue:243/255.0 alpha:1.0];

    self.questionnaireArray = [[NSArray alloc] init];
    [self getQuestionnaire];
}

    - (void)getQuestionnaire{
        NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
        [self showActivity];
        [[WMWebservicesHelper sharedInstance] getQuestionaire:authKey forAssignmentId:self.assignmentId forSectionId:self.sectionId completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
                NSLog(@"result:-> %@",result ? @"success" : @"Failed");
                if (result) {
                   self.questionnaireArray = [NSMutableArray arrayWithArray:responseDict];
                } else {
                    NSDictionary *resDict = responseDict;
                    if ([resDict[@"code"] integerValue] == 409) {
                        NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                    } else {
                        NSLog(@"Error:->  %@",error.localizedDescription);
                    }
                }
                //add UI related code here like stopping activity indicator
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideActivity];
                    [self showUI];
                });
           
         }];
                               
    }

    - (void)showUI {
   
        for (id questionnaire in self.questionnaireArray) {
            
            if ([questionnaire[@"type"] isEqualToString:@"date"]) {
                
                [self createDateViewWithData:questionnaire];
                
            }   else if ([questionnaire[@"type"] isEqualToString:@"text"]) {
                
                [self createTextFieldWithData:questionnaire];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"radio-group"]) {

                [self createRadioViewWithData:questionnaire];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"checkbox-group"]){
                
                [self createCheckboxViewWithData:questionnaire];
                
            } else  if ([questionnaire[@"type"] isEqualToString:@"textarea"]) {
                
                [self createTextViewWithData:questionnaire];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"dropdown"]) {
                
//                [self createDropdownViewWithData:questionnaire];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"matrix-table"]){
                
//                [self createCheckboxViewWithData:questionnaire];
                
            } else  if ([questionnaire[@"type"] isEqualToString:@"audio"] || [questionnaire[@"type"] isEqualToString:@"video"] || [questionnaire[@"type"] isEqualToString:@"image"]) {
                
               [self createImageUploadViewWithData:questionnaire];
                
            }
        }
    }

- (void)createRadioViewWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    for (id radioData in questionnaire[@"choices"]) {
        UIView *radioButtonView = [self getStackSubView:verStackView];
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.translatesAutoresizingMaskIntoConstraints = false;
//        NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
        [radioButton setBackgroundColor:[UIColor redColor]];
        [radioButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [radioButtonView addSubview:radioButton];
        [radioButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
        [radioButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
        if ([radioData[@"value"] isEqualToString:@"Yes"]) {
            [radioButton setSelected:true];
        }
        
        UILabel *radioLabel = [[UILabel alloc] init];
        radioLabel.translatesAutoresizingMaskIntoConstraints = false;
        [radioLabel setText:[self convertToString:radioData[@"text"]]];
        radioLabel.numberOfLines = 0;
        radioLabel.lineBreakMode = NSLineBreakByWordWrapping;
        radioLabel.textColor = [UIColor grayColor];
        [radioButtonView addSubview:radioLabel];

        
        [radioButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[radioButton(38)]-8-[radioLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(radioButton, radioLabel)]];
        
        [radioButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[radioButton(38)]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(radioButton)]];
    }
    
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];
    
}

- (void)createCheckboxViewWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    for (id radioData in questionnaire[@"choices"]) {
        UIView *radioButtonView = [self getStackSubView:verStackView];
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.translatesAutoresizingMaskIntoConstraints = false;
        //        NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
        [radioButton setBackgroundColor:[UIColor redColor]];
        [radioButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [radioButtonView addSubview:radioButton];
        [radioButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
        [radioButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
        if ([radioData[@"value"] isEqualToString:@"Yes"]) {
            [radioButton setSelected:true];
        }
        
        UILabel *radioLabel = [[UILabel alloc] init];
        radioLabel.translatesAutoresizingMaskIntoConstraints = false;
        [radioLabel setText:[self convertToString:radioData[@"text"]]];
        radioLabel.numberOfLines = 0;
        radioLabel.lineBreakMode = NSLineBreakByWordWrapping;
        radioLabel.textColor = [UIColor grayColor];
        [radioButtonView addSubview:radioLabel];
        
        
        [radioButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[radioButton(38)]-8-[radioLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(radioButton, radioLabel)]];
        
        [radioButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[radioButton(38)]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(radioButton)]];
    }
    
    
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];
    
}

- (void)createTextViewWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UITextView *textView = [[UITextView alloc] init];
//    textView.layer.shadowOffset = CGSizeMake(1, 1);
//    textView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    [textView.layer setShadowOpacity:1.0];
//    [textView.layer setShadowRadius:0.3];
//    textView.layer.masksToBounds = NO;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textView setText:buttonTitle.length ? buttonTitle : @"Comment"];
    [dropDownView addSubview:textView];
    [textView setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textView]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView(100)]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];
    
}

- (void)createTextFieldWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];

    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    ACFloatingTextField *textField = [[ACFloatingTextField alloc] init];
    textField.placeholder = @"Answer";
    textField.placeHolderColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    textField.borderStyle = UITextBorderStyleBezel;
    textField.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textField setText:buttonTitle];
    [dropDownView addSubview:textField];
    [textField setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    
//    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
//    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
//    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textField]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textField]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];
    
}

- (void)createDateViewWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    dropDownButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    dropDownButton.layer.borderWidth = 1.0f;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    if (buttonTitle.length == 0) {
        buttonTitle = @"Select a date";
    }
    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dropDownButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];

    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];

}

- (void)createDropdownViewWithData:(id)questionnaire{
    NSLog(@"Crash: %@",questionnaire);
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = questionnaire[@"model"] ? [self convertToString:questionnaire[@"model"]] : @"click to choose an option";
    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dropDownButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];
    
}

- (void)createImageUploadViewWithData:(id)questionnaire{
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
   
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"title"]];
    if (buttonTitle.length == 0) {
        buttonTitle = @"Upload";
    }
    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    if ([questionnaire[@"type"] isEqualToString:@"image"]) {
        [dropDownButton addTarget:self action:@selector(uploadImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([questionnaire[@"type"] isEqualToString:@"audio"]) {
        [dropDownButton addTarget:self action:@selector(uploadAudioClicked:) forControlEvents:UIControlEventTouchUpInside];
    }  else if ([questionnaire[@"type"] isEqualToString:@"video"]) {
        [dropDownButton addTarget:self action:@selector(uploadVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];
    
    
    UIView *nextPrevButtonView = [self getStackSubView:verStackView];
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.translatesAutoresizingMaskIntoConstraints = false;
    [prevButton setTitle:@"BACK" forState:UIControlStateNormal];
    [prevButton setBackgroundColor:[UIColor grayColor]];
    [nextPrevButtonView addSubview:prevButton];
    [prevButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:229/255.0 green:26/255.0 blue:75/255.0 alpha:1.0]];
    [nextPrevButtonView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==120)]-16-[nextButton(120)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[prevButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton)]];

}



- (void)uploadVideoClicked:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
//    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:@[UIImagePickerControllerS]];

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Capture Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeImage];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];

}

- (void)uploadAudioClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:@[UIImagePickerControllerS]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeImage];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

- (void)uploadImageClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:@[UIImagePickerControllerS]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeImage];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}


- (void)removeImage {
    
}
- (void)dateDropDownSelected:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    NSDate *curentDate = maxDate;
    if (self.selectedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        curentDate = [dateFormatter dateFromString:self.selectedDate];
    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:curentDate
        target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    //    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
   
}

-(void)dateWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.dobTextField.text = [dateFormatter stringFromDate:selectedTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedDate = [dateFormatter stringFromDate:selectedTime];

}

- (void)nextAction:(id)sender {
    if ((self.scrollView.contentSize.width - self.scrollView.contentOffset.x) <= self.scrollView.bounds.size.width) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+self.scrollView.bounds.size.width, 0.0f) animated:YES];
}

- (void)backAction:(id)sender {
    if (self.scrollView.contentOffset.x <= 0) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x-self.scrollView.bounds.size.width, 0.0f) animated:YES];
}

- (UIStackView *)getStackView:(UIStackView *)horStackView {
    UIStackView *vertStackView = [[UIStackView alloc] init];
    [vertStackView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
    vertStackView.axis = UILayoutConstraintAxisVertical;
    vertStackView.distribution = UIStackViewDistributionFill;
    vertStackView.alignment = UIStackViewAlignmentTop;
    vertStackView.spacing = 0;
    vertStackView.translatesAutoresizingMaskIntoConstraints = false;
    [horStackView addArrangedSubview:vertStackView];
    return vertStackView;
}

- (UIView *)getStackSubView:(UIStackView *)vertStackView {
    UIView *sview = [[UIView alloc] init];
    sview.translatesAutoresizingMaskIntoConstraints = false;
    sview.backgroundColor = [UIColor whiteColor];
    [vertStackView addArrangedSubview:sview];
    [vertStackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sview]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(sview)]];
    [vertStackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sview(50@300)]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(sview)]];
    return sview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.profilePic.image = chosenImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imgName = @"temp";
    NSString *imgPath = [paths[0] stringByAppendingPathComponent:imgName];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0);
    [data writeToFile:imgPath atomically:true];
    
    // Save it's path
//    self.profilePicURL = imgPath;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
