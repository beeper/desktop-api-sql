SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_messages.update(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  message_id := 'messageID',
  text := 'x'
);

SELECT *
FROM beeper_desktop_api_messages.list(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
)
LIMIT 42;

SELECT *
FROM beeper_desktop_api_messages.search()
LIMIT 42;

SELECT *
FROM beeper_desktop_api_messages.send(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);