PCSpellScope = {}

PCSpellScope._width      = 0    --施法宽度
PCSpellScope._height     = 0    --施法高度
PCSpellScope._range      = 0    --范围 格子
PCSpellScope._drawNode   = nil  --矩形框节点
function PCSpellScope.main()
    --只支持pc端
    if not SL:GetValue("IS_PC_OPER_MODE") then
        return
    end

    --刷新坐标
    SL:RegisterLUAEvent(LUA_EVENT_PC_SPELL_SCOPE_POS, "PCSpellScope", function()
        if PCSpellScope._drawNode then
            local mainPos = SL:GetValue("POS")
            GUI:setPosition(PCSpellScope._drawNode, mainPos.x, mainPos.y)
        end
    end)

    --获得范围 格子
    SL:RegisterLUAEvent(LUA_EVENT_PC_SPELL_SCOPE_CELL, "PCSpellScope", function(data)
        if data and type(data.cvMapRange) == "number" and data.cvMapRange > 0 then
            PCSpellScope._range = data.cvMapRange*2
            if CHECK_SETTING(SLDefine.SETTINGID.SETTING_IDX_SPELL_HELP) == 1 then
                PCSpellScope.CreateDrawPolygon(PCSpellScope._range)
            end
        end
    end)

    --pc开启关闭 施法辅助
    SL:RegisterLUAEvent(LUA_EVENT_PC_SPELL_SCOPE_SHOW_HIDE, "PCSpellScope", function(type)
        if PCSpellScope._drawNode then
            --删除施法辅助框
            if type ~= 1 then
                GUI:removeFromParent(PCSpellScope._drawNode)
                PCSpellScope._drawNode = nil
            end
        else
            --添加施法辅助框
            if type == 1 then
                PCSpellScope.CreateDrawPolygon(PCSpellScope._range)
            end
        end
    end)
end

function PCSpellScope.CreateDrawPolygon(range)
    PCSpellScope._width  = range * SLDefine.MapGrid.MapGridWidth
    PCSpellScope._height = range * SLDefine.MapGrid.MapGridHeight
    local pos         = GUI:p(0, 0)
    local size        = GUI:Size(PCSpellScope._width, PCSpellScope._height)
    local leftBottom  = GUI:p(pos.x - size.width/2, pos.y - size.height/2)
    local rightBottom = GUI:p(pos.x + size.width/2, pos.y - size.height/2)
    local rightTop    = GUI:p(pos.x + size.width/2, pos.y + size.height/2)
    local leftTop     = GUI:p(pos.x - size.width/2, pos.y + size.height/2)
    --线条颜色
    local borderColor = cc.c4f(255/255, 255/255, 0, 1)
    --线条宽度
    local borderWidth = 0.7

    PCSpellScope._drawNode = SL:CreateDrawPolygon(
        SLDefine.SceneZOrder.NODE_SKILL,       --场景节点
        {leftBottom, rightBottom, rightTop, leftTop},--顶点数组
        4,                                           --顶点数量
        cc.c4f(0,0,0,0),           --填充颜色
        borderWidth,                           --线条宽度
        borderColor                            --线条颜色
    )
end

PCSpellScope.main()