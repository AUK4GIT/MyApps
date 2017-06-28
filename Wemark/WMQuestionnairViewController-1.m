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

@interface WMQuestionnairViewController ()
    @property(nonatomic, strong) NSArray *questionnaireArray;
@end

@implementation WMQuestionnairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
                });
           
         }];
                               
           //[self.collectionView reloadData];
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
