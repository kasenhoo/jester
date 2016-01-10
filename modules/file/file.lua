local core = require "jester.core"

local _M = {}

--[[
  Appends the freeswitch base_dir if a relative path is passed.
]]
local function get_filepath(file)
  -- Look for leading slash to indicate full path.
  if file:sub(1, 1) ~= "/" then
    file = core.conf.base_dir .. "/" .. file
  end
  return file
end

--[[
  Create a directory.
]]
function _M.create_directory(action)
  local directory = action.directory
  if directory then
    local success, file_error
    require "lfs"
    local path = get_filepath(directory)
    -- Look for existing directory.
    success, file_error = lfs.attributes(path, "mode")
    if success then
      core.debug_log("Directory '%s' already exists, skipping creation.", path)
    else
      -- Create new directory.
      success, file_error = lfs.mkdir(path)
      if success then
        core.debug_log("Created directory '%s'", path)
      else
        core.debug_log("Failed to create directory '%s'!: %s", path, file_error)
      end
    end
  else
    core.debug_log("Cannot create directory, no 'path' parameter defined!")
  end
end

--[[
  Remove a directory.
]]
function _M.remove_directory(action)
  local directory = action.directory
  if directory then
    local success, file_error
    require "lfs"
    local path = get_filepath(directory)
    -- Look for existing directory.
    success, file_error = lfs.attributes(path, "mode")
    if success then
      -- Remove directory.
      success, file_error = lfs.rmdir(path)
      if success then
        core.debug_log("Deleted directory '%s'", path)
      else
        core.debug_log("Failed to delete directory '%s'!: %s", path, file_error)
      end
    else
      core.debug_log("Directory '%s' does not exist, skipping removal.", path)
    end
  else
    core.debug_log("Cannot delete directory, no 'path' parameter defined!")
  end
end

--[[
  Move or copy a file.
]]
function _M.move_file(action)
  local operation = action.copy and "copy" or "move"
  local binary = action.binary and "b" or ""
  if action.source and action.destination then
    local success, file_error
    local source_file = get_filepath(action.source)
    local destination_file = get_filepath(action.destination)
    -- Move.
    if operation == "move" then
      success, file_error = os.rename(source_file, destination_file)
    -- Copy.
    else
      -- There is no copy function for files in Lua, so open the original,
      -- read it, and write the new one.
      local source, file_error = io.open(source_file, "r" .. binary)
      if source then
        local destination, file_error = io.open(destination_file, "w" .. binary)
        if destination then
          success = destination:write(source:read("*all"))
          destination:close()
        end
        source:close()
      end
    end
    if success then
      core.debug_log("Successful file %s from '%s' to '%s'", operation, source_file, destination_file)
    else
      core.debug_log("Failed file %s from '%s' to '%s'!: %s", operation, source_file, destination_file, file_error)
    end
  else
    core.debug_log("Cannot perform file %s, missing parameter! Source: %s, Destination: %s", operation, tostring(action.source), tostring(action.destination))
  end
end

--[[
  Delete a file.
]]
function _M.delete_file(action)
  if action.file then
    local file = get_filepath(action.file)
    local success, file_error = os.remove(file)
    if success then
      core.debug_log("Deleted file '%s'", file)
    else
      core.debug_log("Failed to delete file '%s'!: %s", file, file_error)
    end
  else
    core.debug_log("Cannot delete file, no 'file' parameter defined!")
  end
end

--[[
  Check for file existence.
]]
function _M.file_exists(action)
  local result, file
  if action.file then
    require "lfs"
    file = get_filepath(action.file)
    -- If we can pull the file attributes, then the file exists.
    local success, file_error = lfs.attributes(file, "mode")
    if success then
      result = "true"
    else
      result = "false"
    end
  else
    result = ""
  end
  -- Store the result of the check.
  core.set_storage("file", "file_exists", result)
  if result == "false" then
    core.debug_log("File '%s' does not exist", file)
    -- Run false sequence if specified.
    if action.if_false then
      core.queue_sequence(action.if_false)
    end
  elseif result == "true" then
    core.debug_log("File '%s' exists", file)
    -- Run true sequence if specified.
    if action.if_true then
      core.queue_sequence(action.if_true)
    end
  else
    core.debug_log("Cannot check file, no 'file' parameter defined!")
  end
end

--[[
  Returns a file's size.
]]
function _M.file_size(action)
  local file, size
  if action.file then
    require "lfs"
    file = get_filepath(action.file)
    size = lfs.attributes(file, "size")
  end
  -- Store the result of the check.
  core.set_storage("file", "size", size)
end

return _M
