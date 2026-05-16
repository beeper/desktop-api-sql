SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_bridges_contacts.list(bridge_id := 'bridgeID');