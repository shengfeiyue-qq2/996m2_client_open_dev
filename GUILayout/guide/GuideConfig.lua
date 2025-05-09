local function getChildInSubNodes(nodeTable, key)
    if #nodeTable == 0 then
        return nil
    end
    local child = nil
    local subNodeTable = {}
    for _, v in ipairs(nodeTable) do
        if GUI:Widget_IsNull(v) then
            return nil
        end
        child = GUI:getChildByName(v, key)
        if (child) then
            return child
        end
    end
    for _, v in ipairs(nodeTable) do
        local subNodes = GUI:getChildren(v)
        if #subNodes ~= 0 then
            for _, v1 in ipairs(subNodes) do
                table.insert(subNodeTable, v1)
            end
        end
    end
    return getChildInSubNodes(subNodeTable, key)
end

local function getChildByKey(parent, key)
    return getChildInSubNodes({ parent }, key)
end

-- 基础指引：
-- 0 NPC面板组件            辅助参数.组件id
-- 101 主界面左上挂节点        辅助参数.组件id  挂节点.101
-- 102 主界面右上挂节点        辅助参数.组件id  挂节点.102
-- 103 主界面左下挂节点        辅助参数.组件id  挂节点.103
-- 104 主界面右下挂节点        辅助参数.组件id  挂节点.104
-- 105 主界面左中挂节点        辅助参数.组件id  挂节点.105
-- 106 主界面上中挂节点        辅助参数.组件id  挂节点.106
-- 107 主界面右中挂节点        辅助参数.组件id  挂节点.107
-- 108 主界面下中挂节点        辅助参数.组件id  挂节点.108
-- GuideWidgetConfig.lua
local function store_func(config)
    local layer = GUI:GetWindow(nil, UIConst.LAYERID.StoreFrameGUI)
    if not layer then
        return nil
    end

    local id = tostring(config.typeassist)
    if not StorePageInfo or not StorePageInfo._parent then
        return nil
    end
    if not StorePageInfo._ui.ScrollView_list then
        return nil
    end
    local chs = GUI:getChildren(StorePageInfo._ui.ScrollView_list)
    for i, v in ipairs(chs) do
        local layout = GUI:getChildByName(v, "Panel_item")
        if id == (layout and tostring(layout["guide_id"])) then
            return layout, StorePageInfo._parent
        end
    end
    return nil
end
local config = {
    -- npc面板组件
    [0] = function(config)
        local layer = SL:GetValue("CURRENT_TALK_NPC_LAYER")
        if not layer then
            return nil
        end
        local widget = getChildByKey(layer, tostring(config.typeassist))
        return widget, layer
    end,
    -- 背包道具
    [1] = function(config)
        local isMergePanelMode = GUIDefineEx.IsMergeMode

        local parent = isMergePanelMode and GUI:GetWindow(nil, UIConst.LAYERID.MergeBagLayerGUI) or
        GUI:GetWindow(nil, UIConst.LAYERID.BagLayerGUI)
        if not parent then
            return nil
        end

        local layer = isMergePanelMode and MergeBagInfo._ui or BagInfo._ui
        if isMergePanelMode then
            if not layer or not layer.Panel_items or MergeBagInfo._selType ~= 1 then
                return nil
            end
        else
            if not layer or not layer.Panel_items then
                return nil
            end
        end
        local Panel_items = layer.Panel_items
        if not Panel_items then
            return nil
        end
        local items = GUI:getChildren(Panel_items)
        local widget = nil
        if tonumber(config.typeassist) == -1 then
            widget = isMergePanelMode and layer.Button_store_mode or layer.Button_store_hero_bag
        else
            for i, v in ipairs(items) do
                if GUI:getStrTag(v) == config.typeassist then
                    widget = v
                    break
                end
            end
        end
        return widget, parent
    end,
    -- 人物装备位
    [2] = function(config)
        local parent = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not parent then
            return nil
        end

        local ui = GUI:getChildByName(PlayerFrame._ui["Node_panel"], "EquipUI")
        if not ui then
            return nil
        end

        local widget = ui["PanelPos" .. tostring(config.typeassist)]
        if not widget then
            return nil
        end

        return widget, PlayerEquip._parent
    end,
    -- 英雄背包
    [3] = function(config)
        local isMergePanelMode = GUIDefineEx.IsMergeMode

        local parent = isMergePanelMode and GUI:GetWindow(nil, UIConst.LAYERID.MergeBagLayerGUI) or GUI:GetWindow(nil, UIConst.LAYERID.HeroBagLayerGUI)
        if not parent then
            return nil
        end

        local layer = isMergePanelMode and MergeBagInfo._ui or HeroBagInfo._ui
        local isMergeMode = false
        if isMergePanelMode then
            isMergeMode = true
            if not layer or not layer.Panel_items or MergeBagInfo._selType ~= 2 then
                return nil
            end
        else
            if not layer or not layer.itemPanel then
                return nil
            end
        end
        local Panel_items = isMergeMode and layer.Panel_items or layer.itemPanel
        if not Panel_items then
            return nil
        end
        local items = GUI:getChildren(Panel_items)
        local widget = nil
        if tonumber(config.typeassist) ~= -1 then
            for i, v in ipairs(items) do
                if GUI:getStrTag(v) == tonumber(config.typeassist) then
                    widget = v
                    break
                end
            end
        end
        return widget, parent
    end,
    -- 背包挂接组件
    [7] = function(config)
        local isMergePanelMode = GUIDefineEx.IsMergeMode

        local parent = isMergePanelMode and GUI:GetWindow(nil, UIConst.LAYERID.MergeBagLayerGUI) or GUI:GetWindow(nil, UIConst.LAYERID.BagLayerGUI)
        if not parent then
            return nil
        end

        local layer = isMergePanelMode and MergeBag._layer or Bag._layer
        if isMergePanelMode then
            if not layer or MergeBagInfo._selType ~= 1 then
                return nil
            end
        else
            if not layer then
                return nil
            end
        end
        local widget = getChildByKey(layer, tostring(config.typeassist))
        return widget, layer
    end,
    --商店
    [9] = store_func,
    [10] = store_func,
    [11] = store_func,
    [12] = store_func,
    --英雄状态板
    [40] = function(config)
        --1 英雄头像   2 状态   3 背包 4召唤/收回
        local widget, parent
        local uiId = tonumber(config.typeassist)
        if not uiId or uiId > 4 or uiId < 1 then
            return
        end
        if uiId == 1 or not SL:GetValue("IS_PC_OPER_MODE") then
            local nodeParent = GUI:Attach_Top()
            if not nodeParent or GUI:getChildByName(nodeParent, "Hero_State") then
                return nil
            end

            local layer = HeroState._root
            if not layer then
                return nil
            end

            local child = { "Image_head", "Button_state", "Button_bag", "Button_hero" }

            widget = getChildByKey(layer, child[tonumber(config.typeassist)])
            parent = layer
        else
            local nodeParent = GUI:Attach_Bottom()
            if not nodeParent or GUI:getChildByName(nodeParent, "Main_Property") then
                return nil
            end

            local ui = MainProperty and MainProperty._ui
            if not ui then
                return nil
            end

            local child = { "Image_head", "Button_heroinfo", "Button_herobag", "Button_herostate" }

            widget = getChildByKey(ui, child[tonumber(config.typeassist)])
            parent = ui
        end

        if uiId < 4 then
            if not SL:GetValue("HERO_IS_ALIVE") then
                return
            end
        end
        return widget, parent
    end,
    -- 英雄装备位
    [41] = function(config)
        local parent = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not parent then
            return nil
        end

        local ui = HeroEquip and HeroEquip._ui
        if not ui then
            return nil
        end

        local widget = ui["PanelPos" .. tostring(config.typeassist)]
        if not widget then
            return nil
        end

        return widget, HeroEquip._parent
    end,


    -- 主界面 挂接组件 左上
    [101] = function(config)
        local leftTop = GUI.ATTACH_LEFTTOP
        if not leftTop then
            return nil
        end

        local widget = getChildByKey(GUI.ATTACH_LEFTTOP, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 右上
    [102] = function(config)
        local rightTop = GUI.ATTACH_RIGHTTOP
        if not rightTop then
            return nil
        end

        local widget = getChildByKey(rightTop, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 左下
    [103] = function(config)
        local leftBottom = GUI.ATTACH_LEFTBOTTOM
        if not leftBottom then
            return nil
        end

        local widget = getChildByKey(leftBottom, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 右下
    [104] = function(config)
        local rightBottom = GUI.ATTACH_RIGHTBOTTOM
        if not rightBottom then
            return nil
        end

        local widget = getChildByKey(rightBottom, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 左中
    [105] = function(config)
        local leftMiddle = GUI.ATTACH_LEFT_MIDDLE
        if not leftMiddle then
            return nil
        end

        local widget = getChildByKey(leftMiddle, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 上中
    [106] = function(config)
        local topMiddle = GUI.ATTACH_TOP_MIDDLE
        if not topMiddle then
            return nil
        end

        local widget = getChildByKey(topMiddle, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 右中
    [107] = function(config)
        local rightMiddle = GUI.ATTACH_RIGHT_MIDDLE
        if not rightMiddle then
            return nil
        end

        local widget = getChildByKey(rightMiddle, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 下中
    [108] = function(config)
        local bottomMiddle = GUI.ATTACH_BOTTOM_MIDDLE
        if not bottomMiddle then
            return nil
        end

        local widget = getChildByKey(bottomMiddle, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面技能模块 按钮
    [109] = function(config)
        local widget = GUI:GetWindow(nil, UIConst.LUAFile.LUA_FILE_MAIN_SKILL)
        if not widget then
            return nil
        end
        if not MainSkill._ui then
            return nil
        end


        local widget = getChildByKey(MainSkill._ui["Panel_active"], tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 导航栏 任务
    [110] = function(config)
        local assistWidget = getChildByKey(GUI:Attach_LeftTop(), "Main_Assist")
        if not assistWidget then
            return nil
        end
        if not MainAssist or not MainAssist._ui then
            return nil
        end

        if not SL:GetValue("IS_PC_OPER_MODE") then
            if MainAssist._assistGroup ~= 2 then
                return nil
            end

            if MainAssist._contentIndex ~= 1 then
                return nil
            end
        end

        local listView = MainAssist._ui["ListView_task"]
        if not listView then
            return nil
        end
        GUI:ListView_doLayout(listView)

        local taskID = tonumber(config.typeassist)
        local cell = GUI:getChildByTag(listView, taskID)

        -- 没找到任务的 找挂接按钮
        if not cell then
            local widget = getChildByKey(assistWidget, tostring(config.typeassist))
            local parent = assistWidget
            return widget, parent
        end

        if not cell or not cell.Button_act then
            return
        end

        local anchorY   = GUI:getAnchorPoint(listView).y
        local limitYMAX = GUI:getWorldPosition(listView).y + GUI:getContentSize(listView).height * (1 - anchorY)
        local limitYMIN = GUI:getWorldPosition(listView).y - GUI:getContentSize(listView).height * anchorY
        local btnAnY    = GUI:getAnchorPoint(cell.Button_act).y
        local cellYMAX  = GUI:getWorldPosition(cell.Button_act).y +
        GUI:getContentSize(cell.Button_act).height * (1 - btnAnY)
        local cellYMIN  = GUI:getWorldPosition(cell.Button_act).y -
        GUI:getContentSize(cell.Button_act).height * btnAnY
        if cellYMAX > limitYMAX or cellYMIN < limitYMIN then
            local idx = GUI:ListView_getItemIndex(listView, cell)
            if idx then
                GUI:ListView_jumpToItem(listView, idx)
            end
        end

        local widget = cell.Button_act
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最底左上
    [1001] = function(config)
        local bLeftTop = GUI.ATTACH_LEFTTOP_B
        if not bLeftTop then
            return nil
        end

        local widget = getChildByKey(bLeftTop, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最底右上
    [1002] = function(config)
        local bRightTop = GUI.ATTACH_RIGHTTOP_B
        if not bRightTop then
            return nil
        end

        local widget = getChildByKey(bRightTop, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最底左下
    [1003] = function(config)
        local bLeftBottom = GUI.ATTACH_LEFTBOTTOM_B
        if not bLeftBottom then
            return nil
        end

        local widget = getChildByKey(bLeftBottom, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最底右下
    [1004] = function(config)
        local bRightBottom = GUI.ATTACH_RIGHTBOTTOM_B
        if not bRightBottom then
            return nil
        end

        local widget = getChildByKey(bRightBottom, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最顶左上
    [1101] = function(config)
        local tLeftTop = GUI.ATTACH_LEFTTOP_T
        if not tLeftTop then
            return nil
        end

        local widget = getChildByKey(tLeftTop, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最顶右上
    [1102] = function(config)
        local tRightTop = GUI.ATTACH_RIGHTTOP_T
        if not tRightTop then
            return nil
        end

        local widget = getChildByKey(tRightTop, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最顶左下
    [1103] = function(config)
        local tLeftBottom = GUI.ATTACH_LEFTBOTTOM_T
        if not tLeftBottom then
            return nil
        end

        local widget = getChildByKey(tLeftBottom, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 主界面 挂接组件 最顶右下
    [1104] = function(config)
        local tRightLeft = GUI.ATTACH_RIGHTBOTTOM_T
        if not tRightLeft then
            return nil
        end

        local widget = getChildByKey(tRightLeft, tostring(config.typeassist))
        local parent = GUI.ATTACH_GUIDE
        return widget, parent
    end,

    -- 996盒子导航
    [111] = function(config)
        local layer = SL:GetValue("BOX996_LAYER")

        if not layer then
            return nil
        end
        local widget, parent
        local index = tonumber(config.typeassist)
        parent = layer._ui.Panel_1
        if index == 5 then
            widget = layer._ui.Button_close
        elseif index and index >= 1 and index <= 4 then
            widget = layer._ui["Button_" .. index]
        else
            widget = getChildByKey(layer._ui.Node_child, tostring(config.typeassist))
        end
        return widget, parent
    end,
    -- 双端背包 等按钮  因为要支持pc只能固定id  100-102 个人信息 背包 技能信息
    [200] = function(config)
        if SL:GetValue("IS_PC_OPER_MODE") then
            local num = tonumber(config.typeassist)
            if not num or num < 100 or num > 102 then
                return nil
            end

            local nodeParent = GUI:Attach_Center()
            if not nodeParent then
                return nil
            end

            local parent = GUI:getChildByName(nodeParent, "Main_Property")
            if not parent then
                return nil
            end

            local ui = MainProperty and MainProperty._ui
            if not ui then
                return nil
            end

            local btnname = { "Button_role", "Button_bag", "Button_skill" }
            local widget = ui[btnname[num - 99]]
            return widget, parent
        else
            local rightBottom = GUI.ATTACH_RIGHTBOTTOM
            if not rightBottom then
                return nil
            end

            local widget = getChildByKey(rightBottom, tostring(config.typeassist))
            local parent = GUI.ATTACH_GUIDE
            return widget, parent
        end
    end,
    --右下角切换按钮
    [201] = function(config)
        if SL:GetValue("IS_PC_OPER_MODE") then
            return nil
        end

        local widget = GUI:GetWindow(nil, UIConst.LUAFile.LUA_FILE_MAIN_SKILL)
        if not widget then
            return nil
        end

        if not MainSkill._ui then
            return nil
        end

        if not MainSkill._ui["Button_change"] then
            return nil
        end

        return MainSkill._ui["Button_change"], MainSkill._ui
    end,
    --玩家主面板
    [202] = function(config)
        local num = tonumber(config.typeassist)

        local widget = nil
        local isMergePanelMode = GUIDefineEx.IsMergeMode
        if isMergePanelMode then --合并面板模式
            widget = GUI:GetWindow(nil, UIConst.LAYERID.MergePlayerMainGUI)
        else
            widget = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        end

        if not widget then
            return nil
        end
        local layer = isMergePanelMode and MergePlayerFrame._ui or PlayerFrame._ui
        if num and num >= 1 and num <= 6 then
            local btnList = layer.Panel_btnList
            local btn = { 101, 102, 103, 104, 105, 106 }
            local name = "Button_" .. btn[num]
            local ch = GUI:getChildByName(btnList, name)
            if ch then
                return ch, widget
            end
        elseif num and num >= 101 and num <= 104 then -- 内功页签按钮
            local btnList = layer.Panel_btnList_ng
            if btnList and GUI:getVisible(btnList) then
                local name = "Button_" .. (num % 100)
                local btn = GUI:getChildByName(btnList, name)
                if btn then
                    return btn, widget
                end
            end
        elseif num == 1001 or num == 1002 then -- 基础/内功
            local layout = layer.topLayout
            if layout and GUI:getVisible(layout) then
                local btnNameL = {
                    [1001] = "base_btn",
                    [1002] = "ng_btn"
                }
                local btn = GUI:getChildByName(layout, btnNameL[num])
                if btn then
                    return btn, widget
                end
            end
        else
            local ch = getChildByKey(widget, tostring(config.typeassist))
            return ch, widget
        end
        return nil
    end,
    --英雄主面板
    [203] = function(config)
        local num = tonumber(config.typeassist)

        local widget = nil
        local isMergePanelMode = GUIDefineEx.IsMergeMode
        if isMergePanelMode then --合并面板模式
            widget = GUI:GetWindow(nil, UIConst.LAYERID.MergePlayerMainGUI)
        else
            widget = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        end

        if not widget then
            return nil
        end
        local layer = isMergePanelMode and MergePlayerFrame._ui or HeroFrame._ui
        if num and num >= 1 and num <= 6 then
            local btnList = layer.Panel_btnList
            local btn = { 1, 2, 3, 4, 6, 11 }
            local name = "Button_" .. btn[num]
            local ch = GUI:getChildByName(btnList, name)
            if ch then
                return ch, widget
            end
        elseif num and num >= 101 and num <= 104 then -- 内功页签按钮
            local btnList = layer.Panel_btnList_ng
            if btnList and GUI:getVisible(btnList) then
                local name = "Button_" .. (num % 100)
                local btn = GUI:getChildByName(btnList, name)
                if btn then
                    return btn, widget
                end
            end
        elseif num == 1001 or num == 1002 then -- 基础/内功
            local layout = layer.topLayout
            if layout and GUI:getVisible(layout) then
                local btnNameL = {
                    [1001] = "base_btn",
                    [1002] = "ng_btn"
                }
                local btn = GUI:getChildByName(layout, btnNameL[num])
                if btn then
                    return btn, widget
                end
            end
        else
            local ch = getChildByKey(widget, tostring(config.typeassist))
            return ch, widget
        end
        return nil
    end,
    -- 人物经脉面板-按钮
    [204] = function(config) -- 暂未开放
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end

        local idList = { 2, 3, 4, 5, 1 }
        local idx = tonumber(config.typeassist)
        if PlayerInternalMeridian._ui.Panel_content and idx then
            local name = idList[idx] and string.format("Button_%s", idList[idx])
            local widget = name and GUI:getChildByName(PlayerInternalMeridian._ui.Panel_content, name)
            if widget then
                return widget, PlayerInternalMeridian._ui
            end
        end
        -- 找挂接的
        local widget = getChildByKey(PlayerInternalMeridian._ui, tostring(config.typeassist))
        return widget, PlayerInternalMeridian
    end,
    -- 英雄经脉面板-按钮
    [205] = function(config) -- 暂未开放
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end
        
        local idList = { 2, 3, 4, 5, 1 }
        local idx = tonumber(config.typeassist)
        if HeroInternalMeridian._ui.Panel_content and idx then
            local name = idList[idx] and string.format("Button_%s", idList[idx])
            local widget = name and GUI:getChildByName(HeroInternalMeridian._ui.Panel_content, name)
            if widget then
                return widget, HeroInternalMeridian._ui
            end
        end
        -- 找挂接的
        local widget = getChildByKey(HeroInternalMeridian._ui, tostring(config.typeassist))
        return widget, HeroInternalMeridian._ui
    end,
    --人物状态面板
    [211] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end
        
        local parent = PlayerBaseAtt._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --人物属性面板
    [212] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end

        local parent = PlayerExtraAtt._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --人物技能面板
    [213] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end

        local parent = PlayerSkill._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --人物称号面板
    [214] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end

        local parent = PlayerTitle._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --人物时装面板
    [215] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI)
        if not layer then
            return nil
        end

        local parent = PlayerSuperEquip._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --英雄状态面板
    [231] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not layer then
            return nil
        end

        local parent = HeroBaseAtt._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --英雄属性面板
    [232] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not layer then
            return nil
        end

        local parent = HeroExtraAtt._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --英雄技能面板
    [233] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not layer then
            return nil
        end

        local parent = HeroSkill._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --英雄称号面板
    [234] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not layer then
            return nil
        end

        local parent = HeroTitle._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
    --英雄时装面板
    [235] = function(config)
        local layer = GUI:GetWindow(nil, UIConst.LAYERID.HeroMainGUI)
        if not layer then
            return nil
        end

        local parent = HeroSuperEquip._ui
        if not parent then
            return nil
        end
        local widget = getChildByKey(parent, tostring(config.typeassist))
        return widget, parent
    end,
}

return config
