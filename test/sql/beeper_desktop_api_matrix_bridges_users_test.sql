SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_bridges_users.resolve(
  bridge_id := 'bridgeID', identifier := 'identifier'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_users.search(bridge_id := 'bridgeID');