-- Roughly inspired by: https://github.com/szymonkaliski/dotfiles

local M = {}
M._savedState = {}

M.init = function(hyper)
    hyper.addHook(nil, function()
        M._savedState = {}
    end)
end

M.smartLaunch = function(launchApp, name)
    if M._savedState.lastApp ~= launchApp then
        M._savedState = { lastApp = launchApp }
    end

    if not name then
        name = launchApp
    end

    local runningApp = hs.application.get(launchApp)

    if not runningApp then
        hs.alert.show("Launching " .. name, 1.2)
        hs.application.open(launchApp)
    else
        if not M._savedState.windows then
            local windows = hs.fnutils.filter(runningApp:allWindows(), function(win)
                return win:isStandard()
            end)
            M._savedState.windows = windows
            M._savedState.index = hs.fnutils.indexOf(windows, hs.window.frontmostWindow()) or 0
        end

        if #M._savedState.windows == 0 then
            hs.alert.show("Creating new " .. name .. " window", 1.2)
            hs.application.open(launchApp)
        else
            -- focus a window and set window index for next smartLaunch call
            M._savedState.windows[(M._savedState.index % #M._savedState.windows) + 1]:focus()
            M._savedState.index = M._savedState.index + 1
        end
    end
end

return M
