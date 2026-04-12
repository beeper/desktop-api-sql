SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_chats.create();

SELECT *
FROM beeper_desktop_api_chats.retrieve(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);

SELECT *
FROM beeper_desktop_api_chats.list()
LIMIT 42;

SELECT *
FROM beeper_desktop_api_chats.archive(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com'
);

SELECT *
FROM beeper_desktop_api_chats.search()
LIMIT 42;