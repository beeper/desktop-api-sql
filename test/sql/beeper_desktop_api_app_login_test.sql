SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_app_login.email(
  email := 'dev@stainless.com', request := 'request'
);

SELECT *
FROM beeper_desktop_api_app_login.register(
  accept_terms := TRUE,
  lead_token := 'leadToken',
  request := 'request',
  username := 'x'
);

SELECT *
FROM beeper_desktop_api_app_login.response(
  request := 'request', response := 'response'
);

SELECT *
FROM beeper_desktop_api_app_login.start();