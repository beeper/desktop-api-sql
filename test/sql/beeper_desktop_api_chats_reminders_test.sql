SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_chats_reminders.create(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  reminder := beeper_desktop_api_chats_reminders.make_reminder(
    remindAtMs := 0, dismissOnIncomingMessage := TRUE
  )
);

SELECT *
FROM beeper_desktop_api_chats_reminders.delete(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);