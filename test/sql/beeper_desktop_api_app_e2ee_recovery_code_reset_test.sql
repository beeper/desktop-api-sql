SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_app_e2ee_recovery_code_reset.create();

SELECT *
FROM beeper_desktop_api_app_e2ee_recovery_code_reset.confirm(
  recovery_code := 'x'
);