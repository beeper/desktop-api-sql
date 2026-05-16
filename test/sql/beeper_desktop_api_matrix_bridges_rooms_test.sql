SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_bridges_rooms.create_dm(
  bridge_id := 'bridgeID', identifier := 'identifier'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_rooms.create_group(
  bridge_id := 'bridgeID', group_type := 'groupType'
);