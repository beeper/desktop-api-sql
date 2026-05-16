CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_users._retrieve_profile(
  user_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.users.with_raw_response.retrieve_profile(
      user_id=user_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_users.retrieve_profile(
  user_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_users._retrieve_profile(user_id);
  END;
$$;