ALTER TYPE beeper_desktop_api_accounts.account
  ADD ATTRIBUTE accountID TEXT, ADD ATTRIBUTE "user" beeper_desktop_api.user;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts.make_account(
  accountID TEXT, "user" beeper_desktop_api.user
)
RETURNS beeper_desktop_api_accounts.account
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(accountID, "user")::beeper_desktop_api_accounts.account;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts._list()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.accounts.with_raw_response.list()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts.list()
RETURNS SETOF beeper_desktop_api_accounts.account
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::beeper_desktop_api_accounts.account,
      beeper_desktop_api_accounts._list()
    );
  END;
$$;