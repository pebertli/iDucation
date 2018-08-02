//
//  IDCFormatTextParser.h
//  iducation
//
//  Created by pebertli on 3/22/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCFormatTextParser : NSObject{
    UIColor* fontColor;
    UIFont* fontName;
    float fontSize;
    NSTextAlignment* paragraphAlignment;
    
}

+ (id) sharedInstance;

- (NSMutableAttributedString*) parserAtributtedStringFromFile:(NSString*) file;

@end
