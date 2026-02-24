SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_chats_reminders.create(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  reminder := beeper_desktop_api_chats_reminders.make_reminder(
    remind_at_ms := 0, dismiss_on_incoming_message := TRUE
  )
);

SELECT *
FROM beeper_desktop_api_chats_reminders.delete(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);