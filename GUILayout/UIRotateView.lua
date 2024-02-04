-- 旋转控件接口
-- scrollGap = 100 (滑动间隙 超过100 执行旋转)
-- scale：缩放大小，img：图片路径，node：自定义节点 (img和node不能同时存在)
-- x 横坐标(默认不填 根据容器大小排列)
-- y 纵坐标(默认不填 根据容器大小排列)
-- local param = {
--     [1] = {scale = 0.4, x = nil, y = nil, img = "res/public/word_fubentg_1.png", node = nil},
--     [2] = {scale = 0.6, x = nil, y = nil, img = "res/public/word_fubentg_2.png", node = nil},
--     [3] = {scale = 0.8, x = nil, y = nil, img = "res/public/word_fubentg_3.png", node = nil},
--     [4] = {scale = 1.0, x = nil, y = nil, img = "res/public/word_fubentg_4.png", node = nil},
--     [5] = {scale = 0.8, x = nil, y = nil, img = "res/public/word_fubentg_5.png", node = nil},
--     [6] = {scale = 0.6, x = nil, y = nil, img = "res/public/word_fubentg_6.png", node = nil},
--     [7] = {scale = 0.4, x = nil, y = nil, img = "res/public/word_fubentg_7.png", node = nil},
-- }

UIRotateView = {}

function UIRotateView.main(parent, ID, x, y, width, height, scrollGap, param)
    -- view
    local rotateView = GUI:Layout_Create(parent, ID, x, y, width, height, true)
    GUI:setAnchorPoint(rotateView, 0.5, 0.5)
    GUI:setTouchEnabled(rotateView, true)

    local items = {}
    local itemCount = #param or 3
    local bgSize = rotateView:getContentSize()
    local itemSizeW = math.floor(bgSize.width / itemCount)
    local itemSizeH = bgSize.height

    for i = 1, itemCount do 
        -- x y
        local posX = param[i].x or (i - 1) * itemSizeW + itemSizeW / 2
        local posY = param[i].y or bgSize.height / 2
        param[i].x = posX
        param[i].y = posY
        
        -- item
        local item = GUI:Layout_Create(rotateView, "item"..i, posX, posY, itemSizeW, itemSizeH, true)
        GUI:setAnchorPoint(item, 0.5, 0.5)

        -- color
        local color = param[i].color
        if color then 
            GUI:Layout_setBackGroundColor(item, SL:ConvertColorFromHexString(color))
            GUI:Layout_setBackGroundColorType(item, 1)
            GUI:Layout_setBackGroundColorOpacity(item, 76)
        end 

        -- img
        local imgPath = param[i].img 
        if imgPath then 
            local itemSize = GUI:getContentSize(item)
            local img = GUI:Image_Create(item, "img"..i, itemSize.width / 2, itemSize.height / 2, imgPath)
            GUI:setAnchorPoint(img, 0.5, 0.5)
        end 

        -- node
        local node = param[i].node 
        if node then 
            local itemSize = GUI:getContentSize(item)
            GUI:setPosition(node, itemSize.width / 2, itemSize.height / 2)
            GUI:setAnchorPoint(node, 0.5, 0.5)
            GUI:addChild(item, node)
            GUI:setSwallowTouches(node, false)
        end 

        -- scale
        local scale = param[i].scale or 1
        GUI:setScale(item, scale)

        items[i] = item
    end 

    local direct = 1 -- 1右滑 0左滑
    local scrollGap = scrollGap or 100 -- 滑动阈值
    local complete = false -- 完整滑动
    local bZOder = false

    local function scrollAction(direct, offsetMove)
        for idx = 1, itemCount do 
            local curConfig = nil 
            local nextConfig = nil
            
            -- 当前 和 下一个 配置
            local nextIdx = nil
            if direct == 1 then 
                nextIdx = idx + 1
                if nextIdx > itemCount then 
                    nextIdx = 1
                end
            else
                nextIdx = idx - 1
                if nextIdx == 0 then 
                    nextIdx = itemCount
                end 
            end 
            curConfig = param[idx]
            nextConfig = param[nextIdx]
            
            local distanceGap = nextConfig.x - curConfig.x
            local realMove =  (distanceGap / scrollGap) * offsetMove -- 真实移动距离
            GUI:setPosition(items[idx], curConfig.x + realMove, curConfig.y)

            local scaleGap = nextConfig.scale - curConfig.scale 
            local realScale = scaleGap * math.abs(realMove) / math.abs(distanceGap) -- 真实缩放大小
            items[idx]:setScale(curConfig.scale + realScale)

            if not bZOder then 
                if direct == 1 then 
                    GUI:setLocalZOrder(items[itemCount], -1)      
                else
                    GUI:setLocalZOrder(items[1], -1)    
                end 
                
                bZOder = true
            end 

            if offsetMove >= scrollGap then 
                GUI:setPosition(items[idx], nextConfig.x, nextConfig.y)
                items[idx]:setScale(nextConfig.scale)
                GUI:setLocalZOrder(items[idx], idx)  
                if idx == itemCount then 
                    complete = true  
                end 
            end 
        end 
    end 

    local function ScrollEventCallBack(sender, iType)
        if iType == 0 then

        elseif iType == 1 then
            local startPos = GUI:getTouchBeganPosition(sender)
            local movePos = GUI:getTouchMovePosition(sender)
            local offsetMove = movePos.x - startPos.x -- 滑动距离
            if offsetMove < 0 then 
                direct = 0
            else 
                direct = 1
            end 

            if not complete then 
                scrollAction(direct, math.abs(offsetMove))
            end 
        else  
            if complete then 
                -- 完整滑动 重置items序列
                local newItems = {}    
                if direct == 1 then         
                    for idx = 1, itemCount do 
                        local nextIdx = idx - 1
                        if nextIdx == 0 then 
                            nextIdx = itemCount
                        end 

                        newItems[idx] = items[nextIdx]  
                    end 
                    items = {}
                    items = newItems
                else 
                    for idx = 1, itemCount do 
                        local nextIdx = idx + 1
                        if nextIdx > itemCount then 
                            nextIdx = 1
                        end 

                        newItems[idx] = items[nextIdx]
                    end 
                    items = {}
                    items = newItems
                end 
            else 
                -- 未完成完整滑动 恢复
                for i = 1, itemCount do
                    local curConfig = param[i]
                    GUI:setPosition(items[i], curConfig.x, curConfig.y)
                    items[i]:setScale(curConfig.scale) 
                    GUI:setLocalZOrder(items[i], i)  
                end  
            end 
            complete = false
            bZOder = false
        end
    end 

    GUI:addOnTouchEvent(rotateView, ScrollEventCallBack)

    return rotateView
end 

function UIRotateView.addRotateViewChild(parent, child, index)
    local item = GUI:getChildByName(parent, "item"..index)
    if not item then 
        SL:Print("[UIRotateView ERROR] item is nil")
    end 
    local itemSize = GUI:getContentSize(item)
    GUI:setPosition(child, itemSize.width / 2, itemSize.height / 2)
    GUI:setAnchorPoint(child, 0.5, 0.5)
    GUI:setSwallowTouches(child, false) 
    GUI:setName(child, "child"..index)
    GUI:addChild(item, child)
end 

function UIRotateView.getRotateViewChildByIndex(parent, index)
    local item = GUI:getChildByName(parent, "item"..index)
    if not item then 
        SL:Print("[UIRotateView ERROR] item is nil")
    end 

    local child = GUI:getChildByName(item, "child"..index)
    if not child then 
        SL:Print("[UIRotateView ERROR] child is nil")
    end 

    return child
end 