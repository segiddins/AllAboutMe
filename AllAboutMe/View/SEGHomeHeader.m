//
//  SEGHomeHeader.m
//  AllAboutMe
//
//  Created by Samuel E. Giddins on 4/28/13.
//  Copyright (c) 2013 Samuel E. Giddins. All rights reserved.
//

#import "SEGHomeHeader.h"
#import <CoreText/CoreText.h>

static const CFIndex kColumnCount = 3;

@implementation SEGHomeHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Flip the view's context. Core Text runs bottom to top, even
        // on iPad, and the view is much simpler if we do everything in
        // Mac coordinates.
//        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
//        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
//        self.transform = transform;
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
//        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
//        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
//        self.transform = transform;
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForReuse {
//    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
//    CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
//    self.transform = transform;
//    self.backgroundColor = [UIColor whiteColor];
}

- (CGRect *)copyColumnRects {
    CGRect bounds = CGRectInset([self bounds], 20.0, 20.0);
    
    int column;
    CGRect* columnRects = (CGRect*)calloc(kColumnCount,
                                          sizeof(*columnRects));
    
    // Start by setting the first column to cover the entire view.
    columnRects[0] = bounds;
    // Divide the columns equally across the frame's width.
    CGFloat columnWidth = CGRectGetWidth(bounds) / kColumnCount;
    for (column = 0; column < kColumnCount - 1; column++) {
        CGRectDivide(columnRects[column], &columnRects[column],
                     &columnRects[column + 1], columnWidth,
                     CGRectMinXEdge);
    }
    
    // Inset all columns by a few pixels of margin.
    for (column = 0; column < kColumnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column],
                                          10.0, 10.0);
    }
    return columnRects;
}

- (CFArrayRef)copyPaths
{
    CFMutableArrayRef
    paths = CFArrayCreateMutable(kCFAllocatorDefault,
                                 kColumnCount,
                                 &kCFTypeArrayCallBacks);
    
    switch (self.mode) {
        case 0: // 3 columns
        {
            CGRect *columnRects = [self copyColumnRects];
            // Create an array of layout paths, one for each column.
            for (int column = 0; column < kColumnCount; column++) {
                CGPathRef
                path = CGPathCreateWithRect(columnRects[column], NULL);
                CFArrayAppendValue(paths, path);
                CGPathRelease(path);
            }
            free(columnRects);
            break;
        }
            
        case 1: // 3 columns as a single path
        {
            CGRect *columnRects = [self copyColumnRects];
            
            // Create a single path that contains all columns
            CGMutablePathRef path = CGPathCreateMutable();
            for (int column = 0; column < kColumnCount; column++) {
                CGPathAddRect(path, NULL, columnRects[column]);
            }
            free(columnRects);
            CFArrayAppendValue(paths, path);
            CGPathRelease(path);
            break;
        }
            
        case 2: // two columns with box
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 30, 30);  // Bottom left
            CGPathAddLineToPoint(path, NULL, 344, 30);  // Bottom right
            
            CGPathAddLineToPoint(path, NULL, 344, 400);
            CGPathAddLineToPoint(path, NULL, 200, 400);
            CGPathAddLineToPoint(path, NULL, 200, 800);
            CGPathAddLineToPoint(path, NULL, 344, 800);
            
            CGPathAddLineToPoint(path, NULL, 344, 944); // Top right
            CGPathAddLineToPoint(path, NULL, 30, 944);  // Top left
            CGPathCloseSubpath(path);
            CFArrayAppendValue(paths, path);
            CFRelease(path);
            
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 700, 30); // Bottom right
            CGPathAddLineToPoint(path, NULL, 360, 30);  // Bottom left
            
            CGPathAddLineToPoint(path, NULL, 360, 400);
            CGPathAddLineToPoint(path, NULL, 500, 400);
            CGPathAddLineToPoint(path, NULL, 500, 800);
            CGPathAddLineToPoint(path, NULL, 360, 800);
            
            CGPathAddLineToPoint(path, NULL, 360, 944); // Top left
            CGPathAddLineToPoint(path, NULL, 700, 944); // Top right
            CGPathCloseSubpath(path);
            CFArrayAppendValue(paths, path);
            CGPathRelease(path);
            break;
        }
        case 3: // ellipse
        {
            CGPathRef
            path = CGPathCreateWithEllipseInRect(CGRectInset([self bounds],
                                                             30,
                                                             30),
                                                 NULL);
            CFArrayAppendValue(paths, path);
            CGPathRelease(path);
            break;
        }
        case 4: // 1 column with image
        {
            CGRect imageRect = CGRectMake(0, self.bounds.size.height - self.image.image.size.height/2, self.image.image.size.width/2 + 10, self.image.image.size.height/2 + 10);
            CGMutablePathRef
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, self.bounds.size.width - 5, self.bounds.size.height - 5);
            CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 5, 5);
            CGPathAddLineToPoint(path, NULL, 5, 5);
            CGPathAddLineToPoint(path, NULL, 5, CGRectGetMinY(imageRect));
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(imageRect), CGRectGetMinY(imageRect));
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(imageRect), self.bounds.size.height - 5);
            CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 5, self.bounds.size.height - 5);
            CFArrayAppendValue(paths, path);
            
            CGPathRelease(path);
            
            imageRect = CGRectMake(0, self.bounds.size.height - self.image.frame.size.height/2, self.image.frame.size.width/2 + 10, self.image.frame.size.height/2 + 10);
            path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, self.bounds.size.width - 5, self.bounds.size.height - 5);
            CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 5, 5);
            CGPathAddLineToPoint(path, NULL, 5, 5);
            CGPathAddLineToPoint(path, NULL, 5, CGRectGetMinY(imageRect));
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(imageRect), CGRectGetMinY(imageRect));
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(imageRect), self.bounds.size.height - 5);
            CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 5, self.bounds.size.height - 5);
            CFArrayAppendValue(paths, path);
            CGPathRelease(path);
            break;
        }
    }
    return paths;
}

- (void)drawRect:(CGRect)rect
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    CGAffineTransformTranslate(transform, 0, -fabsf(self.bounds.size.height));
        self.transform = transform;
    if (self.attributedString == nil)
    {
        return;
    }
    
    if (self.mode == 4) {
        CGRect imageRect = CGRectMake(5, self.bounds.size.height - self.image.image.size.height/2 - 5, self.image.image.size.width/2, self.image.image.size.height/2);
        self.image.frame = imageRect;
        self.image.transform = CGAffineTransformMakeScale(1, -1);
        [self addSubview:self.image];
    }
    
    // Initialize the context (always initialize your text matrix)
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFAttributedStringRef
    attrString = (__bridge CFTypeRef)self.attributedString;
    
    CTFramesetterRef
    framesetter = CTFramesetterCreateWithAttributedString(attrString);
    
    CFArrayRef paths = [self copyPaths];
//    CFIndex pathCount = CFArrayGetCount(paths);
    CFIndex charIndex = 0;
    for (CFIndex pathIndex = 0; pathIndex < 1; ++pathIndex) {
        CGPathRef path = CFArrayGetValueAtIndex(paths, pathIndex);
        
        CGContextAddPath(context, path); // Show paths for testing
        
        CTFrameRef
        frame = CTFramesetterCreateFrame(framesetter,
                                         CFRangeMake(charIndex, 0),
                                         path,
                                         NULL);
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        charIndex += frameRange.length;
        CFRelease(frame);
    }
    
//    CGContextStrokePath(context); // Show paths for testing
    
    CFRelease(paths);
    CFRelease(framesetter);
}

- (CGFloat)heightForAttributedString
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    CGAffineTransformTranslate(transform, 0, -fabsf(self.bounds.size.height));
    self.transform = transform;
    CGFloat H = 10;
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFAttributedStringRef)self.attributedString);
    
    CFIndex startIndex = 0;
    
    CGPathRef path = CFArrayGetValueAtIndex([self copyPaths], 1);
    
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    // Start the next frame at the first character not visible in this frame.
    //CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    //startIndex += frameRange.length;
    
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat h, ascent, descent, leading;
    
    for (j=0; j < lineCount; j++)
    {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        h = (ascent + descent + leading + 4.25);
        H+=h;
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    
    
    return H;
}

- (void)setImage:(UIImageView *)image {
    [_image removeFromSuperview];
    [_image removeObserver:self forKeyPath:@"image"];
    _image = image;
    if (image.image) {
        _image.frame = CGRectMake(5, 5, image.image.size.width/2,image.image.size.height/2);
    }
    [image addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    [self setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.image) {
        [self setNeedsDisplay];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.image removeObserver:self forKeyPath:@"image"];
}

@end
