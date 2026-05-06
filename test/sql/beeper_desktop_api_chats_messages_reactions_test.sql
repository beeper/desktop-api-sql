SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_chats_messages_reactions.delete(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  message_id := '1343993',
  reaction_key := 'x'
);

SELECT *
FROM beeper_desktop_api_chats_messages_reactions.add(
  chat_id := '!NCdzlIaMjZUmvmvyHU:beeper.com',
  message_id := '1343993',
  reaction_key := 'x'
);