//
//  XxyHttpRequest.m
//  BestvSoccer
//
//  Created by iXxy on 14-6-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "XxyHttpRequest.h"
#define kPicName @"myPic"

@implementation XxyHttpRequest

- (id)init
{
    self = [super init];
    request = [[NSMutableURLRequest alloc] init];
    return self;
}

- (void)startAsyncWithUrl:(NSURL *)url
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    if (postDataDic != nil) {
        NSMutableString *body=[[NSMutableString alloc]init];
        NSArray *keys= [postDataDic allKeys];
        for(int i=0;i<[keys count];i++)
        {
            NSString *key=[keys objectAtIndex:i];
            [body appendFormat:@"%@\r\n",MPboundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [body appendFormat:@"%@\r\n",[self urlEncode:[postDataDic objectForKey:key]]];
        }
        NSMutableData *myRequestData=[NSMutableData data];
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        if (fileArr != nil && keyArr != nil) {
            for (int i = 0; i < [fileArr count]; i ++) {
                UIImage *image = (UIImage *)[fileArr objectAtIndex:i];
                NSData *data = UIImagePNGRepresentation(image);
                NSString *imgType = [XxyHttpRequest typeForImageData:data];
                NSArray *imgT = [imgType componentsSeparatedByString:@"/"];
                NSString *suffixName = [imgT objectAtIndex:1];
                NSString *picName = [NSString stringWithFormat:@"%@%d",kPicName,i];
                NSString *fileName = [NSString stringWithFormat:@"%@.%@",picName,suffixName];
                NSLog(@"%@",fileName);
                NSString *contentDis = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[keyArr objectAtIndex:i],fileName];
                NSMutableString *tmpBody=[[NSMutableString alloc]init];
                if (i == 0) {
                    [tmpBody appendFormat:@"%@\r\n",MPboundary];
                }else{
                    [tmpBody appendFormat:@"\n%@\r\n",MPboundary];
                }
                [tmpBody appendString:contentDis];
                [tmpBody appendFormat:@"Content-Type: %@\r\n\r\n",imgType];
                
                [tmpBody appendString:@"filecontent"];
                
                [myRequestData appendData:[tmpBody dataUsingEncoding:NSUTF8StringEncoding]];
                [myRequestData appendData:data];
            }
        }
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:myRequestData];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:60];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        resData = [[NSMutableData alloc] init];
        [connection start];
        
    }else{
        [request setURL:url];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        resData = [[NSMutableData alloc] init];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [request setTimeoutInterval:60];
        [connection start];
    }
}

- (void)setPostDataDic:(NSDictionary *)dic
{
    postDataDic = dic;
}

- (NSString*)urlEncode:(NSString *)str
{
    NSString *resultStr = str;
    CFStringRef originalString = CFBridgingRetain(str);
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)CFBridgingRelease(escapedStr)];
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

- (void)setFile:(UIImage *)img forKey:(NSString *)key
{
    if (fileArr == nil) {
        fileArr = [[NSMutableArray alloc] init];
    }
    if (keyArr == nil) {
        keyArr = [[NSMutableArray alloc] init];
    }
    NSMutableArray *tmpFile = fileArr;
    [tmpFile addObject:img];
    NSMutableArray *tmpKey = keyArr;
    [tmpKey addObject:key];
    fileArr = [NSMutableArray arrayWithArray:tmpFile];
    keyArr = [NSMutableArray arrayWithArray:tmpKey];
}

+ (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}
#pragma mark NSconnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *tmp = [NSMutableData dataWithData:resData];
    [tmp appendData:data];
    resData = tmp;
    float currPercent = ([resData length] * 1.0)/dataTotalSize;
    if (self.progressBlock) {
        _progressBlock(currPercent);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.finishBlock) {
        _finishBlock(resData);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failedBlock) {
        _failedBlock(error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        dataTotalSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] integerValue];
        
    }
}

@end
