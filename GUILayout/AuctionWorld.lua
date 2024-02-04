AuctionWorld = {}

function AuctionWorld.main( )
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width

    -- 底
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, 410)
    GUI:setTouchEnabled(PMainUI, true)

    local line1 = GUI:Image_Create(PMainUI, "line1", 0, 406, "res/public/bg_yyxsz_01.png")

    local line2 = GUI:Image_Create(PMainUI, "line2", 125, 405, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(line2, {width = 355, height = 2})
    GUI:setRotation(line2, 90)
    
    local line3 = GUI:Image_Create(PMainUI, "line3", 126, 363, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(line3, {width = 605, height = 2})

    local line4 = GUI:Image_Create(PMainUI, "line4", 0, 48, "res/public/bg_yyxsz_01.png")
    
------左侧列表-------------------------------------------------------------------------------
    local LeftList = GUI:ListView_Create(PMainUI, "LeftList", 0, 50, 125, 355, 1)
    local LeftCell = AuctionWorld.createCell2(PMainUI)
    GUI:setVisible(LeftCell, false)
    local LeftSelCell = AuctionWorld.createCell3(PMainUI)
    GUI:setVisible(LeftSelCell, false)

------中间内容-------------------------------------------------------------------------------
    local CenterPanel = GUI:Layout_Create(PMainUI, "CenterPanel", 127, 50, 605, 355, true)
    local Text1 = GUI:Text_Create(CenterPanel, "Text1", 69, 338, 16, "#FFFFFF", "竞拍道具")
    GUI:setAnchorPoint(Text1, 0.5, 0.5)
    local Text2 = GUI:Text_Create(CenterPanel, "Text2", 225, 338, 16, "#FFFFFF", "剩余时间")
    GUI:setAnchorPoint(Text2, 0.5, 0.5)
    local Text3 = GUI:Text_Create(CenterPanel, "Text3", 378, 338, 16, "#FFFFFF", "竞拍价格")
    GUI:setAnchorPoint(Text3, 0.5, 0.5)
    local Text4 = GUI:Text_Create(CenterPanel, "Text4", 533, 338, 16, "#FFFFFF", "一口价")
    GUI:setAnchorPoint(Text4, 0.5, 0.5)

    local Image_empty = GUI:Image_Create(CenterPanel, "Image_empty", 302.5, 150, "res/private/auction/word_paimaihang_01.png")
    GUI:setAnchorPoint(Image_empty, 0.5, 0.5)
    
    local ListItems = GUI:ListView_Create(CenterPanel, "ListItems", 0, 0, 605, 313, 1)
    local itemCell = AuctionWorld.createItemCell(CenterPanel)
    GUI:setVisible(itemCell, false)

    local priceCell = AuctionWorld.createPriceCell(PMainUI)
    GUI:setVisible(priceCell, false)

------底部内容-------------------------------------------------------------------------------
    local BtmPanel = GUI:Layout_Create(PMainUI, "BtmPanel", 0, 0, attachW, 50)
    -- 职业
    AuctionWorld.createCell1(BtmPanel, "CFilterJob", 345, 25)
    -- 品质
    AuctionWorld.createCell1(BtmPanel, "CFilterQuality", 455, 25)
    -- 货币
    AuctionWorld.createCell1(BtmPanel, "CFilterMoney", 565, 25)
    -- 价格
    AuctionWorld.createCell1(BtmPanel, "CFilterPrice", 675, 25)
    -- 点击隐藏筛选tips
    local PanelHideFilter = GUI:Layout_Create(BtmPanel, "PanelHideFilter", 0, 0, attachW, 410)
    GUI:setTouchEnabled(PanelHideFilter, true)

    -- 底部筛选项列表
    local ListFilterBg = GUI:Image_Create(BtmPanel, "ListFilterBg", 345, 45, "res/public/1900000677.png")
    GUI:Image_setScale9Slice(ListFilterBg, 10, 10, 20, 20)
    GUI:setContentSize(ListFilterBg, {width = 100, height = 100})
    GUI:setAnchorPoint(ListFilterBg, 0.5, 0)
    local ListFilter = GUI:ListView_Create(ListFilterBg, "ListFilter", 2.5, 2.5, 95, 95, 1)
end

-- 筛选框 cell
function AuctionWorld.createCell1(parent, name, x, y)
    local cell = GUI:Image_Create(parent, name, x, y, "res/public/1900000668.png")
    GUI:setContentSize(cell, {width = 102, height = 32})
    GUI:Image_setScale9Slice(cell, 22, 22, 5, 5)
    GUI:setAnchorPoint(cell, 0.5, 0.5)
    GUI:setTouchEnabled(cell, true)

    local Text_1 = GUI:Text_Create(cell, "Text_1", 10, 16, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_1, 0, 0.5)

    local ImgArrow = GUI:Image_Create(cell, "ImgArrow", 55, 16, "res/public/btn_szjm_01_4.png")
    GUI:setVisible(ImgArrow, false)
    GUI:setAnchorPoint(ImgArrow, 0.5, 0.5)

    local ImgPull = GUI:Image_Create(cell, "ImgPull", 85, 16, "res/public/btn_szjm_01.png")
    GUI:setAnchorPoint(ImgPull, 0.5, 0.5)
end

-- 左侧按钮页签 cell 
function AuctionWorld.createCell2(parent)
    local LeftCell = GUI:Layout_Create(parent, "LeftCell", 0, 0, 125, 42, true)
    local Button_1 = GUI:Button_Create(LeftCell, "Button_1", 62.5, 21, "res/public/1900000662.png")
    GUI:setAnchorPoint(Button_1, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_1, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_1, 16)
    return LeftCell
end

-- 左侧按钮页签二级选中项 cell 
function AuctionWorld.createCell3(parent)
    local LeftSelCell = GUI:Layout_Create(parent, "LeftSelCell", 0, 0, 125, 42, true)
    GUI:setTouchEnabled(LeftSelCell, true)
    local Image_1 = GUI:Image_Create(LeftSelCell, "Image_1", 62.5, 21, "res/public/1900000678.png")
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)
    local Image_2 = GUI:Image_Create(LeftSelCell, "Image_2", 20, 21, "res/public/btn_szjm_01_5.png")
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    local TextName = GUI:Text_Create(LeftSelCell, "TextName", 62.5, 21, 20, "#FFFFFF", "")
    GUI:setAnchorPoint(TextName, 0.5, 0.5)
    return LeftSelCell
end

function AuctionWorld.createPriceCell(parent)
    local cell = GUI:Layout_Create(parent, "PriceCell", 1, 0, 120, 50)
    GUI:setAnchorPoint(cell, {x=1, y=0.5})

    local Panel_item = GUI:Layout_Create(cell, "Panel_item", 55, 25, 0, 0)
    GUI:setAnchorPoint(Panel_item, {x=0.5, y=0.5})

    local Text_count = GUI:Text_Create(cell, "Text_count", 91.5, 25, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_count, {x=0.5, y=0.5})

    return cell
end

-- 道具列表 cell
function AuctionWorld.createItemCell(parent)
    local iCell = GUI:Layout_Create(parent, "iCell", 0, 0, 605, 85, true)
    GUI:setTouchEnabled(iCell, true)

    local line = GUI:Image_Create(iCell, "iline", 0, 0, "res/public/1900000667.png")
    GUI:setContentSize(line, {width = 605, height = 2})

    local Image_item = GUI:Image_Create(iCell, "Image_item", 41, 42.5, "res/public/1900000664.png")
    GUI:setAnchorPoint(Image_item, 0.5, 0.5)

    local Text_me = GUI:Text_Create(iCell, "Text_me", 80, 70, 16, "#FFFFFF", "我的拍品")
    GUI:setAnchorPoint(Text_me, 0, 0.5)
    local Text_name = GUI:Text_Create(iCell, "Text_name", 80, 42.5, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0, 0.5)

    local Text_tstatus = GUI:Text_Create(iCell, "Text_tstatus", 225, 70, 16, "#FFFFFF", "即将开拍")
    GUI:setAnchorPoint(Text_tstatus, 0.5, 0.5)
    local Text_remaining = GUI:Text_Create(iCell, "Text_remaining", 225, 42.5, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_remaining, 0.5, 0.5)

    local Text_status = GUI:Text_Create(iCell, "Text_status", 377, 70, 16, "#FFFFFF", "竞价被超过")
    GUI:setAnchorPoint(Text_status, 0.5, 0.5)

    local Panel_bid_price = GUI:Layout_Create(iCell, "Panel_bid_price", 380, 42.5, 0, 0)


    local Button_bid = GUI:Button_Create(iCell, "Button_bid", 465, 42.5, "res/public/1900000652.png")
    GUI:setContentSize(Button_bid, {width = 65, height = 27})
    GUI:Button_setScale9Slice(Button_bid, 11, 11, 4, 4)
    GUI:setAnchorPoint(Button_bid, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_bid, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_bid, 18)
    GUI:Button_setTitleText(Button_bid, "竞价")

    local Text_unable_buy = GUI:Text_Create(iCell, "Text_unable_buy", 533, 42.5, 16, "#FFFFFF", "无法一口价")
    GUI:setAnchorPoint(Text_unable_buy, 0.5, 0.5)
    local Text_rebate = GUI:Text_Create(iCell, "Text_rebate", 575, 70, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_rebate, 0.5, 0.5)

    local Panel_price = GUI:Layout_Create(iCell, "Panel_price", 530, 42.5, 0, 0)

    local Button_buy = GUI:Button_Create(iCell, "Button_buy", 565, 42.5, "res/public/1900000652.png")
    GUI:setContentSize(Button_buy, {width = 65, height = 27})
    GUI:Button_setScale9Slice(Button_buy, 11, 11, 4, 4)
    GUI:setAnchorPoint(Button_buy, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_buy, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_buy, 18)
    GUI:Button_setTitleText(Button_buy, "购买")

    return iCell
end