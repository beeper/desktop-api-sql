SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_app_e2ee_verification_sas.confirm(
  verification_id := 'x'
);

SELECT *
FROM beeper_desktop_api_app_e2ee_verification_sas.start(verification_id := 'x');