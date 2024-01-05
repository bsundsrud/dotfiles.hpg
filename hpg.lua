local HOMEDIR = homedir().canonical_path
local CONFIGDIR = HOMEDIR .. "/.config"

Hyprland = task("Configure Hyprland and friends", function()
    dir("hypr"):copy(CONFIGDIR)
    dir("waybar"):copy(CONFIGDIR)
    dir("swaylock"):copy(CONFIGDIR)
    dir("swaync"):copy(CONFIGDIR)
end)

Kitty = task("Configure kitty", function ()
    dir("kitty"):copy(CONFIGDIR)
end)

Btop = task("Configure Btop", function ()
    dir("btop"):copy(CONFIGDIR)
end)

Zsh = task("Configure zsh, zshrc.d, and starship", function ()
    file("zsh/zshrc"):copy(HOMEDIR .. "/.zshrc")
    dir("zsh/zshrc.d"):copy_contents(HOMEDIR .. "/.zshrc.d")
    file("zsh/starship.toml"):copy(CONFIGDIR .. "/starship.toml")
end)

Wayland_chrome_fixes = task("Add conf files for chromium/chrome/electron on wayland", function ()
    file("config/chrome-flags.conf"):copy(CONFIGDIR)
    file("config/code-flags.conf"):copy(CONFIGDIR)
    file("config/chromium-flags.conf"):copy(CONFIGDIR)
    file("config/electron24-flags.conf"):copy(CONFIGDIR)
    file("config/electron25-flags.conf"):copy(CONFIGDIR)

end)

Desktop_Environment = task("Full DE", {Hyprland, Kitty, Btop, Zsh, Wayland_chrome_fixes})