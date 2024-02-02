Storage = {}

function Storage.Init(isWin32)
    Storage.lockImg         = "res/public/icon_tyzys_01.png"
    Storage._PWidth         = isWin32 and 336 or 508     -- 容器可见区域 宽
    Storage._PHeight        = isWin32 and 254.4 or 384     -- 容器可见区域 高
    Storage._PerPageNum     = 48
    Storage._PerRowItemNum  = 8
    Storage._PerColItemNum  = 6
    Storage._MaxPage        = 5
    Storage._selPage        = 0     -- 当前选中的页签
    Storage._pageBtns       = {}
    Storage._defaultNum     = 48    -- 官方默认仓库格子数量
end

function Storage.ResetStorageData()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local storage_row_col = SL:GetMetaValue("GAME_DATA", "bag_storage_row_col_max")

    if isWinMode and storage_row_col then
        local slices = string.split(storage_row_col, "|")
        Storage._PerRowItemNum = tonumber(slices[1]) or 8
        Storage._PerColItemNum = tonumber(slices[2]) or 6
        Storage._PerPageNum = Storage._PerRowItemNum * Storage._PerColItemNum

        -- 隐藏页签
        if Storage._PerPageNum > Storage._defaultNum then
            for i = 1, Storage._MaxPage do
                local pageBtn = Storage._ui["Button_page" .. i]
                GUI:setVisible(pageBtn, false)
            end
        end
    end

    local pSize = GUI:getContentSize(Storage._ui["Panel_items"])
    Storage._PWidth = pSize.width
    Storage._PHeight = pSize.height
end

function Storage.main(page)
    local parent = GUI:Attach_Parent()
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWin32 and "bag/storage_layer_win32" or "bag/storage_layer")

    Storage._ui = GUI:ui_delegate(parent)

    -- 初始化数据
    Storage.Init(isWin32)

    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local pSizeH = GUI:getContentSize(Storage._ui["Panel_1"]).height
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:setPositionY(Storage._ui["Panel_1"], screenH - pSizeH / 2 - 70)
    else
        GUI:setPositionY(Storage._ui["Panel_1"], screenH / 2 + 20)
    end

    -- 界面拖动
    GUI:Win_SetDrag(parent, Storage._ui["Panel_1"])

    -- 初始化右侧页签
    Storage.InitPage()

    Storage.PageTo(page or 1)
end

function Storage.InitPage()
    local openNum = SL:GetMetaValue("GAME_DATA", "warehouse_max_num") or 240
    SL:Print("仓库最大格子数量：", openNum)

    -- 当前最大显示几页
    Storage._openPage = math.ceil(openNum / Storage._PerPageNum)
    Storage._openPage = math.max(Storage._openPage, 1)
    Storage._openPage = math.min(Storage._openPage, Storage._MaxPage)

    for i = 1, Storage._MaxPage do
        local pageBtn = Storage._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if Storage._openPage ~= 1 and i <= Storage._openPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            Storage._pageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                Storage.PageTo(i)
                if Storage.UpdateItems then
                    Storage.UpdateItems()
                end
            end)
        end
    end
end

function Storage.PageTo(page)
    if Storage._selPage == page then
        return false
    end

    SL:SetMetaValue("STORGE_PAGE_CUR", page)
    Storage._selPage = page
    Storage.SetPageBtnStatus()
end

function Storage.SetPageBtnStatus()
    for i = 1, Storage._openPage do
        local btnPage = Storage._pageBtns[i]
        if btnPage then
            local isPress = i == Storage._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and Storage._openPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end