ALTER TYPE beeper_desktop_api_matrix_rooms.room_create_response
  ADD ATTRIBUTE room_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.make_room_create_response(
  room_id TEXT
)
RETURNS beeper_desktop_api_matrix_rooms.room_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(room_id)::beeper_desktop_api_matrix_rooms.room_create_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms.room_join_response
  ADD ATTRIBUTE room_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.make_room_join_response(
  room_id TEXT
)
RETURNS beeper_desktop_api_matrix_rooms.room_join_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(room_id)::beeper_desktop_api_matrix_rooms.room_join_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms.create_params_initial_state
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE state_key TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.make_create_params_initial_state(
  content JSONB, type TEXT, state_key TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms.create_params_initial_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, type, state_key
  )::beeper_desktop_api_matrix_rooms.create_params_initial_state;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms.create_params_invite_3pid
  ADD ATTRIBUTE address TEXT,
  ADD ATTRIBUTE id_access_token TEXT,
  ADD ATTRIBUTE id_server TEXT,
  ADD ATTRIBUTE medium TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.make_create_params_invite_3pid(
  address TEXT, id_access_token TEXT, id_server TEXT, medium TEXT
)
RETURNS beeper_desktop_api_matrix_rooms.create_params_invite_3pid
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    address, id_access_token, id_server, medium
  )::beeper_desktop_api_matrix_rooms.create_params_invite_3pid;
$$;

ALTER TYPE beeper_desktop_api_matrix_rooms.join_params_third_party_signed
  ADD ATTRIBUTE token TEXT,
  ADD ATTRIBUTE mxid TEXT,
  ADD ATTRIBUTE sender TEXT,
  ADD ATTRIBUTE signatures JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.make_join_params_third_party_signed(
  token TEXT, mxid TEXT, sender TEXT, signatures JSONB
)
RETURNS beeper_desktop_api_matrix_rooms.join_params_third_party_signed
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    token, mxid, sender, signatures
  )::beeper_desktop_api_matrix_rooms.join_params_third_party_signed;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms._create(
  creation_content JSONB DEFAULT NULL,
  initial_state beeper_desktop_api_matrix_rooms.create_params_initial_state[] DEFAULT NULL,
  invite TEXT[] DEFAULT NULL,
  invite_3pid beeper_desktop_api_matrix_rooms.create_params_invite_3pid[] DEFAULT NULL,
  is_direct BOOLEAN DEFAULT NULL,
  name TEXT DEFAULT NULL,
  power_level_content_override JSONB DEFAULT NULL,
  preset TEXT DEFAULT NULL,
  room_alias_name TEXT DEFAULT NULL,
  room_version TEXT DEFAULT NULL,
  topic TEXT DEFAULT NULL,
  visibility TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.with_raw_response.create(
      creation_content=not_given if creation_content is None else json.loads(creation_content),
      initial_state=not_given if initial_state is None else GD["__beeper_desktop_api_context__"].strip_none(initial_state),
      invite=not_given if invite is None else invite,
      invite_3pid=not_given if invite_3pid is None else GD["__beeper_desktop_api_context__"].strip_none(invite_3pid),
      is_direct=not_given if is_direct is None else is_direct,
      name=not_given if name is None else name,
      power_level_content_override=not_given if power_level_content_override is None else json.loads(power_level_content_override),
      preset=not_given if preset is None else preset,
      room_alias_name=not_given if room_alias_name is None else room_alias_name,
      room_version=not_given if room_version is None else room_version,
      topic=not_given if topic is None else topic,
      visibility=not_given if visibility is None else visibility,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.create(
  creation_content JSONB DEFAULT NULL,
  initial_state beeper_desktop_api_matrix_rooms.create_params_initial_state[] DEFAULT NULL,
  invite TEXT[] DEFAULT NULL,
  invite_3pid beeper_desktop_api_matrix_rooms.create_params_invite_3pid[] DEFAULT NULL,
  is_direct BOOLEAN DEFAULT NULL,
  name TEXT DEFAULT NULL,
  power_level_content_override JSONB DEFAULT NULL,
  preset TEXT DEFAULT NULL,
  room_alias_name TEXT DEFAULT NULL,
  room_version TEXT DEFAULT NULL,
  topic TEXT DEFAULT NULL,
  visibility TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms.room_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_rooms.room_create_response,
      beeper_desktop_api_matrix_rooms._create(
        creation_content,
        initial_state,
        invite,
        invite_3pid,
        is_direct,
        name,
        power_level_content_override,
        preset,
        room_alias_name,
        room_version,
        topic,
        visibility
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms._join(
  room_id_or_alias TEXT,
  via TEXT[] DEFAULT NULL,
  reason TEXT DEFAULT NULL,
  third_party_signed beeper_desktop_api_matrix_rooms.join_params_third_party_signed DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.with_raw_response.join(
      room_id_or_alias=room_id_or_alias,
      via=not_given if via is None else via,
      reason=not_given if reason is None else reason,
      third_party_signed=not_given if third_party_signed is None else GD["__beeper_desktop_api_context__"].strip_none(third_party_signed),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.join(
  room_id_or_alias TEXT,
  via TEXT[] DEFAULT NULL,
  reason TEXT DEFAULT NULL,
  third_party_signed beeper_desktop_api_matrix_rooms.join_params_third_party_signed DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_rooms.room_join_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_rooms.room_join_response,
      beeper_desktop_api_matrix_rooms._join(
        room_id_or_alias, via, reason, third_party_signed
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms._leave(
  room_id TEXT, reason TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.rooms.with_raw_response.leave(
      room_id=room_id,
      reason=not_given if reason is None else reason,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_rooms.leave(
  room_id TEXT, reason TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_rooms._leave(room_id, reason);
  END;
$$;