//
//  IDCFormatTextParser.m
//  iducation
//
//  Created by pebertli on 3/22/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCFormatTextParser.h"

@implementation IDCFormatTextParser

-(id)init{
    self = [super init];
    if(self)
    {
        fontSize = 10;
        fontName = [UIFont fontWithName:@"Courier" size:fontSize];
    }
    
    return self;
}

+ (IDCFormatTextParser *)sharedInstance {
    static IDCFormatTextParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IDCFormatTextParser alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSMutableAttributedString*) parserAtributtedStringFromFile:(NSString*) file
{
    
    NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    //find text file and load string from there
    NSError* err = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:file ofType: @"txt"];
    NSString* rawText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    //find tags enclosed by <> but not by \<>
//    NSRegularExpression* regex = [[NSRegularExpression alloc]
//                                  initWithPattern:@"((?<!\\\\)<{1}.*?>{1}|\\Z)"
//                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
//                                  error:nil];
    
    //set of tags
    NSRegularExpression* regexTags = [[NSRegularExpression alloc]
                                  initWithPattern:@"((?<!\\\\)<{1}.*?>(?!<)|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    //set of text
//    NSRegularExpression* regexText = [[NSRegularExpression alloc]
//                                  initWithPattern:@"(>*?.*?<|\\Z)"
//                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
//                                  error:nil];
    

    


    NSArray* tags = [regexTags matchesInString:rawText options:0 range:NSMakeRange(0, [rawText length])];
//    NSArray* values = [regexText matchesInString:rawText options:0 range:NSMakeRange(0, [rawText length])];
//
//    
//    //iterate over set of tags
//    for(int countTags = 0; countTags<[values count];countTags++){
//        NSTextCheckingResult* r = [values objectAtIndex:countTags];
//        NSString* tag = [rawText substringWithRange:NSMakeRange(r.range.location, r.range.length)];
//        NSLog(@"%@",tag);
//
//    }

    
    //iterate over set of tags
    for(int countTags = 0; countTags<[tags count];countTags++){

        NSTextCheckingResult* r = [tags objectAtIndex:countTags];
        NSString* tag = [rawText substringWithRange:NSMakeRange(r.range.location, r.range.length)];
        
        //text before first tag
        if(countTags==0 && r.range.location>0)
        {
            NSString* str = [rawText substringWithRange:NSMakeRange(0, r.range.location)];
            NSMutableString* strM = [NSMutableString stringWithString:str];
            //no custom format
            [retString appendAttributedString:[ self formatString:strM withTags:@""]];
            
        }
        
        //text between tags
        if(countTags < [tags count]-1)
        {
            //get next tag to calculate text between them
            NSTextCheckingResult* r2 = [tags objectAtIndex:countTags+1];
            int start = r.range.location+r.range.length;
            int lenght = r2.range.location-start;
            NSString* str = [rawText substringWithRange:NSMakeRange(start, lenght)];
            NSMutableString* strM = [NSMutableString stringWithString:str];
            [retString appendAttributedString:[ self formatString:strM withTags:tag]];
        }
        //text after last tag
//        else if(countTags == [tags count]-1 && [tags count]>1)
//        {
//            int start = r.range.location+r.range.length;
//            NSString* str = [rawText substringWithRange:NSMakeRange(start, rawText.length-start)];
//            NSMutableString* strM = [NSMutableString stringWithString:str];
//            [retString appendAttributedString:[ self formatString:strM withTag:tag]];
//        }
    }
    
    return retString;
}


- (NSAttributedString*) formatString:(NSMutableString*) string withTags:(NSString*) tag{
    
    NSMutableDictionary *format = [[NSMutableDictionary alloc] init];
    
    [string replaceOccurrencesOfString:@"\\n" withString:@"\u2028" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    //remove \ from \< quote
    [string replaceOccurrencesOfString:@"\\<" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //find tags enclosed by <> but not by \<>
        NSRegularExpression* regexTag = [[NSRegularExpression alloc]
                                      initWithPattern:@"((?<!\\\\)<{1}.*?>{1}|\\Z)"
                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                      error:nil];
    
    NSArray* tags = [regexTag matchesInString:tag options:0 range:NSMakeRange(0, [tag length])];

    if([tags count]==0 || [tag isEqualToString:@""])
    {
       format = [NSMutableDictionary dictionaryWithDictionary: [self getFormatFromStyle:@"default"]];
    }
    else
    //iterate over set of tags
    for(int countTags = 0; countTags<[tags count];countTags++){
        
        NSTextCheckingResult* r = [tags objectAtIndex:countTags];
        NSString* t = [tag substringWithRange:NSMakeRange(r.range.location, r.range.length)];
 
    
    //get string between <
    NSArray* parts = [[t substringWithRange:NSMakeRange(0, [t length])] componentsSeparatedByString:@"<"];
    //as parts contains emprty string in first index, then get the second part
    if([parts count]>1)
    {
        
        NSString* part = [parts objectAtIndex:1];
        part = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //is it a font color?
        if ([part hasPrefix:@"font_color"]) {
            //get string between "
            NSArray* attrs = [[part substringWithRange:NSMakeRange(0, [part length])] componentsSeparatedByString:@"\""];
            if([attrs count]>1){
                NSString* value = [attrs objectAtIndex:1];
                //add format to dictionary
                SEL colorSel = NSSelectorFromString(value);
                fontColor = [UIColor performSelector:colorSel];
                [format setObject:fontColor forKey:NSForegroundColorAttributeName];
            }
            
            
        }
    else  
        if ([part hasPrefix:@"font_name"]) {
            //get string between "
            NSArray* attrs = [[part substringWithRange:NSMakeRange(0, [part length])] componentsSeparatedByString:@"\""];
            if([attrs count]>1){
                NSString* value = [attrs objectAtIndex:1];
                //add format to dictionary
//                SEL sel= NSSelectorFromString(value);
                fontName = [UIFont fontWithName:value size:fontSize];
                [format setObject:fontName forKey:NSFontAttributeName];
            }
            
            
        }
        
        else
            if ([part hasPrefix:@"font_style"]) {
                //get string between "
                NSArray* attrs = [[part substringWithRange:NSMakeRange(0, [part length])] componentsSeparatedByString:@"\""];
                if([attrs count]>1){
                    NSString* value = [attrs objectAtIndex:1];
                    //add format to dictionary
                    //                SEL sel= NSSelectorFromString(value);
                    NSMutableString* newFont = [NSMutableString stringWithString:fontName.fontName];
                    [newFont appendString:@"-"];
                    [newFont appendString:value];
                    
                    fontName = [UIFont fontWithName:newFont size:fontSize];
                    [format setObject:fontName forKey:NSFontAttributeName];
                }
                
                
            }
            else
                if ([part hasPrefix:@"font_size"]) {
                    //get string between "
                    NSArray* attrs = [[part substringWithRange:NSMakeRange(0, [part length])] componentsSeparatedByString:@"\""];
                    if([attrs count]>1){
                        NSString* value = [attrs objectAtIndex:1];
                        //add format to dictionary
                        //                SEL sel= NSSelectorFromString(value);
                        fontSize = [value floatValue];
                        fontName = [UIFont fontWithName:fontName.fontName size:fontSize];
                        [format setObject:fontName forKey:NSFontAttributeName];
                    }
                    
                    
                }



        
        
    }
        
//        NSLog(@"%@",t);
    }

    
  
    [retString setAttributes:format range:NSMakeRange(0, [retString length])];
//      NSLog(@"%@",retString);
        
    return retString;
}

- (NSDictionary*) getFormatFromStyle:(NSString*) style{
    
    if([style isEqualToString:@"default"])
    {
        fontSize = 10;
        fontName = [UIFont fontWithName:@"Courier" size:fontSize];
        fontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentJustified;
        paragraph.hyphenationFactor = .9;
    NSDictionary *format = @{NSForegroundColorAttributeName: fontColor,
                                      NSFontAttributeName: fontName,
                                      NSUnderlineStyleAttributeName: @1,
                             NSParagraphStyleAttributeName: paragraph
     
                            };
        return format;
    }

    return  [[NSDictionary alloc] init];
}

@end
