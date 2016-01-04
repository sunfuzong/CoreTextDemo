# CoreTextDemo
CoreTextDemo

Demo是根据 唐巧《iOS开发进阶》中coretext改写的。

其中HandlerData和HrefContentOperation为数据处理的对象。可以根据自身需求修改。

CoreTextDisplayViewDelegate为回调：

	•	(void)coreTextDisplayView:(CoreTextDisplayView *)ctDisplayView didPressedType:(CTContentPressedType)pressType withInfo:(NSDictionary *)info;
	
CTContentPressedLink, // 超链接

CTContentPressedImage // 图片

未解决问题：在demo中图片是使用UIImageView（SDWebImageView）添加的， 因使用CGContextDrawImage图片错乱，未能达到效果。如果谁有解决办法请告知，非常感谢！
