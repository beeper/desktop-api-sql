ALTER TYPE beeper_desktop_api_matrix_bridges_users.user_resolve_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE avatar_url TEXT,
  ADD ATTRIBUTE dm_room_mxid TEXT,
  ADD ATTRIBUTE identifiers TEXT[],
  ADD ATTRIBUTE mxid TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users.make_user_resolve_response(
  id TEXT,
  avatar_url TEXT DEFAULT NULL,
  dm_room_mxid TEXT DEFAULT NULL,
  identifiers TEXT[] DEFAULT NULL,
  mxid TEXT DEFAULT NULL,
  name TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_users.user_resolve_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, avatar_url, dm_room_mxid, identifiers, mxid, name
  )::beeper_desktop_api_matrix_bridges_users.user_resolve_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_users.user_search_response
  ADD ATTRIBUTE results beeper_desktop_api_matrix_bridges_users.user_search_response_result[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users.make_user_search_response(
  results beeper_desktop_api_matrix_bridges_users.user_search_response_result[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_users.user_search_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    results
  )::beeper_desktop_api_matrix_bridges_users.user_search_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_users.user_search_response_result
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE avatar_url TEXT,
  ADD ATTRIBUTE dm_room_mxid TEXT,
  ADD ATTRIBUTE identifiers TEXT[],
  ADD ATTRIBUTE mxid TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users.make_user_search_response_result(
  id TEXT,
  avatar_url TEXT DEFAULT NULL,
  dm_room_mxid TEXT DEFAULT NULL,
  identifiers TEXT[] DEFAULT NULL,
  mxid TEXT DEFAULT NULL,
  name TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_users.user_search_response_result
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, avatar_url, dm_room_mxid, identifiers, mxid, name
  )::beeper_desktop_api_matrix_bridges_users.user_search_response_result;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users._resolve(
  bridge_id TEXT, identifier TEXT, login_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.users.with_raw_response.resolve(
      bridge_id=bridge_id,
      identifier=identifier,
      login_id=not_given if login_id is None else login_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users.resolve(
  bridge_id TEXT, identifier TEXT, login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_users.user_resolve_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_users.user_resolve_response,
      beeper_desktop_api_matrix_bridges_users._resolve(
        bridge_id, identifier, login_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users._search(
  bridge_id TEXT, login_id TEXT DEFAULT NULL, query TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.users.with_raw_response.search(
      bridge_id=bridge_id,
      login_id=not_given if login_id is None else login_id,
      query=not_given if query is None else query,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_users.search(
  bridge_id TEXT, login_id TEXT DEFAULT NULL, query TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_users.user_search_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_users.user_search_response,
      beeper_desktop_api_matrix_bridges_users._search(
        bridge_id, login_id, query
      )
    );
  END;
$$;