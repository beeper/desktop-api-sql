SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.list_flows(bridge_id := 'bridgeID');

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.list_logins(
  bridge_id := 'bridgeID'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.logout(
  bridge_id := 'bridgeID', login_id := 'bcc68892-b180-414f-9516-b4aadf7d0496'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.start_login(
  bridge_id := 'bridgeID', flow_id := 'qr'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.submit_cookies(
  bridge_id := 'bridgeID',
  login_process_id := 'loginProcessID',
  step_id := 'stepID',
  body := $$
  {
    "foo": "string"
  }
  $$::JSONB
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.submit_user_input(
  bridge_id := 'bridgeID',
  login_process_id := 'loginProcessID',
  step_id := 'stepID',
  body := $$
  {
    "foo": "string"
  }
  $$::JSONB
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.wait_for_step(
  bridge_id := 'bridgeID',
  login_process_id := 'loginProcessID',
  step_id := 'stepID'
);

SELECT *
FROM beeper_desktop_api_matrix_bridges_auth.whoami(bridge_id := 'bridgeID');