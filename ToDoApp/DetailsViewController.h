//
//  DetailsViewController.h
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "ViewController.h"
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : ViewController

@property TaskModel *detailsTaskModel;
@property NSMutableArray<TaskModel *> *detailsArray;

@end

NS_ASSUME_NONNULL_END
