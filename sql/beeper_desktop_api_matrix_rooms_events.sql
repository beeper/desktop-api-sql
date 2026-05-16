ALTER TYPE beeper_desktop_api_matrix_rooms_events.event_retrieve_response
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE event_id TEXT,
  ADD ATTRIBUTE origin_server_ts BIGINT,
  ADD ATTRIBUTE room_id TEXT,
  ADD ATTRIBUTE sender TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE state_key TEXT,
  ADD ATTRIBUTE unsigned beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_events.make_event_retrieve_response(
  content JSONB,
  event_id TEXT,
  origin_server_ts BIGINT,
  room_id TEXT,
  sender TEXT,
  type TEXT,
  state_key TEXT DEFAULT NULL,
  unsigned beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms_events.event_retrieve_response
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
  )::beeper_desktop_api_matrix_rooms_events.event_retrieve_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned
  ADD ATTRIBUTE age BIGINT,
  ADD ATTRIBUTE membership TEXT,
  ADD ATTRIBUTE prev_content JSONB,
  ADD ATTRIBUTE redacted_because JSONB,
  ADD ATTRIBUTE transaction_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_events.make_event_retrieve_response_unsigned(
  age BIGINT DEFAULT NULL,
  membership TEXT DEFAULT NULL,
  prev_content JSONB DEFAULT NULL,
  redacted_because JSONB DEFAULT NULL,
  transaction_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    age, membership, prev_content, redacted_because, transaction_id
  )::beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_events._retrieve(
  room_id TEXT, event_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.events.with_raw_response.retrieve(
      room_id=room_id,
      event_id=event_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_events.retrieve(
  room_id TEXT, event_id TEXT
)
RETURNS beeper_desktop_api_matrix_rooms_events.event_retrieve_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_rooms_events.event_retrieve_response,
      beeper_desktop_api_matrix_rooms_events._retrieve(room_id, event_id)
    );
  END;
$$;