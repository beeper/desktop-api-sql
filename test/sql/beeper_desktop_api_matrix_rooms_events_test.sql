SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_rooms_events.retrieve(
  room_id := '!636q39766251:matrix.org',
  event_id := '$asfDuShaf7Gafaw:matrix.org'
);