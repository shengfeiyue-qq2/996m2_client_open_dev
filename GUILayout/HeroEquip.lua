-- 英雄面板 装备
HeroEquip = {}

HeroEquip._ui = nil

-- 13 斗笠位置比较特殊 属于和头盔位置同部位
HeroEquip.samePosDiff = {} -- 相同部位分开
HeroEquip._hideNodePos = {}
HeroEquip.RoleType = {
    Hero = 2 -- 英雄
}
function HeroEquip.main(data)
    HeroEquip.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_equip_node")

    HeroEquip._ui = GUI:ui_delegate(parent)
    if not HeroEquip._ui then
        return false
    end
    HeroEquip._parent = parent

    -- 初始化装备槽
    HeroEquip.InitEquipCells()
    -- 角色性别
    HeroEquip.playerSex = SL:GetMetaValue("H.SEX")
    -- 发型
    HeroEquip.playerHairID = SL:GetMetaValue("H.HAIR")
    -- 职业
    HeroEquip.playerJob = SL:GetMetaValue("H.JOB")

    -- 首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 -- 首饰盒功能是否开启
    GUI:setVisible(HeroEquip._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    HeroEquip._ui.Best_ringBox,
    function()
        -- 首饰盒是否开启
        local activeState = false
        -- 请求玩家首饰盒状态
        SL:RequestOpenHeroBestRings()

        GUI:delayTouchEnabled(HeroEquip._ui.Best_ringBox, 0.3)
    end
    )
    --刷新首饰盒状态
    HeroEquip.RefreshPlayerBestRingsOpenState()
    HeroEquip.RefreshBestRingBox()
    HeroEquip.RegisterEvent()
end


function HeroEquip.InitHideNodePos()
    HeroEquip._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if HeroEquip._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(HeroEquip._ui[string.format("Node_%s", i)])
            if not visible then
                HeroEquip._hideNodePos[i] = true
            end
        end
    end
end

function HeroEquip.InitEquipCells()
    local uid = SL:GetMetaValue("HERO_ID")
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    -- 额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroEquip.posSetting, 14)
        table.insert(HeroEquip.posSetting, 15)
    else
        GUI:setVisible(HeroEquip._ui.Panel_pos14, false)
        GUI:setVisible(HeroEquip._ui.Panel_pos15, false)
        GUI:setVisible(HeroEquip._ui.Node_14, false)
        GUI:setVisible(HeroEquip._ui.Node_15, false)

        local pos10x = (GUI:getPositionX(HeroEquip._ui.Panel_pos9) + GUI:getPositionX(HeroEquip._ui.Panel_pos10)) / 2 + 10
        local pos12x = (GUI:getPositionX(HeroEquip._ui.Panel_pos11) + GUI:getPositionX(HeroEquip._ui.Panel_pos12)) / 2 - 10
        local pos15x = GUI:getPositionX(HeroEquip._ui.Panel_pos15)
        local pos14x = GUI:getPositionX(HeroEquip._ui.Panel_pos14)
        GUI:setPositionX(HeroEquip._ui.Panel_pos10, pos10x)
        GUI:setPositionX(HeroEquip._ui.Panel_pos11, pos12x)
        GUI:setPositionX(HeroEquip._ui.Panel_pos12, pos15x)
        GUI:setPositionX(HeroEquip._ui.Panel_pos9, pos14x)

        GUI:setPositionX(HeroEquip._ui.Node_10, pos10x)
        GUI:setPositionX(HeroEquip._ui.Node_11, pos12x)
        GUI:setPositionX(HeroEquip._ui.Node_12, pos15x)
        GUI:setPositionX(HeroEquip._ui.Node_9, pos14x)
    end
end

function HeroEquip.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip.RoleType.Hero)
    if activeState then
        GUI:Image_setGrey(HeroEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip._ui.Image_box, true)
    end

    if data and data.isOpen then
        if activeState then
            SL:OpenBestRingBoxUI(HeroEquip.RoleType.Hero, { param = {} })
        else
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip._ui.Best_ringBox)
            -- 提示
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end
end

function HeroEquip.RefreshBestRingBox()
    SL:scheduleOnce(
    HeroEquip._ui.Best_ringBox, function()
        if Hero and HeroEquip._ui.Best_ringBox then
            local texture = "btn_jewelry_1_1.png"
            if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", HeroEquip.RoleType.Hero) then -- 首饰盒界面是否打开
                texture = "btn_jewelry_1_0.png"
            end
            GUI:Image_loadTexture(HeroEquip._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
            -- 重置尺寸
            GUI:setIgnoreContentAdaptWithSize(HeroEquip._ui.Image_box, true)
        end
        HeroEquip.RefreshPlayerBestRingsOpenState()
    end, 0.1 )
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroEquip.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function HeroEquip.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function HeroEquip.CloseCallback()
    HeroEquip.UnRegisterEvent()
end

function HeroEquip.RegisterEvent()

end

function HeroEquip.UnRegisterEvent()
end