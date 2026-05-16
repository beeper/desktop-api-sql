ALTER TYPE beeper_desktop_api_matrix_bridges_contacts.contact_list_response
  ADD ATTRIBUTE contacts beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_contacts.make_contact_list_response(
  contacts beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_contacts.contact_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    contacts
  )::beeper_desktop_api_matrix_bridges_contacts.contact_list_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE avatar_url TEXT,
  ADD ATTRIBUTE dm_room_mxid TEXT,
  ADD ATTRIBUTE identifiers TEXT[],
  ADD ATTRIBUTE mxid TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_contacts.make_contact_list_response_contact(
  id TEXT,
  avatar_url TEXT DEFAULT NULL,
  dm_room_mxid TEXT DEFAULT NULL,
  identifiers TEXT[] DEFAULT NULL,
  mxid TEXT DEFAULT NULL,
  name TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, avatar_url, dm_room_mxid, identifiers, mxid, name
  )::beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_contacts._list(
  bridge_id TEXT, login_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.contacts.with_raw_response.list(
      bridge_id=bridge_id,
      login_id=not_given if login_id is None else login_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_contacts.list(
  bridge_id TEXT, login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_contacts.contact_list_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_contacts.contact_list_response,
      beeper_desktop_api_matrix_bridges_contacts._list(bridge_id, login_id)
    );
  END;
$$;