local ui = {}

local FUNCQUEUE = {}

function ui.init(parent, __update__)
	-- Update --
	if __update__ then
		return ui.update()
	end
	-- Update end --

	ui.clear()
	
	ui.initEvent(parent)
	
	-- Create ImageView
	local ImageView = GUI:Image_Create(parent, "ImageView", 324.00, 207.00, "res/public/1900000602.png")
	GUI:setContentSize(ImageView, 400, 250)
	GUI:setIgnoreContentAdaptWithSize(ImageView, false)
	GUI:setTouchEnabled(ImageView, false)
	GUI:setTag(ImageView, -1)
	GUI:setSwallowTouches(ImageView, true)

	-- Create Text
	local Text = GUI:Text_Create(ImageView, "Text", 57.00, 93.00, 16, "#ffffff", [[当前选择的NPCID是：]])
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(ImageView, "Text_1", 37.00, 192.00, 16, "#ffffff", [[NPC测试]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(ImageView, "Text_2", 208.00, 39.00, 16, "#109c18", VALUE("CURRENT_TALK_NPC_ID"))
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#ffffff", 1)
	
	-- SetRefreshVarFunc --
	GUI:SetRefreshVarFunc(Text_2, function(sender) 
		GUI:Text_setString(sender, VALUE("CURRENT_TALK_NPC_ID"))
	end)
	-- SetRefreshVarFunc end --
	
	FUNCQUEUE[Text_2] = true

	-- Create Text_3
	local Text_3 = GUI:Text_Create(ImageView, "Text_3", 78.00, 37.00, 16, "#ffffff", [[倒计时测试：]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(ImageView, "Text_4", 195.00, 50.00, 16, "#fb0000", [[]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)
	
	-- CountDown --
	if true then
		GUI:Text_COUNTDOWN(Text_4, VALUE("Z"), function (sender) SL:Print("倒计时结束执行脚本"); end)
	end
	-- CountDown end --

	-- Create Text_2_1
	local Text_2_1 = GUI:Text_Create(ImageView, "Text_2_1", 292.00, 83.00, 16, "#109c18", VALUE("<H>", "测试私人1"))
	GUI:setTouchEnabled(Text_2_1, false)
	GUI:setTag(Text_2_1, -1)
	GUI:Text_enableOutline(Text_2_1, "#ffffff", 1)
	
	-- SetRefreshVarFunc --
	GUI:SetRefreshVarFunc(Text_2_1, function(sender) 
		GUI:Text_setString(sender, VALUE("<H>", "测试私人1"))
	end)
	-- SetRefreshVarFunc end --
	
	FUNCQUEUE[Text_2_1] = true

	-- Create Button
	local Button = GUI:Button_Create(ImageView, "Button", 333.00, 190.00, "res/private/gui_edit/back.png")
	GUI:Button_setTitleText(Button, "")
	GUI:Button_setTitleColor(Button, "#ffffff")
	GUI:Button_setTitleFontSize(Button, 14)
	GUI:Button_titleEnableOutline(Button, "#000000", 1)
	GUI:setTouchEnabled(Button, true)
	GUI:setTag(Button, -1)
	GUI:setVisible(Button, VALUE("zzz"))
	GUI:setSwallowTouches(Button, false)
	GUI:addOnClickEvent(Button, function ()  ; if true then GUI:Win_Close(parent) end end)
	
	-- SetRefreshVarFunc --
	GUI:SetRefreshVarFunc(Button, function(sender) 
		GUI:setVisible(sender, VALUE("zzz"))
	end)
	-- SetRefreshVarFunc end --
	
	FUNCQUEUE[Button] = true

	-- Create ListView
	local ListView = GUI:ListView_Create(parent, "ListView", 350.00, 324.00, 330.00, 60.00, 2)
	GUI:ListView_setBackGroundColorType(ListView, 1)
	GUI:ListView_setBackGroundColor(ListView, "#9696ff")
	GUI:ListView_setBackGroundColorOpacity(ListView, 100)
	GUI:ListView_setGravity(ListView, 3)
	GUI:ListView_setItemsMargin(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)
	GUI:setVisible(ListView, false)
	GUI:setSwallowTouches(ListView, false)

	-- Create TableView
	local TableView = GUI:TableView_Create(parent, "TableView", 361.00, 337.00, 330.00, 60.00, 2, 70.00, 60.00, VALUE("LNum"), VALUE("Index"))
	GUI:TableView_setBackGroundColor(TableView, "#969664")
	GUI:setTouchEnabled(TableView, true)
	GUI:setTag(TableView, -1)
	GUI:setSwallowTouches(TableView, false)
	GUI:setChildID(TableView, 11)

	-- TableViewLoad --
	GUI:TableView_setCellCreateEvent(TableView, function(parent, idx)
		local cell = ui.getCell_11(parent, idx)
		GUI:setPosition(cell, 0, 0)
	end)
	
	GUI:TableView_addOnTouchedCellEvent(TableView, function (sender, cell)
		
		
	end)
	-- TableViewLoad end --

	GUI:TableView_scrollToCell(TableView, VALUE("Index"))
	
	-- SetRefreshVarFunc --
	GUI:SetRefreshVarFunc(TableView, function(sender) 
		
		GUI:TableView_scrollToCell(sender, VALUE("Index"))
	end)
	-- SetRefreshVarFunc end --
	
	FUNCQUEUE[TableView] = true

	-- Create RText
	local RText = GUI:RichText_Create(parent, "RText", 447.00, 269.00, "RText1111", 100, 16, "#FFFFFF", 4, nil, "fonts/font2.ttf")
	GUI:setTag(RText, -1)
	GUI:setSwallowTouches(RText, true)

	-- ui.getCell_11(parent, i)

	-- ui.getCell_10(parent, i)
end

function ui.clear()
	FUNCQUEUE = {}
end

function ui.initEvent(parent)
	-- Trigger --
	EVENT_ON(LUA_EVENT_LEVELCHANGE, "触发器", function()
		if (C) then 
			A1() 
		else 
			A2() 
		end

		if (C1) then 
			A3() 
		else 
			; 
		end

		ui.update() 
	end, parent)
	-- Trigger end --

	GUI:addStateEvent(parent, function (state)
		if state == "exit" then
			EVENT_OFF(LUA_EVENT_LEVELCHANGE, "触发器")
		end
	end)
end

function ui.getCell_11(parent, i)
	-- Create Button
	local Button = GUI:Button_Create(parent, "Button", 0.00, 96.00, "res/private/gui_edit/Button_Normal.png")
	GUI:Button_loadTexturePressed(Button, "res/private/gui_edit/Button_Press.png")
	GUI:Button_loadTextureDisabled(Button, "res/private/gui_edit/Button_Disable.png")
	GUI:setContentSize(Button, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Button, false)
	GUI:Button_setTitleText(Button, "")
	GUI:Button_setTitleColor(Button, "#ffffff")
	GUI:Button_setTitleFontSize(Button, 14)
	GUI:Button_titleEnableOutline(Button, "#000000", 1)
	GUI:setID(Button, 11)
	GUI:setTouchEnabled(Button, true)
	GUI:setTag(Button, -1)
	GUI:setSwallowTouches(Button, false)
	GUI:addOnClickEvent(Button, function ()  ; if true then SL:Print("点击的ID： ", VALUE("<T_HUMAN(测试私人5)>", i)[i]) end end)

	-- Create Text
	local Text = GUI:Text_Create(Button, "Text", 30.00, 30.00, 16, "#ffffff", VALUE("<T_HUMAN(测试私人5)>", i)[i])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	return Button
end

function ui.getCell_10(parent, i)
	-- Create Item
	local Item = GUI:ItemShow_Create(parent, "Item", 0.00, 0.00, {index = VALUE("<T_HUMAN(测试私人5)>", i)[i], look = true, count = VALUE("GAME_DATA", "team_num"), from = VALUE("<H>", "测试私人1"), bgVisible = true})
	GUI:setID(Item, 10)
	GUI:setTag(Item, -1)
	GUI:ItemShow_setItemTouchSwallow(Item, false)

	return Item
end

function ui.update()
	for widget, v in pairs(FUNCQUEUE) do
		if v then
			local func = GUI:GetRefreshVarFunc(widget)
			if func then
				func(widget)
			end
		end
	end
end

return ui