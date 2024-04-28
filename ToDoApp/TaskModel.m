//
//  TaskModel.m
//  ToDoApp
//
//  Created by Ahmed Khaled on 21/04/2024.
//

#import "TaskModel.h"

@implementation TaskModel

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_taskName forKey:@"name"];
    [coder encodeObject:_taskDescription forKey:@"desc"];
    [coder encodeObject:_taskPriority forKey:@"priority"];
    [coder encodeObject:_taskState forKey:@"taskState"];
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self != nil){
        _taskName  = [coder decodeObjectForKey:@"name"];
        _taskDescription = [coder decodeObjectForKey:@"desc"];
        _taskPriority = [coder decodeObjectForKey:@"priority"];
        _taskState = [coder decodeObjectForKey:@"taskState"];
    
    }
    return self;
}

@end
