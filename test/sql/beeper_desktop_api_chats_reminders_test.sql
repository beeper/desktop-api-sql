SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_chats_reminders.create(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  reminder := beeper_desktop_api_chats_reminders.make_create_params_reminder(
    remindAt := '2025-08-31T23:30:12.520Z', dismissOnIncomingMessage := TRUE
  )
);

SELECT *
FROM beeper_desktop_api_chats_reminders.delete(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);