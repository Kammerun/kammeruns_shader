local mats = { 
    Material("kammeruns_shader/black_and_white.vmt"),
    Material("kammeruns_shader/grey_spiral.vmt")
}

local function drawShader(material)
    material:SetFloat("$c0_x", CurTime())
    render.UpdateScreenEffectTexture()

    cam.Start2D()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    cam.End2D()
end

local show = CreateConVar("show_kammeruns_shader", "0")

hook.Add("RenderScreenspaceEffects", "GrayscaleEffect", function()
    if show:GetInt() < 1 then return end

    drawShader(mats[show:GetInt()])
end)