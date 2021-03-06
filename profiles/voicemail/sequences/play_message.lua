--[[
  Play a message.
]]

-- Mailbox info.
mailbox = storage("login_settings", "mailbox_number")
mailbox_directory = profile.mailboxes_dir .. "/" .. mailbox

-- Message data.
message_number = storage("counter", "message_number")
recording_name = storage("message", "recording_" .. message_number)

-- Folder data.
current_folder = storage("message_settings", "current_folder")

return
{
  -- New messages get automatically moved to old messages.
  {
    action = "conditional",
    value = current_folder,
    compare_to = "0",
    if_true = "sub:update_message_folder 1"
  },
  {
    action = "play",
    file = mailbox_directory .. "/" .. recording_name,
    keys = {
      ["1"] = "top:play_first_message",
      ["2"] = ":seek:0",
      ["3"] = "top:advanced_options",
      ["4"] = "top:prev_message",
      ["5"] = "top:repeat_message",
      ["6"] = "top:next_message",
      ["7"] = "top:delete_undelete_message",
      ["8"] = "top:forward_message_menu",
      ["9"] = "top:save_message",
      ["0"] = ":pause",
      ["*"] = ":seek:-5000",
      ["#"] = ":seek:+1500",
    },
  },
  {
    action = "call_sequence",
    sequence = "sub:message_options",
  },
}

