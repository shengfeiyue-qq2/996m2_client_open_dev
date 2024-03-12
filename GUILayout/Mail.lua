Mail = {}

Mail._mDatas = {}

Mail._selMailID = -1     -- 当前选中的邮件mailID

function Mail.main( ... )
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "mail/mail")

    Mail._ui = GUI:ui_delegate(parent)
    if not Mail._ui then
        return false
    end

    GUI:setVisible(Mail._ui["mainPanel"], false)

    -- 请求邮件列表
    SL:RequestMailList()

    Mail._mDatas = {}

    Mail._selMailID = -1

    Mail.InitEvent()

    SL:RegisterLUAEvent(LUA_EVENT_MAIL_LIST_REFRESH, "Mail", Mail.onUpdateMailList)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_DELETE, "Mail", Mail.onDeleteMail)
end

function Mail.InitEvent()
    -- 全部提取
    GUI:addOnClickEvent(Mail._ui["btnGetAll"], function ()
        SL:RequestGetAllMailItems()
    end)

    -- 删除已读
    GUI:addOnClickEvent(Mail._ui["btnDelRead"], function ()
        if SL:GetMetaValue("MAIL_HAVE_DEL_ITEM") then
            SL:RequestDelReadMail()
        else
            if Mail._mDatas and next(Mail._mDatas) then
                SL:ShowSystemTips("有邮件附件未提取，删除失败")
            else
                SL:ShowSystemTips("没有可删除邮件")
            end
        end
    end)

    -- 提取
    GUI:addOnClickEvent(Mail._ui["btnGet"], function ()
        if Mail._selMailID ~= -1 then
            SL:RequestGetMailItems(Mail._selMailID)
        end
    end)

    -- 删除
    GUI:addOnClickEvent(Mail._ui["btnDel"], function (sender)
        GUI:setClickDelay(sender, 0.1)
        if Mail._selMailID ~= -1 then
            SL:RequestDelMail(Mail._selMailID)
        end
    end)
end

function Mail.CreateMailItem(parent, mailID, mail)
    GUI:LoadExport(parent, "mail/mail_cell")
    local Cell = GUI:getChildByName(parent, "Cell")
    local ui = GUI:ui_delegate(Cell)

    -- 发送者名字
    GUI:Text_setString(ui["name"], mail.sSendName)
    
    -- 邮件描述
    GUI:Text_setString(ui["tips"], mail.sLable)

    local isSel = Mail._selMailID == mailID
    GUI:Button_setBright(ui["btnMail"], isSel)
    GUI:setTouchEnabled(ui["btnMail"], not isSel)

    GUI:setVisible(ui["select"], isSel)

    -- 删除按钮
    GUI:setVisible(ui["btnDel"], false)

    -- 状态(0: 未读; 1: 已读)
    local state = mail.btReadFlag

    -- 未读红点提示
    GUI:setVisible(ui["red"], state == 0)

    if state == 1 then
        if #mail.sItem > 0 then
            if mail.btRecvFlag == 1 then
                GUI:setVisible(ui["btnDel"], true)
            end
        else
            GUI:setVisible(ui["btnDel"], true)
        end
    end

    GUI:addOnClickEvent(ui["btnDel"], function()
        SL:RequestDelMail(mailID)
    end)

    GUI:addOnClickEvent(ui["btnMail"], function()
        Mail._selMailID = mailID
        Mail.RefreshMainPanel()
        Mail.RefreshCells()
    end)

    return Cell
end

-- 默认显示
function Mail.ShowDefaultMainPanel()
    GUI:setVisible(Mail._ui["mainPanel"], true)

    GUI:Text_setString(Mail._ui["sender"], "")
    GUI:Text_setString(Mail._ui["title"], "")
    GUI:Text_setString(Mail._ui["time"], "")

    GUI:setVisible(Mail._ui["completed"], false)
    GUI:setVisible(Mail._ui["lblItem"], false)
    GUI:setVisible(Mail._ui["itemsList"], false)

    GUI:setVisible(Mail._ui["btnGet"], false)
    GUI:setVisible(Mail._ui["btnDel"], false)
end

-- 刷新右边的邮件信息
function Mail.RefreshMainPanel()
    Mail.ShowDefaultMainPanel()

    if not Mail._mDatas or not next(Mail._mDatas) then
        return false
    end

    local mailID = Mail._selMailID

    if mailID == -1 then
        return false
    end

    local mail = Mail._mDatas[mailID]
    if not mail then
        return false
    end

    -- 请求读邮件
    if mail.btReadFlag == 0 then
        SL:RequestReadMail(mailID)
    end

    -- 主题
    local lblTitle = Mail._ui["lblTitle"]
    local title    = Mail._ui["title"]
    GUI:Text_setString(title, mail.sLable)
    GUI:setPositionX(title, GUI:getPositionX(lblTitle) + GUI:getContentSize(lblTitle).width)

    -- 发送者
    local lblSender = Mail._ui["lblSender"]
    local sender    = Mail._ui["sender"]
    GUI:Text_setString(sender, mail.sSendName)
    GUI:setPositionX(sender, GUI:getPositionX(lblSender) + GUI:getContentSize(lblSender).width)

    -- 时间
    local lblTime = Mail._ui["lblTime"]
    local time    = Mail._ui["time"]
    GUI:Text_setString(time, mail.dCreateTime)
    GUI:setPositionX(time, GUI:getPositionX(lblTime) + GUI:getContentSize(lblTime).width)
    
    -- 内容
    local contentList = Mail._ui["contentList"]
    GUI:ListView_removeAllItems(contentList)

    local richW = GUI:getContentSize(contentList).width
    local richText = GUI:RichText_Create(contentList, "richText" .. mailID, 0, 0, mail.sMemo, richW, 16, "#f8e6c6")
    GUI:setAnchorPoint(richText, 0, 1)

    GUI:ListView_doLayout(contentList)

    local list_items = Mail._ui["itemsList"]

    local sItem = mail.sItem
    if #sItem > 0 then
        -- 附件
        GUI:removeAllChildren(list_items)
        GUI:setVisible(list_items, true)

        GUI:setVisible(Mail._ui["lblItem"], true)

        -- 是否已领取
        local isGet = mail.btRecvFlag ~= 0

        GUI:setVisible(Mail._ui["completed"], isGet)
        GUI:setVisible(Mail._ui["btnDel"], isGet)
        GUI:setVisible(Mail._ui["btnGet"], not isGet)

        local countFontSize = SL:GetMetaValue("WINPLAYMODE") and 10 or nil

        if mail.btType == 9999 then -- 交易行的附件
            local itemData = SL:TransItemDataIntoChatShow(SL:JsonDecode(mail.sItem))
            local item = GUI:ItemShow_Create(list_items, "item", 0, 0, {index = itemData.Index, itemData = itemData, count = itemData.OverLap, look = true, countFontSize = countFontSize, bgVisible = true})
            if mail.btRecvFlag == 1 then
                GUI:ItemShow_setIconGrey( item, true)
            end
        else
            for i=1, #sItem do
                local items = mail.sItem[i]
                local item = GUI:ItemShow_Create(list_items, "item" .. i, 0, 0, {index = items.I, count = items.C, look = true, countFontSize = countFontSize, bgVisible = true})
                if mail.btRecvFlag == 1 then
                    GUI:ItemShow_setIconGrey( item, true)
                end
            end
        end
    else
        -- 没附件
        GUI:setVisible(Mail._ui["btnDel"], true)
    end

    GUI:setVisible(Mail._ui["mainPanel"], true)
end

-- 刷新左侧的邮件列表
function Mail.onUpdateMailList()
    local list = Mail._ui["mailList"]
    if GUI:Win_IsNull(list) then
        return false
    end

    Mail._mDatas = SL:GetMailList()

    -- 转成有序表并按index排序
    local mails = SL:HashToSortArray(Mail._mDatas, function (a, b) return a.index < b.index end)

    local nCount = #mails

    GUI:ListView_removeAllItems(list)
    Mail._cells = {}

    local index = 0
    for i=1, nCount do
        local mail = mails[i]
        local mailID = mail.Id
        local quickCell = GUI:QuickCell_Create(list, "Cell".. mailID, 0, 0, 220, 74, function(parent) return Mail.CreateMailItem(parent, mailID, mail) end)

        Mail._cells[mailID] = quickCell
        
        -- 默认选中第一个
        if i == 1 and Mail._selMailID == -1 then
            Mail._selMailID = mailID
        end
    end

    if nCount > 0 then
        Mail.RefreshMainPanel()
    else
        Mail.ShowDefaultMainPanel()
    end
end

function Mail.onDeleteMail(mailID)
    -- 删除的动画
    local item = Mail._cells[mailID]
    if item then
        local list = Mail._ui["mailList"]
        GUI:stopAllActions(list)
        GUI:setTouchEnabled(list, false)

        local function removeItem()
            local index = GUI:ListView_getItemIndex(list, item)
            GUI:ListView_removeItemByIndex(list, index)
            GUI:setTouchEnabled(list, true)
        end

        local x = GUI:getPositionX(item)
        local y = GUI:getPositionY(item)

        local itemW = GUI:getContentSize(item).width
        GUI:Timeline_EaseSineOut_MoveTo(item, {x = x - itemW, y = y}, 0.3, removeItem)
        Mail._cells[mailID] = nil
    end

    Mail._mDatas = SL:GetMailList()
    -- 转成有序表并按index排序
    local mails = SL:HashToSortArray(Mail._mDatas, function (a, b) return a.index < b.index end)
    if not mails or #mails < 1 then
        Mail.ShowDefaultMainPanel()
        return false
    end

    local selMailID = mails[1].Id
    Mail._selMailID = selMailID

    Mail.RefreshMainPanel()

    GUI:QuickCell_Exit(Mail._cells[selMailID])
    GUI:QuickCell_Refresh(Mail._cells[selMailID])
end

function Mail.RefreshCells()
    for i, cell in pairs(Mail._cells) do 
        GUI:QuickCell_Exit(cell)
        GUI:QuickCell_Refresh(cell)
    end 
end

function Mail.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_LIST_REFRESH, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_DELETE, "Mail")
end