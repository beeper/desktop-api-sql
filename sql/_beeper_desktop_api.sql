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

CREATE TYPE beeper_desktop_api.app_state_snapshot AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_e2ee AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_matrix AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_verification AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_verification_error AS ();
CREATE TYPE beeper_desktop_api.app_state_snapshot_verification_sa AS ();
CREATE TYPE beeper_desktop_api.attachment AS ();
CREATE TYPE beeper_desktop_api.attachment_size AS ();
CREATE TYPE beeper_desktop_api.attachment_transcription AS ();
CREATE TYPE beeper_desktop_api.error AS ();
CREATE TYPE beeper_desktop_api.message AS ();
CREATE TYPE beeper_desktop_api.message_link AS ();
CREATE TYPE beeper_desktop_api.message_link_img_size AS ();
CREATE TYPE beeper_desktop_api.message_send_status AS ();
CREATE TYPE beeper_desktop_api.reaction AS ();
CREATE TYPE beeper_desktop_api.user AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api;

CREATE TYPE beeper_desktop_api.client_focus_response AS ();
CREATE TYPE beeper_desktop_api.client_search_response AS ();
CREATE TYPE beeper_desktop_api.client_search_response_result AS ();
CREATE TYPE beeper_desktop_api.client_search_response_result_message AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app;

CREATE TYPE beeper_desktop_api_app.login_registration_required_response AS ();
CREATE TYPE beeper_desktop_api_app.login_registration_required_response_copy AS ();
CREATE TYPE beeper_desktop_api_app.login_response AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.login_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app.login_response_desktop_api AS ();
CREATE TYPE beeper_desktop_api_app.login_response_matrix AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_desktop_api AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_matrix AS ();
CREATE TYPE beeper_desktop_api_app.login_response_output_copy AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.recovery_code_reset_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.start_verification_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.state_mutation_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_e2ee AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_matrix AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_verification AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_verification_error AS ();
CREATE TYPE beeper_desktop_api_app.app_status_response_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_login;

CREATE TYPE beeper_desktop_api_app_login.login_register_response AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_desktop_api AS ();
CREATE TYPE beeper_desktop_api_app_login.login_register_response_matrix AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_desktop_api AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_matrix AS ();
CREATE TYPE beeper_desktop_api_app_login.login_response_response_copy AS ();
CREATE TYPE beeper_desktop_api_app_login.login_start_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_e2ee_recovery_code;

CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_e2ee_recovery_code_reset;

CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_create_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_recovery_code_reset.reset_confirm_response_app_state_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_e2ee_verification;

CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_create_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_accept_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification.verification_cancel_response_app_state_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_e2ee_verification_qr;

CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_confirm_scanned_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_qr.qr_scan_response_app_state_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_app_e2ee_verification_sas;

CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_confirm_response_app_state_verification_sa AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_e2ee AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_e2ee_secret AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_matrix AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_verification AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_verification_error AS ();
CREATE TYPE beeper_desktop_api_app_e2ee_verification_sas.sa_start_response_app_state_verification_sa AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_accounts;

CREATE TYPE beeper_desktop_api_accounts.account AS ();
CREATE TYPE beeper_desktop_api_accounts.account_bridge AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_accounts_contacts;

CREATE TYPE beeper_desktop_api_accounts_contacts.contact_search_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_bridges;

CREATE TYPE beeper_desktop_api_bridges.bridge_availability AS ();
CREATE TYPE beeper_desktop_api_bridges.bridge_availability_bridge AS ();
CREATE TYPE beeper_desktop_api_bridges.bridge_list_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_users;

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_users_account_data;

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_rooms;

CREATE TYPE beeper_desktop_api_matrix_rooms.room_create_response AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms.room_join_response AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms.create_params_initial_state AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms.create_params_invite_3pid AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms.join_params_third_party_signed AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_rooms_account_data;

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_rooms_state;

CREATE TYPE beeper_desktop_api_matrix_rooms_state.state_list_response AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms_state.state_list_response_unsigned AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_rooms_events;

CREATE TYPE beeper_desktop_api_matrix_rooms_events.event_retrieve_response AS ();
CREATE TYPE beeper_desktop_api_matrix_rooms_events.event_retrieve_response_unsigned AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_bridges_auth;

CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_bridges_contacts;

CREATE TYPE beeper_desktop_api_matrix_bridges_contacts.contact_list_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_contacts.contact_list_response_contact AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_bridges_users;

CREATE TYPE beeper_desktop_api_matrix_bridges_users.user_resolve_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_users.user_search_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_users.user_search_response_result AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_bridges_rooms;

CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.room_create_dm_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.room_create_group_response AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_avatar AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_disappear AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_name AS ();
CREATE TYPE beeper_desktop_api_matrix_bridges_rooms.create_group_params_topic AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_matrix_bridges_capabilities;

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats;

CREATE TYPE beeper_desktop_api_chats.chat AS ();
CREATE TYPE beeper_desktop_api_chats.chat_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_participant_item AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_message_request AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_participant_action AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_state AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_state_avatar AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_state_description AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_state_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_capability_state_title AS ();
CREATE TYPE beeper_desktop_api_chats.chat_draft AS ();
CREATE TYPE beeper_desktop_api_chats.chat_reminder AS ();
CREATE TYPE beeper_desktop_api_chats.chat_snooze AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_participant_item AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_message_request AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_participant_action AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_state AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_state_avatar AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_state_description AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_capability_state_title AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_draft AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_reminder AS ();
CREATE TYPE beeper_desktop_api_chats.chat_create_response_snooze AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_participant_item AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_message_request AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_participant_action AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_state AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_state_avatar AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_state_description AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_capability_state_title AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_draft AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_reminder AS ();
CREATE TYPE beeper_desktop_api_chats.chat_list_response_snooze AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_participant AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_participant_item AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_message_request AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_participant_action AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_state AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_state_avatar AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_state_description AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_capability_state_title AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_draft AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_reminder AS ();
CREATE TYPE beeper_desktop_api_chats.chat_start_response_snooze AS ();
CREATE TYPE beeper_desktop_api_chats.update_params_draft AS ();
CREATE TYPE beeper_desktop_api_chats.start_params_user AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats_reminders;

CREATE TYPE beeper_desktop_api_chats_reminders.create_params_reminder AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_chats_messages_reactions;

CREATE TYPE beeper_desktop_api_chats_messages_reactions.reaction_delete_response AS ();
CREATE TYPE beeper_desktop_api_chats_messages_reactions.reaction_add_response AS ();

CREATE SCHEMA IF NOT EXISTS beeper_desktop_api_messages;

CREATE TYPE beeper_desktop_api_messages.message_update_response AS ();
CREATE TYPE beeper_desktop_api_messages.message_update_response_link AS ();
CREATE TYPE beeper_desktop_api_messages.message_update_response_link_img_size AS ();
CREATE TYPE beeper_desktop_api_messages.message_update_response_send_status AS ();
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