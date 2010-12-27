mailbox = storage("login_settings", "mailbox_number")
mailbox_directory = profile.mailboxes_dir .. "/" .. mailbox

greeting = args(1)
greeting_filename = mailbox_directory .. "/" .. greeting .. ".tmp.wav"

return
{
  {
    action = "play",
    file = greeting_filename,
    keys = {
     ["1"] = "accept_greeting " .. greeting,
     ["2"] = "listen_to_greeting " .. greeting,
     ["3"] = "record_greeting " .. greeting,
     ["#"] = ":break",
    },
  },
  {
    action = "call_sequence",
    sequence = "record_greeting_confirm " .. greeting,
  },
}