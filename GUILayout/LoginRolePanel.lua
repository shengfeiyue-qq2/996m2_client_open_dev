LoginRolePanel = {}

LoginRolePanel.animLightID  = {4121, 4127, 4123, 4129, 4125, 4131}      -- 人物常亮动画id  顺序：男战士、女战士、男法师、女法师、男道士、女道士
LoginRolePanel.animGToLID   = {4122, 4128, 4124, 4130, 4126, 4132}      -- 人物灰到亮动画id   
LoginRolePanel.animPos      = {x=0, y=170}                              -- 人物特效位置    (基于 Node_anim_1/2)
LoginRolePanel.animScale    = {1, 1}                                    -- 左右动画缩放

function LoginRolePanel.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "login_role")

    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Panel_touch = ui["Panel_touch"]
    GUI:setContentSize(Panel_touch, screenW, screenH)

    local Panel_bg = ui["Panel_bg"]
    GUI:setPosition(Panel_bg, screenW/2, screenH/2)
    GUI:Layout_setBackGroundImage(Panel_bg, "res/private/login/bg_cjzy_02.jpg")
end

function LoginRolePanel.createRole( parent )
    GUI:LoadExport(parent, "login_role_create")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Panel_role = ui["Panel_role"]
    GUI:setPosition(Panel_role, screenW/2, screenH/2)
end

function LoginRolePanel.createRestore( parent )
    GUI:LoadExport(parent, "login_role_restore")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Layout_restore = ui["Layout_restore"]
    GUI:setPosition(Layout_restore, screenW/2, screenH/2)
end