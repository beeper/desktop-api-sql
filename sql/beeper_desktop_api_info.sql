ALTER TYPE beeper_desktop_api_info.info_retrieve_response
  ADD ATTRIBUTE app beeper_desktop_api_info.info_retrieve_response_app,
  ADD ATTRIBUTE endpoints beeper_desktop_api_info.info_retrieve_response_endpoint,
  ADD ATTRIBUTE platform beeper_desktop_api_info.info_retrieve_response_platform,
  ADD ATTRIBUTE server beeper_desktop_api_info.info_retrieve_response_server;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response(
  app beeper_desktop_api_info.info_retrieve_response_app,
  endpoints beeper_desktop_api_info.info_retrieve_response_endpoint,
  platform beeper_desktop_api_info.info_retrieve_response_platform,
  server beeper_desktop_api_info.info_retrieve_response_server
)
RETURNS beeper_desktop_api_info.info_retrieve_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    app, endpoints, platform, server
  )::beeper_desktop_api_info.info_retrieve_response;
$$;

ALTER TYPE beeper_desktop_api_info.info_retrieve_response_app
  ADD ATTRIBUTE bundle_id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE version TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response_app(
  bundle_id TEXT, name TEXT, version TEXT
)
RETURNS beeper_desktop_api_info.info_retrieve_response_app
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    bundle_id, name, version
  )::beeper_desktop_api_info.info_retrieve_response_app;
$$;

ALTER TYPE beeper_desktop_api_info.info_retrieve_response_endpoint
  ADD ATTRIBUTE mcp TEXT,
  ADD ATTRIBUTE oauth beeper_desktop_api_info.info_retrieve_response_endpoint_oauth,
  ADD ATTRIBUTE spec TEXT,
  ADD ATTRIBUTE ws_events TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response_endpoint(
  mcp TEXT,
  oauth beeper_desktop_api_info.info_retrieve_response_endpoint_oauth,
  spec TEXT,
  ws_events TEXT
)
RETURNS beeper_desktop_api_info.info_retrieve_response_endpoint
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    mcp, oauth, spec, ws_events
  )::beeper_desktop_api_info.info_retrieve_response_endpoint;
$$;

ALTER TYPE beeper_desktop_api_info.info_retrieve_response_endpoint_oauth
  ADD ATTRIBUTE authorization_endpoint TEXT,
  ADD ATTRIBUTE introspection_endpoint TEXT,
  ADD ATTRIBUTE registration_endpoint TEXT,
  ADD ATTRIBUTE revocation_endpoint TEXT,
  ADD ATTRIBUTE token_endpoint TEXT,
  ADD ATTRIBUTE userinfo_endpoint TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response_endpoint_oauth(
  authorization_endpoint TEXT,
  introspection_endpoint TEXT,
  registration_endpoint TEXT,
  revocation_endpoint TEXT,
  token_endpoint TEXT,
  userinfo_endpoint TEXT
)
RETURNS beeper_desktop_api_info.info_retrieve_response_endpoint_oauth
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    authorization_endpoint,
    introspection_endpoint,
    registration_endpoint,
    revocation_endpoint,
    token_endpoint,
    userinfo_endpoint
  )::beeper_desktop_api_info.info_retrieve_response_endpoint_oauth;
$$;

ALTER TYPE beeper_desktop_api_info.info_retrieve_response_platform
  ADD ATTRIBUTE arch TEXT, ADD ATTRIBUTE os TEXT, ADD ATTRIBUTE release TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response_platform(
  arch TEXT, os TEXT, release TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_info.info_retrieve_response_platform
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arch, os, release
  )::beeper_desktop_api_info.info_retrieve_response_platform;
$$;

ALTER TYPE beeper_desktop_api_info.info_retrieve_response_server
  ADD ATTRIBUTE base_url TEXT,
  ADD ATTRIBUTE hostname TEXT,
  ADD ATTRIBUTE mcp_enabled BOOLEAN,
  ADD ATTRIBUTE port BIGINT,
  ADD ATTRIBUTE remote_access BOOLEAN,
  ADD ATTRIBUTE status TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.make_info_retrieve_response_server(
  base_url TEXT,
  hostname TEXT,
  mcp_enabled BOOLEAN,
  port BIGINT,
  remote_access BOOLEAN,
  status TEXT
)
RETURNS beeper_desktop_api_info.info_retrieve_response_server
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    base_url, hostname, mcp_enabled, port, remote_access, status
  )::beeper_desktop_api_info.info_retrieve_response_server;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info._retrieve()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.info.with_raw_response.retrieve()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_info.retrieve()
RETURNS beeper_desktop_api_info.info_retrieve_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_info.info_retrieve_response,
      beeper_desktop_api_info._retrieve()
    );
  END;
$$;