SettingProtocol = {}

function SettingProtocol.main()
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    -- listview 容器
    local FrameList = GUI:ScrollView_Create(parent, "FrameList", 0, 0, attachW, attachH, 1)
    GUI:setSwallowTouches(FrameList, false)

    -- 标题
    local TitleText1 = GUI:Text_Create(FrameList, "TitleText1", 15, 0, 18, "#f8e6c6", "隐私协议")
    local TitleText2 = GUI:Text_Create(FrameList, "TitleTxet2", 15, 0, 18, "#f8e6c6", "注销账号")
    local TitleText3 = GUI:Text_Create(FrameList, "TitleText3", 15, 0, 18, "#f8e6c6", "信息收集")

    -- 隐私协议
    local layout1 = GUI:Layout_Create(FrameList, "layout1", 0, 0, 0, 0, true)
    local data1 = SettingProtocol.GetDataByType(1)
    for i,data in ipairs(data1) do
        if data then
            local btn = GUI:Button_Create(layout1, "btn"..i, 0, 0, "res/private/setting/1900000820.png")
            GUI:Button_setTitleText(btn, data.name)
            GUI:Button_setTitleFontSize(btn, 16)
            GUI:addOnClickEvent(btn, function ()
                if data.callback then
                    data.callback()
                end
            end)
        end
    end
    if not data1 or not next(data1) then
        GUI:setVisible(TitleText1, false)
    end
    GUI:UserUILayout(layout1, {
        dir = 3, addDir = 1, autosize = true, colnum = 4, gap = {x = 88, y = 30,l = 40}
    })

    -- 注销账号
    local layout2 = GUI:Layout_Create(FrameList, "layout2", 0, 0, 0, 0, true)
    local data2 = SettingProtocol.GetDataByType(2)
    if data2 then
        local btn = GUI:Button_Create(layout2, "btn", 0, 0, "res/private/setting/1900000820.png")
        GUI:Button_setTitleText(btn, data2.name)
        GUI:Button_setTitleFontSize(btn, 16)
        GUI:addOnClickEvent(btn, function ()
            if data2.callback then
                data2.callback()
            end
        end)
    else
        GUI:setVisible(TitleText2, false)
    end
    GUI:UserUILayout(layout2, {
        dir = 3, addDir = 1, autosize = true, colnum = 4, gap = {x = 88, l = 40}
    })

    -- 个人信息收集
    local layout3 = GUI:Layout_Create(FrameList, "layout3", 0, 0, 0, 0, true)
    local data3 = SettingProtocol.GetDataByType(3)
    if data3 then
        local btn = GUI:Button_Create(layout3, "btn", 0, 0, "res/private/setting/1900000820.png")
        GUI:Button_setTitleText(btn, data3.name)
        GUI:Button_setTitleFontSize(btn, 16)
        GUI:addOnClickEvent(btn, function ()
            if data3.callback then
                data3.callback()
            end
        end)
    else
        GUI:setVisible(TitleText3, false)
    end
    GUI:UserUILayout(layout3, {
        dir = 3, addDir = 1, autosize = true, colnum = 4, gap = {x = 88, l = 40}
    })

    local hh1 = GUI:getContentSize(layout1).height
    local hh2 = GUI:getContentSize(layout2).height
    local hh3 = GUI:getContentSize(layout3).height
    local hh = hh1 + hh2 + hh3 + 50 * 3

    -- 滚动层的内部滚动高度
    hh = math.max(attachH, hh)
    GUI:ScrollView_setInnerContainerSize(FrameList, attachW, hh)

    GUI:setPositionY(layout1, hh - hh1 - 50)
    GUI:setPositionY(layout2, hh - hh1 - hh2 - 50 * 2)
    GUI:setPositionY(layout3, hh - hh1 - hh2 - hh3 - 50 * 3)
    GUI:setPositionY(TitleText1, hh - 40)
    GUI:setPositionY(TitleText2, hh - hh1 - 90)
    GUI:setPositionY(TitleText3, hh - hh1 - hh2 - 140)
end