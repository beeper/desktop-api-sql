ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE avatar_url TEXT,
  ADD ATTRIBUTE dm_room_mxid TEXT,
  ADD ATTRIBUTE identifiers TEXT[],
  ADD ATTRIBUTE mxid TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_room_create_dm_response(
  id TEXT,
  avatar_url TEXT DEFAULT NULL,
  dm_room_mxid TEXT DEFAULT NULL,
  identifiers TEXT[] DEFAULT NULL,
  mxid TEXT DEFAULT NULL,
  name TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, avatar_url, dm_room_mxid, identifiers, mxid, name
  )::beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.room_create_group_response
  ADD ATTRIBUTE id TEXT, ADD ATTRIBUTE mxid TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_room_create_group_response(
  id TEXT, mxid TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.room_create_group_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, mxid
  )::beeper_desktop_api_matrix_bridges_rooms.room_create_group_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar
  ADD ATTRIBUTE url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_create_group_params_avatar(
  url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    url
  )::beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear
  ADD ATTRIBUTE timer DOUBLE PRECISION, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_create_group_params_disappear(
  timer DOUBLE PRECISION DEFAULT NULL, type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    timer, type
  )::beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_name
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_create_group_params_name(
  name TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.create_group_params_name
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name
  )::beeper_desktop_api_matrix_bridges_rooms.create_group_params_name;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic
  ADD ATTRIBUTE topic TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.make_create_group_params_topic(
  topic TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    topic
  )::beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms._create_dm(
  bridge_id TEXT, identifier TEXT, login_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.rooms.with_raw_response.create_dm(
      bridge_id=bridge_id,
      identifier=identifier,
      login_id=not_given if login_id is None else login_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.create_dm(
  bridge_id TEXT, identifier TEXT, login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response,
      beeper_desktop_api_matrix_bridges_rooms._create_dm(
        bridge_id, identifier, login_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms._create_group(
  bridge_id TEXT,
  group_type TEXT,
  login_id TEXT DEFAULT NULL,
  avatar beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar DEFAULT NULL,
  disappear beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear DEFAULT NULL,
  name beeper_desktop_api_matrix_bridges_rooms.create_group_params_name DEFAULT NULL,
  parent JSONB DEFAULT NULL,
  participants TEXT[] DEFAULT NULL,
  room_id TEXT DEFAULT NULL,
  topic beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic DEFAULT NULL,
  type TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.rooms.with_raw_response.create_group(
      bridge_id=bridge_id,
      group_type=group_type,
      login_id=not_given if login_id is None else login_id,
      avatar=not_given if avatar is None else GD["__beeper_desktop_api_context__"].strip_none(avatar),
      disappear=not_given if disappear is None else GD["__beeper_desktop_api_context__"].strip_none(disappear),
      name=not_given if name is None else GD["__beeper_desktop_api_context__"].strip_none(name),
      parent=not_given if parent is None else json.loads(parent),
      participants=not_given if participants is None else participants,
      room_id=not_given if room_id is None else room_id,
      topic=not_given if topic is None else GD["__beeper_desktop_api_context__"].strip_none(topic),
      type=not_given if type is None else type,
      username=not_given if username is None else username,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_rooms.create_group(
  bridge_id TEXT,
  group_type TEXT,
  login_id TEXT DEFAULT NULL,
  avatar beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar DEFAULT NULL,
  disappear beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear DEFAULT NULL,
  name beeper_desktop_api_matrix_bridges_rooms.create_group_params_name DEFAULT NULL,
  parent JSONB DEFAULT NULL,
  participants TEXT[] DEFAULT NULL,
  room_id TEXT DEFAULT NULL,
  topic beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic DEFAULT NULL,
  type TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_rooms.room_create_group_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_rooms.room_create_group_response,
      beeper_desktop_api_matrix_bridges_rooms._create_group(
        bridge_id,
        group_type,
        login_id,
        avatar,
        disappear,
        name,
        parent,
        participants,
        room_id,
        topic,
        type,
        username
      )
    );
  END;
$$;