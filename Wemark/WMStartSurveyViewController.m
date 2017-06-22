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
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLbl;

@property (nonatomic, assign)NSInteger selectedIndex;
@end

@implementation WMStartSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:236/255.0 blue:243/255.0 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.progressView setProgress:0.0 animated:true];
    [self.progressLbl setText:@"0% Complete"];
    self.title = @"Start Survey";
    self.surveyArray = [[NSMutableArray alloc] init];
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    if (authKey.length == 0) {
        return;
    }
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] startSurvey:authKey forQuestionnairId:self.questionnaireId forAssignmentId:self.assignmentId completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSString *progress = @"0";
        if (result) {
            if ([responseDict[@"sections"] isKindOfClass:[NSArray class]]) {
                self.surveyArray = responseDict[@"sections"];
            }
            id progressDict =  responseDict[@"survey_progress"];
            progress = [progressDict valueForKey:@"progress_in_percentage"];
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
            [self.progressView setProgress:[progress floatValue]/100 animated:true];
            NSString *percent = @"%";
            [self.progressLbl setText:[NSString stringWithFormat:@"%@%@ Complete",progress,percent]];

            [self hideActivity];
            [self.collectionView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/3 - 16, 150);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.surveyArray ? self.surveyArray.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
    cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SurveyCells" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [cell viewWithTag:11];
    UILabel *sectionName = [cell viewWithTag:12];
    UILabel *questionLabel = [cell viewWithTag:13];
    UILabel *questionNumberLabel = [cell viewWithTag:14];
    UIButton *statusLabel = [[cell viewWithTag:15] viewWithTag:16];
    
    id obj = self.surveyArray[indexPath.item];
    NSString *status = [self convertToString:[obj valueForKey:@"section_status"]];
    if (status.length == 0) {
        status = @"start";
    }
    
    if ([status isEqualToString:@"start"]) {
        imgView.image = [UIImage imageNamed:@"survey-section-start"];
        [statusLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else if ([status isEqualToString:@"pending"]){
        imgView.image = [UIImage imageNamed:@"survey-section-pending"];
        [statusLabel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    } else {
        imgView.image = [UIImage imageNamed:@"survey-section-completed"];
        [statusLabel setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    sectionName.text = @"Section Name";
    questionLabel.text = @"Questions";
    questionNumberLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertToString:[obj valueForKey:@"no_of_answers"]],[self convertToString:[obj valueForKey:@"no_of_questions"]]];
    
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
