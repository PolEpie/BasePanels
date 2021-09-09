
ImgLoader = {}
ImgLoader.Images = {}
file.CreateDir("darkrizen")
file.CreateDir("darkrizen/images")
function DownloadImage(name, cb)
    if ImgLoader.Images[name] then
        cb(ImgLoader.Images[name])
        return
    end
    local isDownloaded = file.Read("darkrizen/images/" .. name)
    if (isDownloaded) then
        ImgLoader.Images[name] = "../data/darkrizen/images/" .. name
        if cb then
            cb(ImgLoader.Images[name])
            return
        end
    else
        local url = "https://shop.foc-community.fr/poudlard/" .. name

        http.Fetch(url, function(image)
            if image then
                local path = "darkrizen/images/" .. name
                pathT = string.Explode("/", path)
                local dirPath = table.concat(pathT, "/", 1, #pathT - 1)
                file.CreateDir(dirPath)
                file.Write("darkrizen/images/" .. name, image)
                ImgLoader.Images[name] = "../data/" .. path
                if cb then
                    cb(ImgLoader.Images[name])
                end
            end
        end,
                function(failed)
                    ErrorNoHalt(failed)
                    cb(false)
                    return false
                end)
    end
end

local PANEL = {}
function PANEL:Init()
    self:ImageInit()
end
function PANEL:ImageInit()
    self.OldSetImage = self.SetImage
    function self:SetImage(img)
        DownloadImage(img, function(imgLocal)
            if not imgLocal then return end
            if IsValid(self) and self.OldSetImage then
                self:OldSetImage(imgLocal)
            end
        end)
    end
end
vgui.Register("DHttpImage", PANEL, "DImage")


PANEL = {}
function PANEL:Init()
    self:ImageInit()
end
function PANEL:ImageInit()
    self.OldSetImage = self.SetImage
    function self:SetImage(img)
        DownloadImage(img, function(img)
            if IsValid(self) and self.OldSetImage then
                self:OldSetImage(img)
            end
        end)
    end
end
vgui.Register("DHttpImageButton", PANEL, "DImageButton")

function ImgLoader.LoadMaterial(name, cb)
    DownloadImage(name, function(dt)
        if dt and Material(dt) then
            cb(Material(dt))
        else
            print("Error loading "..name)
            cb(false)
        end
    end)
end


PANEL = {}
function PANEL:Init()
end
function PANEL:SetImage(img, sizeX, sizeY, offX, offY)
    offX = offX or 0
    offY = offY or 0
    self.ImageSizeX = sizeX
    self.ImageSizeY = sizeY
    self.ImageOffX = offX
    self.ImageOffY = offY
    DownloadImage(img, function(img)
        if IsValid(self) then
            self.Image = img
            self.ImageMat = Material(self.Image)
        end
    end)
end
function PANEL:Paint(w, h)
    if not self.ImageMat then self:PostPaint(w, h) return end
    surface.SetDrawColor(Color(255, 255, 255))
    surface.SetMaterial(self.ImageMat)
    surface.DrawTexturedRect(self.ImageOffX, self.ImageOffY, self.ImageSizeX, self.ImageSizeY)
    self:PostPaint(w, h)
end
function PANEL:PostPaint(w, h)

end
vgui.Register("HttpImageButton", PANEL, "DButton")


PANEL = {}
function PANEL:Init()
end
function PANEL:SetImage(img, sizeX, sizeY, offX, offY, hover)
    offX = offX or 0
    offY = offY or 0
    if hover then
        self.ImageSizeXHover = sizeX
        self.ImageSizeYHover = sizeY
        self.ImageOffXHover = offX
        self.ImageOffYHover = offY

        DownloadImage(img, function(img)
            if IsValid(self) then
                self.ImageHover = img
                self.ImageHoverMat = Material(self.ImageHover)
            end
        end)
    else
        self.ImageSizeX = sizeX
        self.ImageSizeY = sizeY
        self.ImageOffX = offX
        self.ImageOffY = offY

        DownloadImage(img, function(img)
            if IsValid(self) then
                self.Image = img
                self.ImageMat = Material(self.Image)
            end
        end)
    end
end
function PANEL:Paint(w, h)
    if not self.ImageMat then self:PostPaint(w, h) return end
    if not self.ImageHoverMat then self:PostPaint(w, h) return end
    surface.SetDrawColor(Color(255, 255, 255))
    if self:IsHovered() then
        surface.SetMaterial(self.ImageHoverMat)
        surface.DrawTexturedRect(self.ImageOffXHover, self.ImageOffYHover, self.ImageSizeXHover, self.ImageSizeYHover)
    else
        surface.SetMaterial(self.ImageMat)
        surface.DrawTexturedRect(self.ImageOffX, self.ImageOffY, self.ImageSizeX, self.ImageSizeY)
    end

    self:PostPaint(w, h)
end
function PANEL:PostPaint(w, h)

end
vgui.Register("DHttpImageButtonHover", PANEL, "DButton")


PANEL = {}
function PANEL:Init()
    self:ShowCloseButton(false)
    timer.Simple(0, function()
        Quiditch.ClosePanel(self)
    end)

end


function PANEL:SetImage(img, sizeX, sizeY, offX, offY)
    offX = offX or 0
    offY = offY or 0
    self.ImageSizeX = sizeX
    self.ImageSizeY = sizeY
    self.ImageOffX = offX
    self.ImageOffY = offY
    DownloadImage(img, function(img)
        if IsValid(self) then
            self.Image = img
            self.ImageMat = Material(self.Image)
        end
    end)
end

function PANEL:Paint(w, h)
    if not self.ImageMat then self:PostPaint(w, h) return end
    surface.SetDrawColor(Color(255, 255, 255))
    surface.SetMaterial(self.ImageMat)
    surface.DrawTexturedRect(self.ImageOffX, self.ImageOffY, self.ImageSizeX, self.ImageSizeY)
    self:PostPaint(w, h)
end

function PANEL:PostPaint(w, h)

end
vgui.Register("DHttpImageFrame", PANEL, "DFrame")

Quiditch.RespH = {}

function RespH(val)

    if Quiditch.RespH[val] then
        return Quiditch.RespH[val]
    end

    Quiditch.RespH[val] = val * ScrH() / 1080
    return Quiditch.RespH[val]

end

function Quiditch.ClosePanel(frame)

    local width = frame:GetWide()
    
    local CloseBtn = vgui.Create("HttpImageButton", frame)
    CloseBtn:SetSize(RespH(19), RespH(19))
    CloseBtn:SetPos(width - RespH(39), RespH(20))
    CloseBtn:SetImage("icon_x.png", RespH(19), RespH(19),0,0)
    CloseBtn:SetText("")

    function CloseBtn:DoClick()
        frame:Close()
    end
    
end 