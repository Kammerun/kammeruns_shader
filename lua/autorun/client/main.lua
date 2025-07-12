local mat = Material("kammeruns_shader/black_and_white.vmt")

local function drawShader()
    render.UpdateScreenEffectTexture()

    cam.Start2D()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    cam.End2D()
end

local show = CreateConVar("show_kammeruns_shader", "0")

hook.Add("RenderScreenspaceEffects", "GrayscaleEffect", function()
    if show:GetInt() < 1 then return end

    drawShader()
end)