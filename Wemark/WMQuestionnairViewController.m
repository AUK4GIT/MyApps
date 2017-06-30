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

@interface WMQuestionnairViewController ()
    @property(nonatomic, strong) NSArray *questionnaireArray;
@end

@implementation WMQuestionnairViewController
    {
        IBOutlet UIStackView *stackView;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
//    stackView.axis = UILayoutConstraintAxisHorizontal;
//    stackView.distribution = UIStackViewDistributionEqualSpacing;
//    stackView.alignment = UIStackViewAlignmentFill;
//    stackView.spacing = 0;
//    stackView.translatesAutoresizingMaskIntoConstraints = false;
//    [self.view addSubview:stackView];
    //Layout for Stack View
//    [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
//    [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    
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
            if ([questionnaire[@"type"] isEqualToString:@"audio"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire1" owner:self options:nil] objectAtIndex:0];
                qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"video"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire2" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"image"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire3" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"text"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire4" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                qView.backgroundColor = [UIColor redColor];
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"radio-group"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire5" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"dropdown"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire6" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"matrix-table"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire7" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"textarea"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire1" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"checkbox-group"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire2" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
                [stackView addArrangedSubview:qView];
            } else  if ([questionnaire[@"type"] isEqualToString:@"date"]) {
                UIView *qView = [[[NSBundle mainBundle] loadNibNamed:@"WMQuestionaire3" owner:self options:nil] objectAtIndex:0];
                 qView.translatesAutoresizingMaskIntoConstraints = false;
                [qView.heightAnchor constraintEqualToConstant:qView.bounds.size.height].active = true;
                [qView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = true;
//                qView.backgroundColor = [UIColor greenColor];
                [stackView addArrangedSubview:qView];
            }
        }
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
