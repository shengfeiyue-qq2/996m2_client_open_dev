HeroEquip_Look = {}----查看他人英雄面板 装备
HeroEquip_Look._ui = nil -- 13 斗笠位置比较特殊 属于和头盔位置同部位
HeroEquip_Look.samePosDiff = {} --相同部位分开
HeroEquip_Look._hideNodePos = {}
HeroEquip_Look.RoleType = {
    OtherHero = 12 --他人英雄
}
function HeroEquip_Look.main(data)
    HeroEquip_Look.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look/hero_equip_node")

    HeroEquip_Look._ui = GUI:ui_delegate(parent)
    if not HeroEquip_Look._ui then
        return false
    end
    HeroEquip_Look._parent = parent

    --初始化装备槽
    HeroEquip_Look.InitEquipCells()

    -- 角色性别
    HeroEquip_Look.playerSex = SL:GetMetaValue("L.M.SEX")
    -- 发型
    HeroEquip_Look.playerHairID = SL:GetMetaValue("L.M.HAIR")
    -- 职业
    HeroEquip_Look.playerJob = SL:GetMetaValue("L.M.JOB")
    -------首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 --首饰盒功能是否开启
    GUI:setVisible(HeroEquip_Look._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    HeroEquip_Look._ui.Best_ringBox, function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look.RoleType.OtherHero)
        if activeState then
            SL:OpenBestRingBoxUI(HeroEquip_Look.RoleType.OtherHero, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end)
    GUI:Text_setString(HeroEquip_Look._ui.Text_guildinfo, "")
    --刷新首饰盒状态
    HeroEquip_Look.RefreshPlayerBestRingsOpenState()
    HeroEquip_Look.RefreshBestRingBox()
    ----------------------
    HeroEquip_Look.RegisterEvent()
end

function HeroEquip_Look.InitHideNodePos()
    HeroEquip_Look._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if HeroEquip_Look._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(HeroEquip_Look._ui[string.format("Node_%s", i)])
            if not visible then
                HeroEquip_Look._hideNodePos[i] = true
            end
        end
    end
end

function HeroEquip_Look.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")

    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    --额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroEquip_Look.posSetting, 14)
        table.insert(HeroEquip_Look.posSetting, 15)
    else
        GUI:setVisible(HeroEquip_Look._ui.Panel_pos14, false)
        GUI:setVisible(HeroEquip_Look._ui.Panel_pos15, false)
        GUI:setVisible(HeroEquip_Look._ui.Node_14, false)
        GUI:setVisible(HeroEquip_Look._ui.Node_15, false)

        local pos10x = (GUI:getPositionX(HeroEquip_Look._ui.Panel_pos9) + GUI:getPositionX(HeroEquip_Look._ui.Panel_pos10)) / 2 + 10
        local pos12x = (GUI:getPositionX(HeroEquip_Look._ui.Panel_pos11) + GUI:getPositionX(HeroEquip_Look._ui.Panel_pos12)) / 2 - 10
        local pos15x = GUI:getPositionX(HeroEquip_Look._ui.Panel_pos15)
        local pos14x = GUI:getPositionX(HeroEquip_Look._ui.Panel_pos14)
        GUI:setPositionX(HeroEquip_Look._ui.Panel_pos10, pos10x)
        GUI:setPositionX(HeroEquip_Look._ui.Panel_pos11, pos12x)
        GUI:setPositionX(HeroEquip_Look._ui.Panel_pos12, pos15x)
        GUI:setPositionX(HeroEquip_Look._ui.Panel_pos9, pos14x)

        GUI:setPositionX(HeroEquip_Look._ui.Node_10, pos10x)
        GUI:setPositionX(HeroEquip_Look._ui.Node_11, pos12x)
        GUI:setPositionX(HeroEquip_Look._ui.Node_12, pos15x)
        GUI:setPositionX(HeroEquip_Look._ui.Node_9, pos14x)
    end
end

function HeroEquip_Look.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look.RoleType.OtherHero)
    if activeState then
        GUI:Image_setGrey(HeroEquip_Look._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip_Look._ui.Image_box, true)
    end

    if data and data.isOpen then
        if not activeState then
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1)) --提示
        end
    end
end

function HeroEquip_Look.RefreshBestRingBox()
    SL:scheduleOnce(
    HeroEquip_Look._ui.Best_ringBox,
    function()
        if self and HeroEquip_Look._ui.Best_ringBox then
            local texture = "btn_jewelry_1_1.png"
            if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", HeroEquip_Look.RoleType.OtherHero) then --首饰盒界面是否打开
                texture = "btn_jewelry_1_0.png"
            end
            GUI:Image_loadTexture(HeroEquip_Look._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
            GUI:setIgnoreContentAdaptWithSize(HeroEquip_Look._ui.Image_box, true) --重置尺寸
        end
        HeroEquip_Look.RefreshPlayerBestRingsOpenState()
    end,
    0.1
    )
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroEquip_Look.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function HeroEquip_Look.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function HeroEquip_Look.CloseCallback()
    HeroEquip_Look.UnRegisterEvent()
end

function HeroEquip_Look.RegisterEvent()
end

function HeroEquip_Look.UnRegisterEvent()
end