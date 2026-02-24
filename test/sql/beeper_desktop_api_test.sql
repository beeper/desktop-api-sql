SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api.focus();

SELECT *
FROM beeper_desktop_api.search(query := 'x');