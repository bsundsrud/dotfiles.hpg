vars.user = user().name
vars.group = user().gid
local HOMEDIR = homedir(vars.user).canonical_path
local CONFIGDIR = HOMEDIR .. "/.config"

local DIROPTS = {
    user = vars.user,
    group = vars.group,
    recursive = true,
}

-- We need yay installed first, we're installing somethings from AUR
pkg.arch.package_manager = "yay"

local function system_type()
    local release = file("/etc/lsb-release"):contents()
    local s = release:find('DISTRIB_ID="ManjaroLinux"', 1, true)
    if s then
        return "arch"
    end
    s = release:find('DISTRIB_ID="Arch"', 1, true)
    if s then
        return "arch"
    end
    s = release:find('DISTRIB_ID="Ubuntu"', 1, true)
    if s then
        return "debian"
    end
end

local function copy_file(src, dst)
    local changed = file(src):copy(dst)
    if changed then
        file(dst):chown(DIROPTS)
    end
end

local function copy_dir(src, dst)
    dir(src):copy(dst):chown(DIROPTS)
end

local hyprland_packages = task("hyprland packages", { Btop, Kitty }, function()
    if system_type() == "arch" then
        pkg.arch.ensure({
            "swayidle",
            "swaylock-effects",
            "swww",
            "swaync",
            "wlogout",
            "wofi",
            "wl-clipboard",
            "waybar",
            "ttf-jetbrains-mono",
            "ttf-jetbrains-mono-nerd",
            "otf-font-awesome",
            "qt5ct",
            "pavucontrol",
            "pamixer",
            "network-manager-applet",
            "hyprland",
            "brightnessctl",
            "blueman",
            "adobe-source-sans-fonts",
        })
    end
end)
Hyprland = task("Configure Hyprland and friends", hyprland_packages, function()
    local dirs = {
        "hypr",
        "waybar",
        "swaylock",
        "swaync"
    }
    for _, d in ipairs(dirs) do copy_dir(d, CONFIGDIR) end
end)

local kitty_packages = task("kitty package", function()
    if system_type() == "arch" then
        pkg.arch.package_manager = "yay"
        pkg.arch.ensure({ "kitty", "ttf-fira-code" })
    end
end)

Kitty = task("Configure kitty", kitty_packages, function()
    copy_dir("kitty", CONFIGDIR)
end)

local btop_packages = task("btop package", function()
    if system_type() == "arch" then
        pkg.arch.package_manager = "yay"
        pkg.arch.ensure({ "btop" })
    end
end)

Btop = task("Configure Btop", btop_packages, function()
    copy_dir("btop", CONFIGDIR)
end)

local zsh_packages = task("Zsh packages", function()
    if system_type() == "arch" then
        pkg.arch.package_manager = "yay"
        pkg.arch.ensure({ "zsh", "starship", "ttf-fira-code" })
    end
end)

Zsh = task("Configure zsh, zshrc.d, and starship", zsh_packages, function()
    copy_file("zsh/zshrc", HOMEDIR .. "/.zshrc")
    dir("zsh/zshrc.d"):copy_contents(HOMEDIR .. "/.zshrc.d"):chown(DIROPTS)
    copy_file("zsh/starship.toml", CONFIGDIR .. "/starship.toml")
end)

Wayland_chrome_fixes = task("Add conf files for chromium/chrome/electron on wayland", function()
    local flags = {
        "chrome-flags.conf",
        "code-flags.conf",
        "chromium-flags.conf",
        "electron24-flags.conf",
        "electron25-flags.conf"
    }
    for _, f in ipairs(flags) do copy_file("config/" .. f, CONFIGDIR) end
end)

Desktop_Environment = task("Full DE", { Hyprland, Kitty, Btop, Zsh, Wayland_chrome_fixes })

Env = task("Env", function()
    echo(machine.uname)
    echo(vars.user)
    echo(vars.group)
end)
