CompoundItem = {}

function CompoundItem.main(compoundOpenID)
    local parent = GUI:Attach_Parent()
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWin32 and "compound_item_layer_win32/compound_items_layer" or
        "compound_item_layer/compound_items_layer")

    CompoundItem._ui = GUI:ui_delegate(parent)

    if SL:GetMetaValue("WINPLAYMODE") then
        -- 显示适配
        GUI:setPosition(CompoundItem._ui.Panel_1, SL:GetMetaValue("SCREEN_WIDTH") / 2, SL:GetMetaValue("PC_POS_Y"))
    else
        GUI:setPosition(CompoundItem._ui.Panel_1, SL:GetMetaValue("SCREEN_WIDTH") / 2,
            SL:GetMetaValue("SCREEN_HEIGHT") / 2)
    end

    -- 界面拖动
    GUI:Win_SetDrag(parent, CompoundItem._ui.Image_frame_bg)

    -- 打开的合成ID
    SL:SetMetaValue("COMPOUND_OPEN_ID", compoundOpenID)

    CompoundItem.SetCompoundEvent()
end

--- 合成按钮事件
function CompoundItem.SetCompoundEvent()
    local btnCompound = CompoundItem._ui.Button_compound
    GUI:addOnClickEvent(btnCompound, function()
        SL:ResquestCompoundItem()
    end)
end

--- 第一切页按钮
---@param parent userdata node控件
function CompoundItem.CreateMenuType(parent)
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent,
        isWin32 and "compound_item_layer_win32/compoud_list_btn1" or "compound_item_layer/compoud_list_btn1")
end

--- 第二切页按钮
---@param parent userdata node控件
function CompoundItem.CreateMenuCellLevel1(parent)
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent,
        isWin32 and "compound_item_layer_win32/compoud_list_btn2" or "compound_item_layer/compoud_list_btn2")
end

--- 第二切页展开的按钮
---@param parent userdata node控件
function CompoundItem.CreateMenuCellLevel2(parent)
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent,
        isWin32 and "compound_item_layer_win32/compoud_list_btn3" or "compound_item_layer/compoud_list_btn3")
end
