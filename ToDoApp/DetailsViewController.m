//
//  DetailsViewController.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "DetailsViewController.h"
#import "HelperClass.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;

@property BOOL isEditing;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.isEditing = NO;
        [self updateEditingState];
        if ([self.detailsTaskModel.taskState isEqualToString:@"2"]) {
            self.prioritySegmentedControl.enabled = NO;
        }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self populateFields];
}

- (void)populateFields {
    self.titleField.text = self.detailsTaskModel.taskName;
    self.descField.text = self.detailsTaskModel.taskDescription;
    self.prioritySegmentedControl.selectedSegmentIndex = [self.detailsTaskModel.taskPriority intValue];
    self.statusSegmentedControl.selectedSegmentIndex = [self.detailsTaskModel.taskState intValue];
}

- (IBAction)editButton:(id)sender {
    if (!self.isEditing) {
            self.isEditing = YES;
            [self updateEditingState];
            [self.editButton setTitle:@"Save" forState:UIControlStateNormal];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit" message:@"Are you sure you want to edit?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveChanges];
            }];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:yesAction];
            [alertController addAction:noAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    
}
- (void)saveChanges {
    self.isEditing = NO;
    self.detailsTaskModel.taskName = self.titleField.text;
    self.detailsTaskModel.taskDescription = self.descField.text;
    self.detailsTaskModel.taskPriority = [NSString stringWithFormat:@"%ld", (long)self.prioritySegmentedControl.selectedSegmentIndex];
    self.detailsTaskModel.taskState = [NSString stringWithFormat:@"%ld", (long)self.statusSegmentedControl.selectedSegmentIndex];
    
    [HelperClass saveTaskArrayToUserDefaults:@"taskArray" withArray:self.detailsArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateEditingState {
    self.titleField.enabled = self.isEditing;
    self.descField.enabled = self.isEditing;
    self.prioritySegmentedControl.enabled = self.isEditing;
    
    if ([self.detailsTaskModel.taskState isEqualToString:@"2"]) {
        self.statusSegmentedControl.enabled = NO;
    } else {
        self.statusSegmentedControl.enabled = self.isEditing;
    }
}
@end
