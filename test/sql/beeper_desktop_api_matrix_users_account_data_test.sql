SET datestyle = 'ISO';
SET beeper_desktop_api.access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_matrix_users_account_data.retrieve(
  user_id := '@alice:example.com', type := 'org.example.custom.config'
);

SELECT *
FROM beeper_desktop_api_matrix_users_account_data.update(
  user_id := '@alice:example.com',
  type := 'org.example.custom.config',
  body := $$
  {
    "custom_account_data_key": "custom_config_value"
  }
  $$::JSONB
);