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
#import "ActionSheetPicker.h"
#import "WMQuestionnaireModel.h"

@interface WMQuestionnairViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
    @property(nonatomic, strong) NSArray *questionnaireArray;
    @property(nonatomic, strong) NSMutableArray *questionnaireModel;
    @property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
//    @property (strong, nonatomic) IBOutlet ACFloatingTextField *dobTextField;
    @property (strong, nonatomic) ActionSheetDatePicker *actionSheetPicker;
//    @property (strong, nonatomic) NSString *selectedDate;
@end

@implementation WMQuestionnairViewController
    {
        IBOutlet UIStackView *stackView;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];

    self.questionnaireArray = [[NSArray alloc] init];
    self.questionnaireModel = [[NSMutableArray alloc] init];
    [self getQuestionnaire];
    
    
    UIView *nextPrevButtonView = [[UIView alloc] init];
    nextPrevButtonView.translatesAutoresizingMaskIntoConstraints = false;
    nextPrevButtonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nextPrevButtonView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[nextPrevButtonView]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(nextPrevButtonView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nextPrevButtonView(54)]-16-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(nextPrevButtonView)]];

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
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[prevButton(==nextButton)]-4-[nextButton]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];
    
    [nextPrevButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[prevButton(==nextButton)]-2-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(prevButton, nextButton)]];

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
   
        for (int i=0; i<self.questionnaireArray.count;i++) {
            id questionnaire = self.questionnaireArray[i];
            
            if ([questionnaire[@"type"] isEqualToString:@"date"] || [questionnaire[@"type"] isEqualToString:@"time"] || [questionnaire[@"type"] isEqualToString:@"time-range"]) {
                
                [self createDateViewWithData:questionnaire index:i];
                
            }   else if ([questionnaire[@"type"] isEqualToString:@"text"]) {
                
                [self createTextFieldWithData:questionnaire  index:i];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"radio-group"]) {

                [self createRadioViewWithData:questionnaire  index:i];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"checkbox-group"]){
                
                [self createCheckboxViewWithData:questionnaire  index:i];
                
            } else  if ([questionnaire[@"type"] isEqualToString:@"textarea"]) {
                
                [self createTextViewWithData:questionnaire  index:i];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"dropdown"]) {
                
                [self createDropdownViewWithData:questionnaire  index:i];
                
            } else if ([questionnaire[@"type"] isEqualToString:@"matrix-table"]){
                
                [self createCheckboxViewWithData:questionnaire  index:i];
                
            } else  if ([questionnaire[@"type"] isEqualToString:@"audio"] || [questionnaire[@"type"] isEqualToString:@"video"] || [questionnaire[@"type"] isEqualToString:@"image"]) {
                
               [self createImageUploadViewWithData:questionnaire  index:i];
                
            }
        }
    }

- (void)createRadioViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    
    UIView *titleView = [self getStackSubView:verStackView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    id choices = questionnaire[@"choices"];
    for (int i=0; i<[choices count];i++) {
        
        id radioData = choices[i];
        UIView *radioButtonView = [self getStackSubView:verStackView];
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.translatesAutoresizingMaskIntoConstraints = false;
        radioButton.tag = i;
//      NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
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
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    model.value = [self convertToString:questionnaire[@"model"]];
    [self.questionnaireModel addObject:model];
    
}

- (void)createCheckboxViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    id choices = questionnaire[@"choices"];
    for (int i=0; i<[choices count];i++) {
        id radioData = choices[i];
        UIView *radioButtonView = [self getStackSubView:verStackView];
        
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.translatesAutoresizingMaskIntoConstraints = false;
        radioButton.tag = i;
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
    
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    model.value = [self convertToString:questionnaire[@"model"]];
    [self.questionnaireModel addObject:model];
    
    
}

- (void)createTextViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.tag = index;
    textView.delegate = self;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textView setText:buttonTitle.length ? buttonTitle : @"Comment"];
    [dropDownView addSubview:textView];
    [textView setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    model.value = buttonTitle;
    [self.questionnaireModel addObject:model];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textView]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView(100)]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
    
}

- (void)createTextFieldWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    
    UIView *titleView = [self getStackSubView:verStackView];
//    titleView.backgroundColor = [UIColor redColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
//    titleLabel.backgroundColor = [UIColor greenColor];

    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
//    dropDownView.backgroundColor = [UIColor blueColor];

    ACFloatingTextField *textField = [[ACFloatingTextField alloc] init];
//    textField.backgroundColor = [UIColor orangeColor];

    textField.tag = index;
    textField.delegate = self;
    textField.placeholder = @"Answer";
    textField.placeHolderColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    textField.lineColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    textField.selectedLineColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];

    textField.selectedPlaceHolderColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];

    textField.borderStyle = UITextBorderStyleBezel;
    textField.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    [textField setText:buttonTitle];
    [dropDownView addSubview:textField];
//    [textField setTextColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    [textField setTextColor:[UIColor darkGrayColor]];

    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    model.value = buttonTitle;
    [self.questionnaireModel addObject:model];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[textField]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textField]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
}

- (void)createDateViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dropDownButton setContentEdgeInsets:UIEdgeInsetsMake(4, 8, 4, 8)];
    dropDownButton.tag = index;
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    dropDownButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    dropDownButton.layer.borderWidth = 1.0f;
    NSString *buttonTitle = [self convertToString:questionnaire[@"model"]];
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    if (buttonTitle.length == 0) {
        buttonTitle = @"Select a date";
    } else {
        model.value = buttonTitle;
    }
    [self.questionnaireModel addObject:model];

    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dropDownButton addTarget:self action:@selector(dateDropDownSelected:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];

    
}

- (void)createDropdownViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dropDownButton setContentEdgeInsets:UIEdgeInsetsMake(4, 8, 4, 8)];
    dropDownButton.tag = index;
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    dropDownButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    dropDownButton.layer.borderWidth = 1.0f;
    NSString *buttonTitle = @"click to choose an option";
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    if (questionnaire[@"model"]) {
        id mdl = questionnaire[@"model"];
        buttonTitle = [self convertToString:mdl[@"value"]];
        model.value = buttonTitle;
    } else {
    
    }
    [self.questionnaireModel addObject:model];
    
    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    [dropDownButton setTitleColor:[UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dropDownButton addTarget:self action:@selector(dropDownSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *dropDownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop-down-arrow"]];
    dropDownImg.translatesAutoresizingMaskIntoConstraints = false;
    [dropDownView addSubview:dropDownImg];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]-8-[dropDownImg(==18)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, dropDownImg)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[dropDownButton]-|" options:NSLayoutFormatAlignmentMask metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];
    
}

- (void)createImageUploadViewWithData:(id)questionnaire index:(NSInteger)index{
    UIStackView *verStackView = [self getStackView:stackView];
    
    UIView *questionView = [self getStackSubView:verStackView];
    questionView.backgroundColor = [UIColor clearColor];
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.translatesAutoresizingMaskIntoConstraints = false;
    [questionLabel setText:[NSString stringWithFormat:@"Question %ld",index+1]];
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:questionLabel];
    questionLabel.textColor = [UIColor grayColor];
    questionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[questionLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    [questionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[questionLabel]-(>=4)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(questionLabel)]];
    
    UIView *titleView = [self getStackSubView:verStackView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [titleLabel setText:[self convertToString:questionnaire[@"title"]]];
    [titleView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    titleLabel.textColor = [UIColor grayColor];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[titleLabel]-24-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    [titleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[titleLabel]-4-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
    
   
    UIView *dropDownView = [self getStackSubView:verStackView];
    
    UILabel *limitLabel = [[UILabel alloc] init];
    limitLabel.translatesAutoresizingMaskIntoConstraints = false;
    [limitLabel setText:@"Upload FIle (Maximum upload limit is 5.)"];
    [dropDownView addSubview:limitLabel];
    limitLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    limitLabel.textColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    
    UILabel *formatLabel = [[UILabel alloc] init];
    formatLabel.translatesAutoresizingMaskIntoConstraints = false;
    [formatLabel setText:@"You can choose image, doc & pdf"];
    [dropDownView addSubview:formatLabel];
    formatLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    formatLabel.textColor = [UIColor grayColor];
    
    UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownButton.tag = index;
    [dropDownButton setContentEdgeInsets:UIEdgeInsetsMake(4, 16, 4, 16)];
    dropDownButton.translatesAutoresizingMaskIntoConstraints = false;
    NSString *buttonTitle = @"Choose File";//[self convertToString:questionnaire[@"title"]];
    if (buttonTitle.length == 0) {
        buttonTitle = @"Upload";
    }
    [dropDownButton setBackgroundColor:[UIColor grayColor]];
    [dropDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [dropDownButton setTitle:buttonTitle forState:UIControlStateNormal];
    [dropDownView addSubview:dropDownButton];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[dropDownButton(>=100)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton)]];
    
    [dropDownView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[limitLabel]-4-[dropDownButton]-4-[formatLabel]-4-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(dropDownButton, limitLabel, formatLabel)]];

    if ([questionnaire[@"type"] isEqualToString:@"image"]) {
        [dropDownButton addTarget:self action:@selector(uploadImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([questionnaire[@"type"] isEqualToString:@"audio"]) {
        [dropDownButton addTarget:self action:@selector(uploadAudioClicked:) forControlEvents:UIControlEventTouchUpInside];
    }  else if ([questionnaire[@"type"] isEqualToString:@"video"]) {
        [dropDownButton addTarget:self action:@selector(uploadVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    WMQuestionnaireModel *model = [WMQuestionnaireModel new];
    [self.questionnaireModel addObject:model];
    
    UIView *imagesView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaireTilesView" owner:self options:nil] objectAtIndex:0];
    imagesView.tag = index;
    [verStackView addArrangedSubview:imagesView];

}



- (void)uploadVideoClicked:(UIButton *)sender {
    NSLog(@"uploadImageClicked tag: %ld",sender.tag);

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

- (void)uploadAudioClicked:(UIButton *)sender {
    NSLog(@"uploadImageClicked tag: %ld",sender.tag);

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

- (void)uploadImageClicked:(UIButton *)sender {
    NSLog(@"uploadImageClicked tag: %ld",sender.tag);
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

- (void)dropDownSelected:(UIButton *)sender {
    id model = self.questionnaireArray[sender.tag];
    NSLog(@"dropdown tag: %ld %@",sender.tag,model[@"choices"]);
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:[model[@"choices"] valueForKeyPath:@"value"] initialSelection:1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [sender setTitle:selectedValue forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];

}
- (void)dateDropDownSelected:(UIButton *)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1999];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    NSDate *curentDate = maxDate;
//    if (self.selectedDate) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        curentDate = [dateFormatter dateFromString:self.selectedDate];
//    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:curentDate
        target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    //    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
   
    NSLog(@"dateselected tag: %ld",sender.tag);
}

-(void)dateWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
//    self.dobTextField.text = [dateFormatter stringFromDate:selectedTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    self.selectedDate = [dateFormatter stringFromDate:selectedTime];
    [element setTitle:[dateFormatter stringFromDate:selectedTime] forState:UIControlStateNormal];

}

- (void)nextAction:(id)sender {
    [self.view endEditing:true];
    if ((self.scrollView.contentSize.width - self.scrollView.contentOffset.x) <= self.scrollView.bounds.size.width) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+self.scrollView.bounds.size.width, 0.0f) animated:YES];
}

- (void)backAction:(id)sender {
    [self.view endEditing:true];
    if (self.scrollView.contentOffset.x <= 0) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x-self.scrollView.bounds.size.width, 0.0f) animated:YES];
}

- (UIStackView *)getStackView:(UIStackView *)horStackView {
    
    UIView *bgView = [[UIView alloc] init];
    [bgView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width-32].active = true;

    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    bgView.layer.shadowOpacity = 0.6f;
    bgView.layer.cornerRadius = 3.0f;
    [horStackView addArrangedSubview:bgView];

    UIStackView *vertStackView = [[UIStackView alloc] init];
    [vertStackView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width-32].active = true;
    vertStackView.axis = UILayoutConstraintAxisVertical;
    vertStackView.distribution = UIStackViewDistributionFill;
    vertStackView.alignment = UIStackViewAlignmentFill;//UIStackViewAlignmentTop;
    vertStackView.spacing = 0;
    vertStackView.translatesAutoresizingMaskIntoConstraints = false;
    [bgView addSubview:vertStackView];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[vertStackView]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(vertStackView)]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[vertStackView]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(vertStackView)]];


//    [horStackView addArrangedSubview:vertStackView];
    return vertStackView;
}

- (UIView *)getStackSubView:(UIStackView *)vertStackView {
    UIView *sview = [[UIView alloc] init];
    sview.translatesAutoresizingMaskIntoConstraints = false;
    sview.backgroundColor = [UIColor whiteColor];
    [vertStackView addArrangedSubview:sview];
    [vertStackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sview]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(sview)]];
    [vertStackView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sview(64@300)]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(sview)]];
    return sview;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textView.tag: %ld",(long)textView.tag);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textField.tag: %ld",(long)textField.tag);

}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"Page Index: %f",self.scrollView.contentOffset.x/self.scrollView.bounds.size.width);
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
