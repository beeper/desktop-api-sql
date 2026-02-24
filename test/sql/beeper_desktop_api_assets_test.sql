SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_assets.download(
  url := 'mxc://example.org/Q4x9CqGz1pB3Oa6XgJ'
);

SELECT *
FROM beeper_desktop_api_assets.serve(url := 'x');

SELECT *
FROM beeper_desktop_api_assets.upload(file := NULL);

SELECT *
FROM beeper_desktop_api_assets.upload_base64(content := 'x');