ALTER TYPE beeper_desktop_api_accounts.account
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE bridge beeper_desktop_api_accounts.account_bridge,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE "user" beeper_desktop_api.user;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts.make_account(
  accountID TEXT,
  bridge beeper_desktop_api_accounts.account_bridge,
  network TEXT,
  "user" beeper_desktop_api.user
)
RETURNS beeper_desktop_api_accounts.account
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    accountID, bridge, network, "user"
  )::beeper_desktop_api_accounts.account;
$$;

ALTER TYPE beeper_desktop_api_accounts.account_bridge
  ADD ATTRIBUTE id TEXT, ADD ATTRIBUTE provider TEXT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts.make_account_bridge(
  id TEXT, provider TEXT, type TEXT
)
RETURNS beeper_desktop_api_accounts.account_bridge
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(id, provider, type)::beeper_desktop_api_accounts.account_bridge;
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