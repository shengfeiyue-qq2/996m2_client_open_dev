
BeStrongList = {}

function BeStrongList.main(pos)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "be_strong/be_strong_list")

    BeStrongList._ui = GUI:ui_delegate(parent)
    if not BeStrongList._ui then
        return false
    end
    
    GUI:setVisible(BeStrongList._ui["Button"], false)

    GUI:setPosition(BeStrongList._ui["Node"], pos)

    local CloseLayout = BeStrongList._ui["CloseLayout"]
    GUI:setSwallowTouches(CloseLayout, false)
    GUI:setContentSize(CloseLayout, SL:GetScreenSize())
    GUI:setPosition(CloseLayout, -pos.x, -pos.y)
    GUI:addOnClickEvent(CloseLayout, function () SL:CloseBeStrongList() end)

    GUI:addOnClickEvent(BeStrongList._ui["Layout"], function () SL:CloseBeStrongList() end)

    BeStrongList:UpdateList()
end

function BeStrongList:UpdateList()
    local data = SL:GetBeStrongListData()
    local nums = #data
    if nums < 1 then
        return false
    end

    local list = BeStrongList._ui["ListView"]
    local btnc = BeStrongList._ui["Button"]
    local pBg  = BeStrongList._ui["Panel_bg"]
    GUI:removeAllChildren(list)

    for _, v in ipairs(data) do
        local btn = GUI:Clone(btnc)
        GUI:ListView_pushBackCustomItem(list, btn)
        GUI:setVisible(btn, true)
        GUI:Button_setTitleText(btn, v.name)

        GUI:addOnClickEvent(btn, function ()
            if v.clickCB then
                v.clickCB()
            end
            GUI:setVisible(pBg, false)
        end)
    end

    local bgSize = GUI:getContentSize(pBg)
    local bSize  = GUI:getContentSize(btnc)
    local lSize  = GUI:getContentSize(list)
    local margin = GUI:ListView_getItemsMargin(list)
    local height = (bSize.height + margin) * math.min(nums, 4.5) - margin

    -- 最多显示4条 超过的滑动显示
    GUI:setContentSize(list, lSize.width, height)
    GUI:setContentSize(pBg, bgSize.width, height + 10)
end