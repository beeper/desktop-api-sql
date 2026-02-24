ALTER TYPE beeper_desktop_api_chats_reminders.reminder
  ADD ATTRIBUTE remind_at_ms DOUBLE PRECISION,
  ADD ATTRIBUTE dismiss_on_incoming_message BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_reminders.make_reminder(
  remind_at_ms DOUBLE PRECISION,
  dismiss_on_incoming_message BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats_reminders.reminder
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    remind_at_ms, dismiss_on_incoming_message
  )::beeper_desktop_api_chats_reminders.reminder;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_reminders._create(
  chat_id TEXT, reminder beeper_desktop_api_chats_reminders.reminder
)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__beeper_desktop_api_context__"].client.chats.reminders.create(
      chat_id=chat_id,
      reminder=GD["__beeper_desktop_api_context__"].strip_none(reminder),
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_reminders.create(
  chat_id TEXT, reminder beeper_desktop_api_chats_reminders.reminder
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    PERFORM beeper_desktop_api_chats_reminders._create(chat_id, reminder);
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_reminders._delete(
  chat_id TEXT
)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  GD["__beeper_desktop_api_context__"].client.chats.reminders.delete(
      chat_id=chat_id,
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_reminders.delete(
  chat_id TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    PERFORM beeper_desktop_api_chats_reminders._delete(chat_id);
  END;
$$;