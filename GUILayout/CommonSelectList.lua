
CommonSelectList = {}
CommonSelectList._maxShowNum = 8        -- 最大显示cell个数

function CommonSelectList.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_select_list")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonSelectList._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonSelectList._ui.Panel_cancel, screenW, screenH)

    CommonSelectList.InitUI(data)
end

function CommonSelectList.InitUI(data)
    if not data then
        return
    end

    local position  = data.position
    local values    = data.values
    local cellSize  = {width = 260, height = 28}  -- 原cell 尺寸
    local cellW     = data.cellwidth or cellSize.width
    local cellH     = data.cellheight or cellSize.height
    local MoveCount = data.MoveItemCount or 0
    CommonSelectList._func      = data.func 
    CommonSelectList._iconPaths = data.iconPaths
    if type(values) == "string" then 
        values = {values}
    end 
    local count = #values
    count = math.min(count, CommonSelectList._maxShowNum)
    if position.y < cellH * count then
        GUI:setAnchorPoint(CommonSelectList._ui.Image_bg, 0, 0) 
        if MoveCount > 0 then 
            position.y = position.y + MoveCount * cellH
        end
    end

    local pSizeH = cellH * count + 8
    GUI:setContentSize(CommonSelectList._ui.Image_bg, cellW + 8, pSizeH)
    GUI:setContentSize(CommonSelectList._ui.ListView_1, cellW, cellH * count)
    GUI:setPositionY(CommonSelectList._ui.ListView_1, pSizeH - 4)
    
    CommonSelectList._cellSize = {width = cellW, height = cellH}
    for i, v in ipairs(values) do
        local cell = CommonSelectList.CreateItemCell(i, v)
        GUI:ListView_pushBackCustomItem(CommonSelectList._ui.ListView_1, cell)
    end
    GUI:setPosition(CommonSelectList._ui.Image_bg, position.x, position.y)
    GUI:addOnClickEvent(CommonSelectList._ui.Panel_cancel, function()
        if CommonSelectList._func then
            CommonSelectList._func(0)
        end
        SL:CloseSelectListUI()
    end)
end

function CommonSelectList.CreateItemCell(index, str)
    local parent = GUI:Widget_Create(CommonSelectList._ui.ListView_1, "widget", 0, 0)
    GUI:LoadExport(parent, "common_tips/common_select_list_cell")

    local size = CommonSelectList._cellSize
    local cell = GUI:getChildByName(parent, "Image_cell")
    GUI:setContentSize(cell, size)
    local ui = GUI:ui_delegate(cell)
    GUI:Text_setString(ui.Text_desc, str)
    GUI:setPosition(ui.Text_desc, size.width / 2, size.height / 2)
    GUI:setVisible(ui.Image_icon, false)
    local iconPath = CommonSelectList._iconPaths and CommonSelectList._iconPaths[index]
    if iconPath and iconPath ~= "" and SL:IsFileExist(iconPath) then
        GUI:Image_loadTexture(ui.Image_icon, iconPath)
        GUI:setVisible(ui.Image_icon, true)
    end

    GUI:addOnClickEvent(cell, function()
        if CommonSelectList._func then
            CommonSelectList._func(index)
        end
        SL:CloseSelectListUI()
    end)

    GUI:removeFromParent(cell)
    GUI:removeFromParent(parent)
    
    return cell
end