UIModel = {}

-- 默认内观缩放比例
UIModel.PLAYER_LOOKS_SCALE          = 1.44
-- 默认女性模型X轴偏移
UIModel.PLAYER_OFFSET_X_FEMALE      = 2

UIModel._zOrder = {
    --内观层级
	MODEL_LAYER_Z_BASE                = 1,  -- 裸模
	MODEL_LAYER_Z_CLOTH_EFFECT_UNDER  = 2,  -- 衣服特效底层
	MODEL_LAYER_Z_CLOTH               = 3,  -- 衣服
	MODEL_LAYER_Z_CLOTH_EFFECT_ON     = 4,  -- 衣服特效上层
	MODEL_LAYER_Z_WEAPON_EFFECT_UNDER = 5,  -- 武器特效底层
	MODEL_LAYER_Z_WEAPON              = 6,  -- 武器
	MODEL_LAYER_Z_WEAPON_EFFECT_ON    = 7,  -- 武器特效上层
	MODEL_LAYER_Z_HAIR                = 8,  -- 头发
	MODEL_LAYER_Z_VEIL_EFFECT_UNDER   = 9,  -- 面纱下层
	MODEL_LAYER_Z_VEIL                = 10, -- 面纱
	MODEL_LAYER_Z_VEIL_EFFECT_ON      = 11, -- 面纱上层
	MODEL_LAYER_Z_HEAD_EFFECT_UNDER   = 12, -- 头盔下层
	MODEL_LAYER_Z_HEAD                = 13, -- 头盔
	MODEL_LAYER_Z_HEAD_EFFECT_ON      = 14, -- 头盔上
	MODEL_LAYER_Z_SHIELD_EFFECT_UNDER = 15, -- 盾牌特效下层
	MODEL_LAYER_Z_SHIELD              = 16, -- 盾牌
	MODEL_LAYER_Z_SHIELD_EFFECT_ON    = 17, -- 盾牌特效上层
}

-- 解析特效配置
local function ParseModelEffect(effect)
    local effectSet = {}
    if not effect then
        return effectSet
    end
    if type(effect) == "number" then
        effect = effect .. "#0"
    end

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    
    local effectArry = string.split(effect or "", "&")
    local isShowLook = tonumber(effectArry[2]) ~= 0
    local effectList = string.split(effectArry[1] or "", "|")
    for i = 1, #effectList do
        local effectParam = effectList[i]
        local effectParamPar = string.split(effectParam or "", "#")
        local effectData = {
            effectId = effectParamPar[1] and tonumber(effectParamPar[1]) or 0,
            zOrder = effectParamPar[2] and tonumber(effectParamPar[2]) or 0,
            offX = effectParamPar[3] and tonumber(effectParamPar[3]) or 0,
            offY = effectParamPar[4] and tonumber(effectParamPar[4]) or 0,
            scale = effectParamPar[6] and tonumber(effectParamPar[6]) or 1 --"PC缩放#手机缩放"
        }
        if isWinMode then
            effectData.scale = effectParamPar[5] and tonumber(effectParamPar[5]) or 1
            effectData.offX = effectParamPar[7] and tonumber(effectParamPar[7]) or effectData.offX
            effectData.offY = effectParamPar[8] and tonumber(effectParamPar[8]) or effectData.offY
        end
        table.insert(effectSet, effectData)
    end
    return effectSet, isShowLook
end

function UIModel.main(sex, feature, scale, params)
    local parent = GUI:Attach_LeftBottom()
    if not parent then
        return
    end
   
    local newScale = SL:GetMetaValue("GAME_DATA", "staticSacle")
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    params = params or {}
    if not params.ignoreStaticScale then
        if newScale and newScale ~= "" then
            local scaleSplit = string.split(newScale, "|")
            if isWinMode and scaleSplit[2] then
                scale = tonumber(scaleSplit[2])
            else
                if scaleSplit[1] then
                    scale = tonumber(scaleSplit[1])
                end
            end
        end
    end

    local baseNode = GUI:Node_Create(parent, "baseNode", 0, 0)
    GUI:removeFromParent(baseNode)

    local equipOff = {
        x = -136,
        y = 110
    }

    local baseUIOff = {
        x = -9,
        y = 3
    }

    local modelScale = scale or 1
    local baseModel = GUI:Node_Create(baseNode, "baseModel", baseUIOff.x, baseUIOff.y)

    --法阵
    if feature.embattlesID and next(feature.embattlesID) then
        local sfxX, sfxY = -30, -80
        if global.isWinPlayMode then
            sfxX = -30
            sfxY = -40
        end
        for k, id in pairs(feature.embattlesID) do
            local embattleEffectAnim = GUI:Effect_Create(baseNode, "embattles_" .. k, sfxX, sfxY, 0, id, 0, 0, 0, 1)
            if embattleEffectAnim then 
                GUI:setScale(embattleEffectAnim, global.isWinPlayMode and modelScale or (modelScale * 1.3) )
                GUI:setLocalZOrder(embattleEffectAnim,  k == 1 and -10 or 10)
            end
        end
    end

    -- 内观缩放比例
    local showModelScale = UIModel.PLAYER_LOOKS_SCALE
    if isWinMode then
        showModelScale = 1

        equipOff = {
            x = -97.5,
            y = 77
        }
    end
    
    GUI:setScale(baseModel, showModelScale)

    -- 展示节点
    local node = GUI:Node_Create(baseNode, "node", equipOff.x, equipOff.y)
    GUI:setScale(node, showModelScale)

    GUI:setScale(baseNode, modelScale)

    -- 裸模
    local job       = params.job
    local jobData   = job and SL:GetMetaValue("GAME_DATA", "MultipleJobSetMap")[job]
    local isOpen    = jobData and jobData.isOpen
    local imgName   = isOpen and (sex == 1 and jobData.UIModelPicFeMaleID or jobData.UIModelPicMaleID)
    local offx      = sex == 1 and UIModel.PLAYER_OFFSET_X_FEMALE or 0
    if not imgName then
        imgName = string.format("%08d", sex == 1 and 470 or 460)
    end
    local base = GUI:Image_Create(baseModel, "baseImg", offx, 0, "res/private/player_model/".. imgName .. ".png")
    GUI:setAnchorPoint(base, 0.5, 0.5)
    GUI:setVisible(base, not (feature and feature.notShowMold))

    if not feature or not next(feature) then
        return baseNode
    end

    local clothId = feature.clothID
    local weaponId = feature.weaponID
    local headId = feature.headID
    local headEffect = feature.headEffectID
    local weaponEffect = feature.weaponEffectID
    local clothEffect = feature.clothEffectID
    local capId = feature.capID
    local shieldID = feature.shieldID
    local shieldEffect = feature.shieldEffectID
    local tDressId = feature.tDressID
    local tDressEffect = feature.tDressEffectID
    local tWeaponId = feature.tWeaponID
    local tWeaponEffect = feature.tWeaponEffectID
    local capEffect = feature.capEffectID
    local veilId = feature.veilID
    local veilEffect = feature.veilEffectID

    local showHelmet = params.showHelmet

    local function getFileName(looks)
        local fileIndex = looks % 10000
        local fileName = string.format("%06d", fileIndex)
        return fileName, math.floor(looks / 10000)
    end

    local equipOffset = SL:GetMetaValue("UIMODEL_EQUIP_OFFSET")

    --readme:这里所有的纵坐标值取反 坐标系转换
    local showCloth = tDressId and tDressId or clothId
    local showClothEffect = tDressEffect and tDressEffect or clothEffect
    if showCloth then
        local clothFileName, pathIndex = getFileName(showCloth)
        local clothOffset = equipOffset[showCloth] or {x = 0, y = 0}
        if clothOffset and clothFileName then
            local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, clothFileName)
            local cloth = GUI:Image_Create(node, "clothIMG", clothOffset.x, -clothOffset.y, path)
            GUI:setAnchorPoint(cloth, 0, 1)
            GUI:setLocalZOrder(cloth, UIModel._zOrder.MODEL_LAYER_Z_CLOTH)
        end

        if showClothEffect and showClothEffect ~= "0" and showClothEffect ~= "" then
            local effectList = ParseModelEffect(showClothEffect)
            for i, v in ipairs(effectList) do
                -- 衣服特效
                local clothEffectAnim = GUI:Effect_Create(node, "clothAnim_" .. i, v.offX, - v.offY, 0, v.effectId)
                if clothEffectAnim then
                    local effScale = v.scale or 1
                    effScale = GUI:getScale(clothEffectAnim) * effScale
                    GUI:setScale(clothEffectAnim, effScale)
                    GUI:setLocalZOrder(clothEffectAnim, v.zOrder == 0 and UIModel._zOrder.MODEL_LAYER_Z_CLOTH_EFFECT_ON or UIModel._zOrder.MODEL_LAYER_Z_CLOTH_EFFECT_UNDER)
                end
            end
        end
    end

    local hairNode = nil
    if sex then
        local hairID = sex == 1 and 0 or 0
        hairID = feature and feature.hairID or hairID

        if feature.hairID then
            if hairID == 1 then
                hairID = sex == 1 and 2 or 1
            elseif hairID == 2 then
                hairID = sex == 1 and 3 or 0
            elseif hairID == 3 then
                hairID = sex == 1 and 4 or 0
            else
                local value = sex == 1 and 2 or 1
                hairID = 10000 + hairID * 10 + value
            end
        end

        local hairSetId = hairID
        local hairFileName = nil
        if hairID > 0 then
            hairFileName = string.format("%08d", hairID)
        end

        if not feature.notShowHair and hairFileName then
            local hairFilePath = "res/private/player_model/" .. hairFileName .. ".png"
            if SL:IsFileExist(hairFilePath) then
                local hairOffset = SL:GetMetaValue("UIMODEL_HAIR_OFFSET")
                local x = hairOffset[hairSetId] and hairOffset[hairSetId].x or 0
                local y = hairOffset[hairSetId] and - hairOffset[hairSetId].y or 0
                local hair = GUI:Image_Create(node, "hairIMG", x, y, hairFilePath)
                GUI:setAnchorPoint(hair, 0, 1)
                GUI:setLocalZOrder(hair, UIModel._zOrder.MODEL_LAYER_Z_HAIR)
            end
        end
    end

    local showWeapon = tWeaponId and tWeaponId or weaponId
    local showWeaponEffect = tWeaponEffect and tWeaponEffect or weaponEffect
    if showWeapon then
        local weaponFileName, pathIndex = getFileName(showWeapon)
        local weaponOffset = equipOffset[showWeapon] or {x = 0, y = 0}
        if weaponOffset and weaponFileName then
            local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, weaponFileName)
            local weapon = GUI:Image_Create(node, "weaponIMG", weaponOffset.x, - weaponOffset.y, path)
            GUI:setAnchorPoint(weapon, 0, 1)
            GUI:setLocalZOrder(weapon, UIModel._zOrder.MODEL_LAYER_Z_WEAPON)
        end

        if showWeaponEffect and showWeaponEffect ~= "0" and showWeaponEffect ~= "" then
            local effectList = ParseModelEffect(showWeaponEffect)
            for i, v in ipairs(effectList) do
                -- 武器特效
                local weaponEffectAnim = GUI:Effect_Create(node, "weaponAnim_" .. i, v.offX, - v.offY, 0, v.effectId)
                if weaponEffectAnim then
                    local effScale = v.scale or 1
                    effScale = GUI:getScale(weaponEffectAnim) * effScale
                    GUI:setScale(weaponEffectAnim, effScale)
                    GUI:setLocalZOrder(weaponEffectAnim, v.zOrder == 0 and UIModel._zOrder.MODEL_LAYER_Z_WEAPON_EFFECT_ON or UIModel._zOrder.MODEL_LAYER_Z_WEAPON_EFFECT_UNDER)
                end
            end
        end
    end

    if veilId then
        local veilFileName, pathIndex = getFileName(veilId)
        local veilOffset = equipOffset[veilId] or {x = 0, y = 0}
        if veilOffset and veilFileName then
            local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, veilFileName)
            local veil = GUI:Image_Create(node, "veilIMG", veilOffset.x, - veilOffset.y, path)
            GUI:setAnchorPoint(veil, 0, 1)
            GUI:setLocalZOrder(veil, UIModel._zOrder.MODEL_LAYER_Z_VEIL)
        end

        if veilEffect and veilEffect ~= "0" and veilEffect ~= "" then
            local effectList = ParseModelEffect(veilEffect)
            for i, v in ipairs(effectList) do
                local veilEffectAnim = GUI:Effect_Create(node, "veilAnim_" .. i, v.offX, - v.offY, 0, v.effectId)
                if veilEffectAnim then
                    local effScale = v.scale or 1
                    effScale = GUI:getScale(veilEffectAnim) * effScale
                    GUI:setScale(veilEffectAnim, effScale)
                    GUI:setLocalZOrder(veilEffectAnim, v.zOrder == 0 and UIModel._zOrder.MODEL_LAYER_Z_VEIL_EFFECT_ON or UIModel._zOrder.MODEL_LAYER_Z_VEIL_EFFECT_UNDER)
                end
            end
        end
    end

    local topLooks = {
        [1] = capId
    }

    local topEffects = {
        [1] = capEffect
    }

    if not topLooks[1] or showHelmet then
        topLooks[2] = headId
    end

    if not topEffects[1] or showHelmet then
        topEffects[2] = headEffect
    end

    for i = 2, 1, -1 do
        local topLookId = topLooks[i]
        local showTopEffect = topEffects[i]
        if topLookId then
            local headFileName, pathIndex = getFileName(topLookId)
            local headOffset = equipOffset[topLookId] or {x = 0, y = 0}
            if headOffset and headFileName then
                local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, headFileName)
                local head = GUI:Image_Create(node, "headIMG_" .. i, headOffset.x, - headOffset.y, path)
                GUI:setAnchorPoint(head, 0, 1)
                GUI:setLocalZOrder(head, UIModel._zOrder.MODEL_LAYER_Z_HEAD)
            end

            if showTopEffect and showTopEffect ~= "0" and showTopEffect ~= "" then
                local effectList = ParseModelEffect(showTopEffect)
                for i, v in ipairs(effectList) do
                    -- 头盔特效
                    local headEffectAnim = GUI:Effect_Create(node, "headAnim_" .. i, v.offX, - v.offY, 0, v.effectId)
                    if headEffectAnim then
                        local effScale = v.scale or 1
                        effScale = GUI:getScale(headEffectAnim) * effScale
                        GUI:setScale(headEffectAnim, effScale)
                        GUI:setLocalZOrder(headEffectAnim, v.zOrder == 0 and UIModel._zOrder.MODEL_LAYER_Z_HEAD_EFFECT_ON or UIModel._zOrder.MODEL_LAYER_Z_HEAD_EFFECT_UNDER)
                    end
                end
            end
        end
    end

    -- 盾牌
    if shieldID then
        local shieldFileName, pathIndex = getFileName(shieldID)
        local shieldOffset = equipOffset[shieldID] or {x = 0, y = 0}
        if shieldOffset and shieldFileName then
            local path = string.format("res/player_show/player_show_%s/%s.png", pathIndex, shieldFileName)
            local shield = GUI:Image_Create(node, "shieldIMG", shieldOffset.x, - shieldOffset.y, path)
            GUI:setAnchorPoint(shield, 0, 1)
            GUI:setLocalZOrder(shield, UIModel._zOrder.MODEL_LAYER_Z_SHIELD)
        end

        if shieldEffect and shieldEffect ~= "0" and shieldEffect ~= "" then
            local effectList = ParseModelEffect(shieldEffect)
            for i,v in ipairs(effectList) do
                -- 盾牌特效
                local shieldEffectAnim = GUI:Effect_Create(node, "shieldAnim_" .. i, v.offX, - v.offY, 0, v.effectId)
                if shieldEffectAnim then
                    local effScale = v.scale or 1
                    effScale = GUI:getScale(shieldEffectAnim) * effScale
                    GUI:setScale(shieldEffectAnim, effScale)
                    GUI:setLocalZOrder(shieldEffectAnim, v.zOrder == 0 and UIModel._zOrder.MODEL_LAYER_Z_SHIELD_EFFECT_ON or UIModel._zOrder.MODEL_LAYER_Z_SHIELD_EFFECT_UNDER)
                end
            end
        end
    end

    return baseNode
end

