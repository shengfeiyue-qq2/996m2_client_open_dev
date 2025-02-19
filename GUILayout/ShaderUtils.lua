ShaderUtils = {}

local HighlightGLKey        = "ShaderHighlightColor_noMVP"
local HighlightCoverGLKey   = "ShaderHighlightCover_noMVP"
local HighlightGoldenGLKey  = "ShaderHighlightGoldenColor_noMVP"
local CloneShadowGLKey      = "ShaderCloneShadow_noMVP"
local SlowGLKey             = "ShaderSlowColor_noMVP"
local OutlineGLKey          = "ShaderOutlineColor_noMVP"
local IceGLKey              = "ShaderIceColor_noMVP"
local BlurGLKey             = "ShaderBlurGLKey_noMVP"
local IceAlphaMulitipGLKEY  = "ShaderIceAlphaMulitipColor_noMVP"

local NormalGLKEY           = "ShaderPositionTextureColor_noMVP"
local GrayGLKEY             = "ShaderUIGrayScale"

function ShaderUtils.SetTypeShader(node, type)
    if not node then
        return
    end

    local shader = nil
    
    if type == SLDefine.SHADER_TYPE.SHADER_TYPE_HIGHTLIGHT then
        shader = ShaderUtils.CreateHightLightShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_HIGHTLIGHT_COVER then
        shader = ShaderUtils.CreateHightLightCoverShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_GOLDEN then
        shader = ShaderUtils.CreateGoldenShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_SHADOW then
        shader = ShaderUtils.CreateShadowShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_SLOW then
        shader = ShaderUtils.CreateSlowShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_OUTLINE then
        shader = ShaderUtils.CreateOutlineShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_ICE then
        shader = ShaderUtils.CreateIceShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_BLUR then
        shader = ShaderUtils.CreateBlurShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_ICE_ALPHA_MULTIP then
        shader = ShaderUtils.CreateIceAlphaMulitipShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_GRAY then
        shader = ShaderUtils.CreateGrayShader()

    elseif type == SLDefine.SHADER_TYPE.SHADER_TYPE_NORMAL then
        shader = ShaderUtils.CreateNormalShader()

    else
        shader = ShaderUtils.CreateNormalShader()
    end

    if shader then
        GUI:SetShader(node, shader)
    end
end

function ShaderUtils.CreateNormalShader()
    return GUI:Shader_Create(NormalGLKEY)
end

function ShaderUtils.CreateGrayShader()
    return GUI:Shader_Create(GrayGLKEY)
end

function ShaderUtils.CreateHightLightShader()
    local shader = GUI:Shader_Create(HighlightGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateHightLightCoverShader()
    local shader = GUI:Shader_Create(HighlightCoverGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_cover_nomvp.frag")
    return shader
end

function ShaderUtils.CreateGoldenShader()
    local shader = GUI:Shader_Create(HighlightGoldenGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_golden_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateShadowShader()
    local shader = GUI:Shader_Create(CloneShadowGLKey, "shader/position_texture_color_nomvp.vert", "shader/shadow_blur.fsh")
    return shader
end

function ShaderUtils.CreateSlowShader()
    local shader = GUI:Shader_Create(SlowGLKey, "shader/position_texture_color_nomvp.vert", "shader/slow_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateOutlineShader()
    local shader = GUI:Shader_Create(OutlineGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_outline_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateIceShader()
    local shader = GUI:Shader_Create(IceGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_ice_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateBlurShader()
    local shader = GUI:Shader_Create(BlurGLKey, "shader/position_texture_color_nomvp.vert", "shader/highlight_blur_color_nomvp.frag")
    return shader
end

function ShaderUtils.CreateIceAlphaMulitipShader()
    local shader = GUI:Shader_Create(IceAlphaMulitipGLKEY, "shader/position_texture_color_nomvp.vert", "shader/highlight_ice_alpha_mulitip_color_nomvp.frag")
    return shader
end

return ShaderUtils