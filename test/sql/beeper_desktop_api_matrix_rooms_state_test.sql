SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_rooms_state.retrieve(
  room_id := '!636q39766251:example.com',
  event_type := 'm.room.name',
  state_key := 'state_key'
);

SELECT *
FROM beeper_desktop_api_matrix_rooms_state.list(
  room_id := '!636q39766251:example.com'
);