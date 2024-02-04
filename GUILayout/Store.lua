Store = {}

function Store.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, attachH)
    GUI:setTouchEnabled(PMainUI, true)

    local Image_5 = GUI:Image_Create(PMainUI, "Image_5", 366, 32, "res/private/store_ui/bg_scbtt_01.jpg")
    GUI:setAnchorPoint(Image_5, {x=0.5, y=0.5})

    local ListViewBtm = GUI:ListView_Create(PMainUI, "ListViewBtm", 4, 11, 600, 42, 1)
    local ListViewBtmCell = Store.createListViewBtmCell(PMainUI)
    GUI:setVisible(ListViewBtmCell, false)

    -- item ListView
    local ListView = GUI:ListView_Create(PMainUI, "ListView", 1, 63, 730, 377, 1)
    local ItemCell = Store.createItemCell(PMainUI)
    GUI:setVisible(ItemCell, false)
end

function Store.createListViewBtmCell(PMainUI)
    local cell = GUI:Layout_Create(PMainUI, "ListViewBtmCell", 0, 0, 200, 42, true)
    GUI:setTouchEnabled(cell, true)
    
    local pIcon = GUI:Layout_Create(cell, "pIcon", 20, 21, 0, 0)
    GUI:setAnchorPoint(pIcon, 0.5, 0.5)
    
    local cBg = GUI:Image_Create(cell, "cBg", 115, 21, "res/public/1900000668.png")
    GUI:setAnchorPoint(cBg, 0.5, 0.5)

    local Text_num = GUI:Text_Create(cell, "Text_num", 45, 21, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_num, 0, 0.5)

    return cell
end

function Store.createItemCell(PMainUI)
    local cell = GUI:Layout_Create(PMainUI, "ItemCell", 0, 0, 730, 140, true)
    GUI:setTouchEnabled(cell, true)

    local posX = {123, 365, 607}
    for i=1,3 do
        local Image = GUI:Image_Create(cell, "Image_"..i, posX[i], 70, "res/public/1900000665.png")
        GUI:setAnchorPoint(Image, 0.5, 0.5)
        GUI:setTouchEnabled(Image, true)

        local ImageTag = GUI:Image_Create(Image, "ImageTag", 31, 118, "res/private/store_ui/1900020100.png")
        GUI:setAnchorPoint(ImageTag, 0.5, 0.5)

        local Text_name = GUI:Text_Create(Image, "Text_name", 120, 115, 18, "#FFFFFF", "")
        GUI:setAnchorPoint(Text_name, 0.5, 0.5)

        local itemBg = GUI:Image_Create(Image, "itemBg", 51, 55, "res/public/1900000664.png")
        GUI:setAnchorPoint(itemBg, 0.5, 0.5)

        local pIcon = GUI:Layout_Create(Image, "pIcon", 51, 55, 0, 0)
        GUI:setAnchorPoint(pIcon, 0.5, 0.5)

        local pPriceNow = GUI:Layout_Create(Image, "pPriceNow", 95, 40, 0, 0)
        GUI:setAnchorPoint(pPriceNow, 0, 0.5)

        local pPrice = GUI:Layout_Create(Image, "pPrice", 95, 75, 0, 0)
        GUI:setAnchorPoint(pPrice, 0, 0.5)

        local Text_condition = GUI:Text_Create(Image, "Text_condition", 95, 75, 16, "#FFFFFF", "")
        GUI:setAnchorPoint(Text_condition, 0, 0.5)
    end

    return cell
end