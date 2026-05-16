SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_rooms_account_data.retrieve(
  user_id := '@alice:example.com',
  room_id := '!726s6s6q:example.com',
  type := 'org.example.custom.room.config'
);

SELECT *
FROM beeper_desktop_api_matrix_rooms_account_data.update(
  user_id := '@alice:example.com',
  room_id := '!726s6s6q:example.com',
  type := 'org.example.custom.room.config',
  body := $$
  {
    "custom_account_data_key": "custom_account_data_value"
  }
  $$::JSONB
);