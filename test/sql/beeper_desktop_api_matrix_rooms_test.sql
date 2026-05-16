SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_rooms.create();

SELECT *
FROM beeper_desktop_api_matrix_rooms.join(
  room_id_or_alias := '!monkeys:matrix.org'
);

SELECT *
FROM beeper_desktop_api_matrix_rooms.leave(room_id := '!nkl290a:matrix.org');