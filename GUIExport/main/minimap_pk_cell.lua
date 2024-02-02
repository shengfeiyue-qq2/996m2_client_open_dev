local ui = {}
function ui.init(parent)
	-- Create PKModelListViewCell
	local PKModelListViewCell = GUI:Layout_Create(parent, "PKModelListViewCell", 0.00, 0.00, 55.00, 80.00, true)
	GUI:setChineseName(PKModelListViewCell, "攻击模式_模板组合")
	GUI:setTouchEnabled(PKModelListViewCell, true)
	GUI:setTag(PKModelListViewCell, -1)

	-- Create ImageName
	local ImageName = GUI:Image_Create(PKModelListViewCell, "ImageName", 27.00, 40.00, "res/private/main/Pattern/1900012200.png")
	GUI:setChineseName(ImageName, "模式模板_名称_文本")
	GUI:setAnchorPoint(ImageName, 0.50, 0.50)
	GUI:setTouchEnabled(ImageName, false)
	GUI:setTag(ImageName, -1)
end
return ui