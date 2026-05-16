ALTER TYPE beeper_desktop_api_matrix_rooms_state.state_list_response
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE event_id TEXT,
  ADD ATTRIBUTE origin_server_ts BIGINT,
  ADD ATTRIBUTE room_id TEXT,
  ADD ATTRIBUTE sender TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE state_key TEXT,
  ADD ATTRIBUTE unsigned beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state.make_state_list_response(
  content JSONB,
  event_id TEXT,
  origin_server_ts BIGINT,
  room_id TEXT,
  sender TEXT,
  type TEXT,
  state_key TEXT DEFAULT NULL,
  unsigned beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms_state.state_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content,
    event_id,
    origin_server_ts,
    room_id,
    sender,
    type,
    state_key,
    unsigned
  )::beeper_desktop_api_matrix_rooms_state.state_list_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned
  ADD ATTRIBUTE age BIGINT,
  ADD ATTRIBUTE membership TEXT,
  ADD ATTRIBUTE prev_content JSONB,
  ADD ATTRIBUTE redacted_because JSONB,
  ADD ATTRIBUTE transaction_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state.make_state_list_response_unsigned(
  age BIGINT DEFAULT NULL,
  membership TEXT DEFAULT NULL,
  prev_content JSONB DEFAULT NULL,
  redacted_because JSONB DEFAULT NULL,
  transaction_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    age, membership, prev_content, redacted_because, transaction_id
  )::beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state._retrieve(
  room_id TEXT, event_type TEXT, state_key TEXT, format TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.state.with_raw_response.retrieve(
      room_id=room_id,
      event_type=event_type,
      state_key=state_key,
      format=not_given if format is None else format,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state.retrieve(
  room_id TEXT, event_type TEXT, state_key TEXT, format TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_rooms_state._retrieve(
      room_id, event_type, state_key, format
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state._list(
  room_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.state.with_raw_response.list(
      room_id=room_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_state.list(
  room_id TEXT
)
RETURNS SETOF beeper_desktop_api_matrix_rooms_state.state_list_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN QUERY SELECT * FROM jsonb_populate_recordset(
      NULL::beeper_desktop_api_matrix_rooms_state.state_list_response,
      beeper_desktop_api_matrix_rooms_state._list(room_id)
    );
  END;
$$;