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
#import "WMQuestionaire1.h"
#import "WMQuestionaire2.h"
#import "WMQuestionaire3.h"
#import "WMQuestionaire4.h"
#import "WMQuestionaire5.h"
#import "WMQuestionaire6.h"
#import "WMQuestionaire7.h"
#import "WMQuestionaire8.h"
#import "WMQuestionaire9.h"
#import "WMQuestionaire10.h"
#import "WMQuestionaire11.h"
#import "WMQuestionaire12.h"
#import "ActionSheetPicker.h"
#import "ACFloatingTextField.h"

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
        //Layout for Stack View
//        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
//        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;

        
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
                
                [self createDropdownViewWithData:questionnaire];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"matrix-table"]){
                
//                [self createCheckboxViewWithData:questionnaire];
                
            } else  if ([questionnaire[@"type"] isEqualToString:@"audio"] || [questionnaire[@"type"] isEqualToString:@"video"] || [questionnaire[@"type"] isEqualToString:@"image"]) {
                
               [self createImageUploadViewWithData:questionnaire];
                
            }

            
//            if ([questionnaire[@"type"] isEqualToString:@"audio"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire1" owner:self options:nil] objectAtIndex:0];
//                qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"video"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire2" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"image"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire3" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"text"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire4" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
////                qView.backgroundColor = [UIColor redColor];
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"radio-group"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire5" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"dropdown"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire6" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"matrix-table"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire7" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"textarea"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire1" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else  if ([questionnaire[@"type"] isEqualToString:@"checkbox-group"]) {
//                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire2" owner:self options:nil] objectAtIndex:0];
//                 qView.translatesAutoresizingMaskIntoConstraints = false;
//                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
//                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                [verStackView addArrangedSubview:qView];
//            } else
            
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
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
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
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
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
    
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textView setText:buttonTitle];
    [dropDownView addSubview:textView];
    [textView setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textView]-24-" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
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

    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textField setText:buttonTitle];
    [dropDownView addSubview:textField];
    [textField setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    
//    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
//    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
//    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textField(>=100)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
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
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
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
    UIStackView *verStackView = [self getStackView:stackView];
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
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
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-(24)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[titleLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
//    UIView *dropDownView = [self getStackSubView:verStackView];
//    
//    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
//    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
//    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
//    [dropDownView addSubview:dropDownButton];
//    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [dropDownButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
//    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
//    [dropDownView addSubview:dropDownImg];
//    
//    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
//    
//    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
