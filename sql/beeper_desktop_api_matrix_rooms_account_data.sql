CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_account_data._retrieve(
  user_id TEXT, room_id TEXT, type TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.account_data.with_raw_response.retrieve(
      user_id=user_id,
      room_id=room_id,
      type=type,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_account_data.retrieve(
  user_id TEXT, room_id TEXT, type TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_rooms_account_data._retrieve(
      user_id, room_id, type
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_account_data._update(
  user_id TEXT, room_id TEXT, type TEXT, body JSONB
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json

  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.account_data.with_raw_response.update(
      user_id=user_id,
      room_id=room_id,
      type=type,
      body=json.loads(body),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms_account_data.update(
  user_id TEXT, room_id TEXT, type TEXT, body JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_rooms_account_data._update(
      user_id, room_id, type, body
    );
  END;
$$;