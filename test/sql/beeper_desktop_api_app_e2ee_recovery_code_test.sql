SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_app_e2ee_recovery_code.mark_backed_up();

SELECT *
FROM beeper_desktop_api_app_e2ee_recovery_code.verify(recovery_code := 'x');