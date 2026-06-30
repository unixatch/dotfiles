--[[
]]

local utils = require "mp.utils"
local input = require "mp.input"

local options = {
    history_date_format = "%Y-%m-%d %H:%M:%S",
    hide_history_duplicates = true,
}

require "mp.options".read_options(options, nil, function () end)

local function show_warning(message)
    mp.msg.warn(message)
    if mp.get_property_native("vo-configured") then
        mp.osd_message(message)
    end
end

local function show_error(message)
    mp.msg.error(message)
    if mp.get_property_native("vo-configured") then
        mp.osd_message(message)
    end
end

item = ""
local function load_fs(dir)
    local playlist = {}
    local default_item
    local show = mp.get_property_native("osd-playlist-entry")
    local trailing_slash_pattern = mp.get_property("platform") == "windows"
                                   and "[/\\]+$" or "/+$"
    
    local dirToUse
    if dir == nil or dir == "" then
        dirToUse = utils.readdir(utils.getcwd())
    else
        dirToUse = utils.readdir(dir)
    end
    for i, entry in ipairs(dirToUse) do
        playlist[i] = entry
        if not playlist[i] or show ~= "title" then
            playlist[i] = entry.filename
            if not playlist[i]:find("://") then
                playlist[i] = select(2, utils.split_path(
                    playlist[i]:gsub(trailing_slash_pattern, "")))
            end
        end
        if entry.title and show == "both" then
            playlist[i] = string.format("%s (%s)", entry.title, playlist[i])
        end

        if entry.playing then
            default_item = i
        end
    end

    if #playlist == 0 then
        show_warning("The playlist is empty.")
        return
    end

    input.select({
        prompt = "Select a file/folder:",
        items = playlist,
        default_item = default_item,
        submit = function (currentIndex)
            local isDir = utils.file_info(playlist[currentIndex]).is_dir
            if isDir == true then
                return load_fs(playlist[currentIndex])
            else
                item = playlist[currentIndex]
            end
            mp.commandv("loadfile", item, "append")
        end
    })
end

mp.add_key_binding("/", "select-playlist-from-fs", load_fs)
