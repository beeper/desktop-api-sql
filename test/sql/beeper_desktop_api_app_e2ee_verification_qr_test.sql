SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_app_e2ee_verification_qr.confirm_scanned(
  verification_id := 'x'
);

SELECT *
FROM beeper_desktop_api_app_e2ee_verification_qr.scan(data := 'x');