//
//  WMStartSurveyViewController.m
//  Wemark
//
//  Created by Ashish on 07/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMStartSurveyViewController.h"
#import "WMMyAssignmentsViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "WMCorrectionsViewController.h"
#import "HMSegmentedControl.h"


@interface WMStartSurveyViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *surveyArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, assign)NSInteger selectedIndex;
@end

@implementation WMStartSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Start Survey";
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    if (authKey.length == 0) {
        return;
    }
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] startSurvey:authKey forQuestionnairId:self.questionnaireId forAssignmentId:self.assignmentId completionBlock:^(BOOL result, id responseDict, NSError *error) {
        if (result) {
            
        }else{
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"]
                 integerValue] == 409) {
                NSLog(@"Error responseDict:->%@",resDict[@"message"]);
            }else{
                NSLog(@"Error:->%@",error.localizedDescription);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            [self.collectionView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    id surveyObj = self.surveyArray[indexPath.row];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyCells"];
        WMStartSurveyViewController *startSurvey = (WMStartSurveyViewController *)cell;
        startSurvey.assignmentId = [surveyObj valueForKey:@"assignment_id"];
        startSurvey.questionnaireId = [surveyObj valueForKey:@"questionnaire_id"];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/3 - 32, 150);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
    cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SurveyCells" forIndexPath:indexPath];
    
    UIImageView *imgView = [cell viewWithTag:11];
    UILabel *sectionName = [cell viewWithTag:12];
    UILabel *questionLabel = [cell viewWithTag:13];
    UILabel *questionNumberLabel = [cell viewWithTag:14];
    UIButton *statusLabel = [[cell viewWithTag:15] viewWithTag:16];
    
    imgView.image = [UIImage imageNamed:@"survey-section-pending"];
    sectionName.text = @"Section Name";
    questionLabel.text = @"Questions";
    questionNumberLabel.text = @"1/10";
    
    [statusLabel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    return cell;
}

- (IBAction)startSurveySubmitBtn:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure to submit your assignment ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:submitAction];
    
    [self presentViewController:alertController animated:true completion:^{
    }];
    
}

@end
