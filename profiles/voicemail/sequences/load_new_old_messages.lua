timezone = storage("mailbox_settings", "timezone")

return
{
  {
    action = "set_variable",
    data = {
      timezone = timezone,
    },
  },
  {
    action = "call_sequence",
    sequence = "sub:get_messages 0,new",
  },
  {
    action = "call_sequence",
    sequence = "sub:get_messages 1,old",
  },
  {
    action = "call_sequence",
    sequence = "main_menu",
  },
}
