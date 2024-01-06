local HOMEDIR = homedir().canonical_path
local CONFIGDIR = HOMEDIR .. "/.config"

local DIROPTS = {
    user = vars.user,
    group = vars.group,
    recursive = true,
}

local function copy_file(src, dst) 
    local changed = file(src):copy(dst)
    if changed then
        file(dst):chown(DIROPTS)
    end
end

local function copy_dir(src, dst)
    dir(src):copy(dst):chown(DIROPTS)
end

Hyprland = task("Configure Hyprland and friends", function()
    local dirs = {
        "hypr",
        "waybar",
        "swaylock",
        "swaync"
    }
    for _, d in ipairs(dirs) do copy_dir(d, CONFIGDIR) end
end)

Kitty = task("Configure kitty", function ()
    copy_dir("kitty", CONFIGDIR)
end)

Btop = task("Configure Btop", function ()
    copy_dir("btop", CONFIGDIR)
end)

Zsh = task("Configure zsh, zshrc.d, and starship", function ()
    copy_file("zsh/zshrc", HOMEDIR .. "/.zshrc")
    dir("zsh/zshrc.d"):copy_contents(HOMEDIR .. "/.zshrc.d"):chown(DIROPTS)
    copy_file("zsh/starship.toml", CONFIGDIR .. "/starship.toml")
end)

Wayland_chrome_fixes = task("Add conf files for chromium/chrome/electron on wayland", function ()
    local flags = {
        "chrome-flags.conf",
        "code-flags.conf",
        "chromium-flags.conf",
        "electron24-flags.conf",
        "electron25-flags.conf"
    }
    for _, f in ipairs(flags) do copy_file("config/" .. f, CONFIGDIR) end
end)

Desktop_Environment = task("Full DE", {Hyprland, Kitty, Btop, Zsh, Wayland_chrome_fixes})