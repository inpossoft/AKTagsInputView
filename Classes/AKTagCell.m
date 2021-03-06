//
//  AKTagCell.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//
#import "AKTagsDefines.h"
#import "AKTagCell.h"
#import "NSString+StringSizeWithFont.h"
#define TAG_CELL_PADDING 5.0f
#define TAG_CELL_BTN_W 14.0f
#define TAG_CELL_H 25.0f


@interface AKTagCell ()
{
	BOOL isAvailableForDelete;
}
@end

@implementation AKTagCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.bounds.size.height / 2, self.bounds.size.height / 2)];
		CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
		maskLayer.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(.5, .5, .5, .5));
		maskLayer.path = maskPath.CGPath;
		maskLayer.fillColor = WK_COLOR_BLUE_TAG_COLOR.CGColor;
		maskLayer.strokeColor = WK_COLOR_BORDER_TAG_COLOR.CGColor;
		maskLayer.lineWidth = .5;
		[self.layer insertSublayer:maskLayer atIndex:0];
		self.clipsToBounds = NO;
		
		_tagLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_tagLabel.frame = UIEdgeInsetsInsetRect(_tagLabel.frame, UIEdgeInsetsMake(0, TAG_CELL_PADDING, 0, TAG_CELL_PADDING));
		_tagLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_tagLabel.font = [UIFont systemFontOfSize:17];
		_tagLabel.textColor = [UIColor blackColor];
	
		[self addSubview:_tagLabel];
    }
    return self;
}

-(void)setShowDeleteButton:(BOOL)showDeleteButton
{
	_showDeleteButton = showDeleteButton;
	if (_showDeleteButton){
		[self addSubview:[self deleteButton]];
	}
}
-(void)resetReadyForDeleteStatus
{
    _deleteButton.enabled = NO;
}
-(BOOL)isReadyForDelete
{
    return _deleteButton.enabled;
}
-(void)prepareForDelete
{
    _deleteButton.enabled = YES;
}
-(void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
    if (selected){
		[self prepareForDelete];
		[_delegate tagCellDidPressedDelete:self];
    }
}

-(UIButton *)deleteButton
{
	if (!_deleteButton){
		_deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds) - TAG_CELL_BTN_W - TAG_CELL_PADDING, CGRectGetMidY(self.bounds)-TAG_CELL_BTN_W/2, TAG_CELL_BTN_W, TAG_CELL_BTN_W)];
		[_deleteButton setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
		_deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		_deleteButton.enabled = NO;
		[_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		_tagLabel.frame = UIEdgeInsetsInsetRect(_tagLabel.frame, UIEdgeInsetsMake(0, 0, 0, TAG_CELL_BTN_W + TAG_CELL_PADDING));
	}
	return _deleteButton;
}

-(void)deleteButtonPressed:(id)sender
{
	[_delegate tagCellDidPressedDelete:self];
}

-(void)setTagName:(NSString *)tagName
{
	_tagName = tagName;
	_tagLabel.text = _tagName;
}

- (void)reloadLayer {
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.bounds.size.height / 2, self.bounds.size.height / 2)];
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(.5, .5, .5, .5));
	maskLayer.path = maskPath.CGPath;
	maskLayer.fillColor = WK_COLOR_BLUE_TAG_COLOR.CGColor;
	maskLayer.strokeColor = WK_COLOR_BORDER_TAG_COLOR.CGColor;
	maskLayer.lineWidth = .5;
	if (self.layer.sublayers.count > 0) {
		[self.layer replaceSublayer:self.layer.sublayers[0] with:maskLayer];
	} else {
		[self.layer insertSublayer:maskLayer atIndex:0];
	}
	self.clipsToBounds = NO;
}

+(CGSize)preferredSizeWithTag:(NSString*)tag deleteButtonEnabled:(BOOL)deleteButtonEnabled
{
	CGFloat tagW = [tag sizeWithMyFont:[UIFont systemFontOfSize:17]].width;
	CGFloat deleteButtonW = (deleteButtonEnabled ? (TAG_CELL_BTN_W + TAG_CELL_PADDING) : 0);
	CGSize itemSize = CGSizeMake(tagW + 2*TAG_CELL_PADDING + deleteButtonW, TAG_CELL_H);
	return itemSize;
}
@end
