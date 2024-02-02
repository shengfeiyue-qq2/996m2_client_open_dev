HeroSuperEquip_Look = {}----查看他人面板 时装
HeroSuperEquip_Look._ui = nil

function HeroSuperEquip_Look.main(data)
    HeroSuperEquip_Look.posSetting = {
        17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45
    }
    local parent = GUI:Attach_Parent()
    local path = "hero_look/hero_super_equip_node_win32"
    GUI:LoadExport(parent, path)

    HeroSuperEquip_Look._ui = GUI:ui_delegate(parent)
    if not HeroSuperEquip_Look._ui then
        return false
    end
    HeroSuperEquip_Look._parent = parent
    HeroSuperEquip_Look._hideNodePos = {}
    local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
    HeroSuperEquip_Look._show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0 --是否显示裸模 0开启  1关闭

    HeroSuperEquip_Look.playerSex = SL:GetMetaValue("L.M.SEX") --角色性别
    HeroSuperEquip_Look.playerHairID = SL:GetMetaValue("L.M.HAIR") --发型
    HeroSuperEquip_Look.playerJob = SL:GetMetaValue("L.M.JOB") --职业

    --初始化装备槽
    HeroSuperEquip_Look.InitEquipCells()
    --初始化是否显示时装开关
    HeroSuperEquip_Look.InitEquipSetting()
    return true
end

function HeroSuperEquip_Look.InitHideNodePos()
    HeroSuperEquip_Look._hideNodePos = {}
    for _, i in ipairs(HeroSuperEquip_Look.posSetting) do
        if i ~= 17 and  i ~= 18 and i ~= 45 and i ~= 21 then
            if HeroSuperEquip_Look._ui[string.format("Node_%s", i)] then
                local visible = GUI:getVisible(HeroSuperEquip_Look._ui[string.format("Node_%s", i)])
                if not visible then
                    HeroSuperEquip_Look._hideNodePos[i] = true
                end
            end
        end
    end
end

function HeroSuperEquip_Look.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetMetaValue("SERVER_OPTION","OpenFEquip") 
    if openFEquip and openFEquip == 0 then
        table.insert(HeroSuperEquip_Look.posSetting, 42)
        table.insert(HeroSuperEquip_Look.posSetting, 44)
        local newPosSetting = { 17, 18 }
        for i, pos in ipairs(HeroSuperEquip_Look.posSetting) do
            if not newPosSetting[pos] then
                local equipPanel = HeroSuperEquip_Look._ui["Panel_pos" .. pos]
                GUI:setVisible(equipPanel,false)
            end
        end
        HeroSuperEquip_Look.posSetting = {}
        HeroSuperEquip_Look.posSetting = newPosSetting
        return
    end

    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroSuperEquip_Look.posSetting, 42)
        table.insert(HeroSuperEquip_Look.posSetting, 44)
    else
        GUI:setVisible(HeroSuperEquip_Look._ui.Panel_pos44,false)
        GUI:setVisible(HeroSuperEquip_Look._ui.Panel_pos42,false)
    end
end

function HeroSuperEquip_Look.InitEquipSetting()
    GUI:setVisible(HeroSuperEquip_Look._ui.Text_shizhuang,false)
    GUI:setVisible(HeroSuperEquip_Look._ui.CheckBox_shizhuang,false)
end

--[[
    创建装备回调
    item 装备
    返回 item
]]
function HeroSuperEquip_Look.CreateEquipItemCallBack(item)
    return item
end
--[[
    创建人物模型回调
]]
function HeroSuperEquip_Look.CreateModelCallBack(model)
    return model
end
return HeroSuperEquip_Look