local BuffShaderBehavior = {}

BuffShaderBehavior.shaderOnFuncs = {
    [SLDefine.BUFFID.FREEZED_GRAY]  = function(data) return BuffShaderBehavior.ShaderFreeze(data) end,
    [SLDefine.BUFFID.ICE]           = function(data) return BuffShaderBehavior.ShaderIce(data) end,
    [SLDefine.BUFFID.STONE_MODE]    = function(data) return BuffShaderBehavior.ShaderStone(data) end,      
}

function BuffShaderBehavior.ShaderIce(node)
    if not node then
        return
    end

    local iceShader = SLDefine.SHADER_TYPE.SHADER_TYPE_ICE
    local blendType = GUI:Effect_getBlendMode(node)
    if blendType and blendType == 4 then
        iceShader = SLDefine.SHADER_TYPE.SHADER_TYPE_ICE_ALPHA_MULTIP
    elseif blendType and (blendType == 2 or blendType == 1) then
        iceShader = SLDefine.SHADER_TYPE.SHADER_TYPE_ICE_ALPHA_ENHANCE
    end

    ShaderUtils.SetTypeShader(node, iceShader)
end

function BuffShaderBehavior.ShaderFreeze(node)
    if not node then
        return
    end

    ShaderUtils.SetTypeShader(node, SLDefine.SHADER_TYPE.SHADER_TYPE_GRAY)
end

function BuffShaderBehavior.ShaderStone(node)
    if not node then
        return
    end
    
    ShaderUtils.SetTypeShader(node, SLDefine.SHADER_TYPE.SHADER_TYPE_GRAY)
end

function BuffShaderBehavior.ShaderNormal(node)
    if not node then
        return
    end

    ShaderUtils.SetTypeShader(node, SLDefine.SHADER_TYPE.SHADER_TYPE_NORMAL)
end

function BuffShaderBehavior.OnBuffPresent(data)
    if not data then
        return
    end

    local actorID = data.actorID
    local buffID = data.buffID
    local shaderNodeFunc = BuffShaderBehavior.shaderOnFuncs[buffID]
    if SL:GetValue("ACTOR_IS_VALID", actorID) and shaderNodeFunc then
        if buffID == SLDefine.BUFFID.STONE_MODE then
            if SL:GetValue("ACTOR_IS_MONSTER", actorID) then
                GUI:SetActorShaderFunc(actorID, shaderNodeFunc)
            end
        elseif buffID == SLDefine.BUFFID.ICE or buffID == SLDefine.BUFFID.FREEZED_GRAY then
            if SL:GetValue("ACTOR_IS_PLAYER", actorID) or SL:GetValue("ACTOR_IS_MONSTER", actorID) then
                GUI:SetActorShaderFunc(actorID, shaderNodeFunc)
            end
        end
    end
end

SL:RegisterLUAEvent(LUA_EVENT_ACTOR_ENTER_BUFF, "BuffShaderBehavior", BuffShaderBehavior.OnBuffPresent)
SL:RegisterLUAEvent(LUA_EVENT_ACTOR_UPDATE_BUFF_PRESENT, "BuffShaderBehavior", BuffShaderBehavior.OnBuffPresent)
SL:RegisterLUAEvent(LUA_EVENT_ACTOR_EXIT_BUFF, "BuffShaderBehavior", function(data)
    if not data then
        return
    end

    local actorID = data.actorID
    local buffID = data.buffID
    if buffID ~= SLDefine.BUFFID.FREEZED_GRAY and buffID ~= SLDefine.BUFFID.ICE and buffID ~= SLDefine.BUFFID.STONE_MODE then
        return
    end

    local shaderNodeFunc = BuffShaderBehavior.ShaderNormal
    if SL:GetValue("ACTOR_IS_VALID", actorID) and shaderNodeFunc then
        GUI:SetActorShaderFunc(actorID, shaderNodeFunc)
    end
end)


return BuffShaderBehavior