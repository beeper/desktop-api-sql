-- A file that declares all schemas and types upfront so that their definitions don't
-- have to be topologically sorted in other files. It also creates some internal utility functions.

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_internal;
REVOKE ALL ON SCHEMA beeper_desktop_api_internal FROM PUBLIC;

CREATE OR REPLACE FUNCTION beeper_desktop_api_internal.ensure_empty_type(
  p_schema TEXT,
  p_type TEXT
)
RETURNS void
LANGUAGE plpgsql
AS $$
  DECLARE
    attr RECORD;
  BEGIN
    -- Create an empty type if it doesn't exist from a previous extension version.
    IF NOT EXISTS (
      SELECT 1
      FROM pg_type t
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
    ) THEN
      EXECUTE format(
        'CREATE TYPE %I.%I AS ();',
        p_schema,
        p_type
      );
      -- Already empty, nothing to drop.
      RETURN;
    END IF;

    -- Drop all existing attributes from the previous extension version so we can readd them.
    FOR attr IN
      SELECT a.attname
      FROM pg_attribute a
      JOIN pg_type t ON t.typrelid = a.attrelid
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
        AND a.attnum > 0
        AND NOT a.attisdropped
      ORDER BY a.attnum DESC
    LOOP
      EXECUTE format(
        'ALTER TYPE %I.%I DROP ATTRIBUTE %I;',
        p_schema,
        p_type,
        attr.attname
      );
    END LOOP;
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_internal.ensure_context()
RETURNS void
LANGUAGE plpython3u
AS $$
  from types import SimpleNamespace
  from beeper_desktop_api import BeeperDesktop

  if "__beeper_desktop_api_context__" in GD:
      # The context was already created.
      return

  client_options = {}
  try:
      value = plpy.execute("SELECT current_setting('beeper_desktop_api.base_url') AS value")[0]['value']
      client_options["base_url"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('beeper_desktop_api.access_token') AS value")[0]['value']
      client_options["access_token"] = value
  except Exception:
      plpy.warning(
        "Required DB config parameter 'beeper_desktop_api.access_token' is not set",
        hint="ALTER DATABASE my_database SET beeper_desktop_api.access_token = ...;"
      )

  def strip_none(value):
      if isinstance(value, dict):
          return {
              k: strip_none(v)
              for k, v in value.items()
              if v is not None
          }
      elif isinstance(value, list):
          return [strip_none(v) for v in value]
      else:
          return value

  GD["__beeper_desktop_api_context__"] = SimpleNamespace(
      client=BeeperDesktop(**client_options),
      strip_none=strip_none,
  )
$$;

CREATE TYPE beeper_desktop_api_internal.page AS (
  data JSONB,
  next_request_options JSONB
);

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api;

CREATE TYPE beeper_desktop_api.attachment AS ();
CREATE TYPE beeper_desktop_api.attachment_size AS ();
CREATE TYPE beeper_desktop_api.error AS ();
CREATE TYPE beeper_desktop_api.message AS ();
CREATE TYPE beeper_desktop_api.reaction AS ();
CREATE TYPE beeper_desktop_api.user AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api;

CREATE TYPE beeper_desktop_api.client_focus_response AS ();
CREATE TYPE beeper_desktop_api.client_search_response AS ();
CREATE TYPE beeper_desktop_api.client_search_response_result AS ();
CREATE TYPE beeper_desktop_api.client_search_response_result_message AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_accounts;

CREATE TYPE beeper_desktop_api_accounts.account AS ();
CREATE TYPE beeper_desktop_api_accounts.account_bridge AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_accounts_contacts;

CREATE TYPE beeper_desktop_api_accounts_contacts.contact_search_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats;

CREATE TYPE beeper_desktop_api_chats.chat AS ();
CREATE TYPE beeper_desktop_api_chats.chat_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response AS ();
CREATE TYPE beeper_desktop_api_chats.start_params_user AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats_reminders;

CREATE TYPE beeper_desktop_api_chats_reminders.create_params_reminder AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats_messages_reactions;

CREATE TYPE beeper_desktop_api_chats_messages_reactions.reaction_delete_response AS ();
CREATE TYPE beeper_desktop_api_chats_messages_reactions.reaction_add_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_messages;

CREATE TYPE beeper_desktop_api_messages.message_update_response AS ();
CREATE TYPE beeper_desktop_api_messages.message_send_response AS ();
CREATE TYPE beeper_desktop_api_messages.send_params_attachment AS ();
CREATE TYPE beeper_desktop_api_messages.send_params_attachment_send_params_size AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_assets;

CREATE TYPE beeper_desktop_api_assets.asset_download_response AS ();
CREATE TYPE beeper_desktop_api_assets.asset_upload_response AS ();
CREATE TYPE beeper_desktop_api_assets.asset_upload_base64_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_info;

CREATE TYPE beeper_desktop_api_info.info_retrieve_response AS ();
CREATE TYPE beeper_desktop_api_info.info_retrieve_response_app AS ();
CREATE TYPE beeper_desktop_api_info.info_retrieve_response_endpoint AS ();
CREATE TYPE beeper_desktop_api_info.info_retrieve_response_endpoint_oauth AS ();
CREATE TYPE beeper_desktop_api_info.info_retrieve_response_platform AS ();
CREATE TYPE beeper_desktop_api_info.info_retrieve_response_server AS ();