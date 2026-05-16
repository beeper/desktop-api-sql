ALTER TYPE beeper_desktop_api_bridges.bridge_availability
  ADD ATTRIBUTE accounts beeper_desktop_api_accounts.account[],
  ADD ATTRIBUTE activeAccountCount BIGINT,
  ADD ATTRIBUTE bridge beeper_desktop_api_bridges.bridge_availability_bridge,
  ADD ATTRIBUTE displayName TEXT,
  ADD ATTRIBUTE loginMode TEXT,
  ADD ATTRIBUTE status TEXT,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE statusText TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_bridges.make_bridge_availability(
  accounts beeper_desktop_api_accounts.account[],
  activeAccountCount BIGINT,
  bridge beeper_desktop_api_bridges.bridge_availability_bridge,
  displayName TEXT,
  loginMode TEXT,
  status TEXT,
  network TEXT DEFAULT NULL,
  statusText TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_bridges.bridge_availability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    accounts,
    activeAccountCount,
    bridge,
    displayName,
    loginMode,
    status,
    network,
    statusText
  )::beeper_desktop_api_bridges.bridge_availability;
$$;

ALTER TYPE beeper_desktop_api_bridges.bridge_availability_bridge
  ADD ATTRIBUTE id TEXT, ADD ATTRIBUTE provider TEXT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_bridges.make_bridge_availability_bridge(
  id TEXT, provider TEXT, type TEXT
)
RETURNS beeper_desktop_api_bridges.bridge_availability_bridge
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, provider, type
  )::beeper_desktop_api_bridges.bridge_availability_bridge;
$$;

ALTER TYPE beeper_desktop_api_bridges.bridge_list_response
  ADD ATTRIBUTE items beeper_desktop_api_bridges.bridge_availability[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_bridges.make_bridge_list_response(
  items beeper_desktop_api_bridges.bridge_availability[]
)
RETURNS beeper_desktop_api_bridges.bridge_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(items)::beeper_desktop_api_bridges.bridge_list_response;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_bridges._list()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.bridges.with_raw_response.list()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_bridges.list()
RETURNS beeper_desktop_api_bridges.bridge_list_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_bridges.bridge_list_response,
      beeper_desktop_api_bridges._list()
    );
  END;
$$;