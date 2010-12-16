-- Mailbox settings.
envelope = storage("mailbox_settings", "envelope")
saycid = storage("mailbox_settings", "saycid")

-- Message data.
message_number = storage("counter", "message_number")
timestamp = storage("message", "timestamp_" .. message_number)
caller_id_number = storage("message", "caller_id_number_" .. message_number)

return
{
  {
    action = "play_phrase",
    phrase = "cid_envelope",
    phrase_arguments = envelope .. ":" .. timestamp .. ":" .. saycid .. ":" .. caller_id_number,
    keys = {
      ["1"] = "top:play_message",
      ["2"] = "top:change_folders",
      ["3"] = "top:advanced_options",
      ["4"] = "top:prev_message",
      ["5"] = "top:repeat_message",
      ["6"] = "top:next_message",
      ["7"] = "top:delete_undelete_message",
      ["8"] = "top:forward_message",
      ["9"] = "top:save_message",
      ["*"] = "help",
      ["#"] = "exit",
    },
  },
}
