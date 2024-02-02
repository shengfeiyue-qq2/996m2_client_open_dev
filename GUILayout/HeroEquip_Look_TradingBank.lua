HeroEquip_Look_TradingBank = {}----交易行英雄 装备
HeroEquip_Look_TradingBank._ui = nil 
-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
HeroEquip_Look_TradingBank.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔
HeroEquip_Look_TradingBank._hideNodePos = {}
HeroEquip_Look_TradingBank.RoleType = {
    TradingBankPlayer = 21, --交易行人物
}
function HeroEquip_Look_TradingBank.main(data)
    HeroEquip_Look_TradingBank.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_equip_node")

    HeroEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroEquip_Look_TradingBank._ui then
        return false
    end
    HeroEquip_Look_TradingBank._parent = parent

    --初始化装备槽
    HeroEquip_Look_TradingBank.InitEquipCells()

    -- 角色性别
    HeroEquip_Look_TradingBank.playerSex = SL:GetMetaValue("T.H.SEX")
    -- 发型
    HeroEquip_Look_TradingBank.playerHairID = SL:GetMetaValue("T.H.HAIR")
    -- 职业
    HeroEquip_Look_TradingBank.playerJob = SL:GetMetaValue("T.H.JOB")
    -------首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 --首饰盒功能是否开启
    GUI:setVisible(HeroEquip_Look_TradingBank._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    HeroEquip_Look_TradingBank._ui.Best_ringBox, function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look_TradingBank.RoleType.TradingBankPlayer)
        if activeState then
            SL:OpenBestRingBoxUI(HeroEquip_Look_TradingBank.RoleType.TradingBankPlayer, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look_TradingBank._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end)

    GUI:Text_setString(HeroEquip_Look_TradingBank._ui.Text_guildinfo, "")
    --刷新首饰盒状态
    HeroEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState()
    HeroEquip_Look_TradingBank.RefreshBestRingBox()
    ----------------------
    HeroEquip_Look_TradingBank.InitSamePosDiff()
    HeroEquip_Look_TradingBank.RegisterEvent()
end

-- 初始化相同部位显示不同
function HeroEquip_Look_TradingBank.InitSamePosDiff()
    HeroEquip_Look_TradingBank._pos13Visible = false
    if HeroEquip_Look_TradingBank._pos13Visible then
        table.insert(HeroEquip_Look_TradingBank.posSetting, 13)
        table.insert(HeroEquip_Look_TradingBank.posSetting, 55)
        HeroEquip_Look_TradingBank.samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(HeroEquip_Look_TradingBank._ui.Panel_pos55, HeroEquip_Look_TradingBank._pos13Visible)
    GUI:setVisible(HeroEquip_Look_TradingBank._ui.Node_55, HeroEquip_Look_TradingBank._pos13Visible)
end

function HeroEquip_Look_TradingBank.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")
    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    --额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroEquip_Look_TradingBank.posSetting, 14)
        table.insert(HeroEquip_Look_TradingBank.posSetting, 15)
    else
        GUI:setVisible(HeroEquip_Look_TradingBank._ui.Panel_pos14, false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui.Panel_pos15, false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui.Node_14, false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui.Node_15, false)
    end
end


function HeroEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look_TradingBank.RoleType.TradingBankPlayer)
    if activeState then
        GUI:Image_setGrey(HeroEquip_Look_TradingBank._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip_Look_TradingBank._ui.Image_box, true)
    end

    if data and data.isOpen then
        if not activeState then
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look_TradingBank._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1)) --提示
        end
    end
end

function HeroEquip_Look_TradingBank.RefreshBestRingBox()
    SL:scheduleOnce(
    HeroEquip_Look_TradingBank._ui.Best_ringBox,
    function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", HeroEquip_Look_TradingBank.RoleType.TradingBankPlayer) then --首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(HeroEquip_Look_TradingBank._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
        GUI:setIgnoreContentAdaptWithSize(HeroEquip_Look_TradingBank._ui.Image_box, true) --重置尺寸
        HeroEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState()
    end,
    0.1
    )
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroEquip_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function HeroEquip_Look_TradingBank.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function HeroEquip_Look_TradingBank.CloseCallback()
    HeroEquip_Look_TradingBank.UnRegisterEvent()
end

function HeroEquip_Look_TradingBank.RegisterEvent()
end

function HeroEquip_Look_TradingBank.UnRegisterEvent()
end