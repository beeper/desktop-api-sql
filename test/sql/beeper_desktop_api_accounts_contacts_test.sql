SET datestyle = 'ISO';
SET beeper_desktop_api.beeper_access_token = 'My Access Token';

SELECT *
FROM beeper_desktop_api_accounts_contacts.list(account_id := 'accountID')
LIMIT 42;

SELECT *
FROM beeper_desktop_api_accounts_contacts.search(
  account_id := 'accountID', query := 'x'
);