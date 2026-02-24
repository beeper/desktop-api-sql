ALTER TYPE beeper_desktop_api_accounts_contacts.contact_search_response
  ADD ATTRIBUTE items beeper_desktop_api.user[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts.make_contact_search_response(
  items beeper_desktop_api.user[]
)
RETURNS beeper_desktop_api_accounts_contacts.contact_search_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    items
  )::beeper_desktop_api_accounts_contacts.contact_search_response;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts._list_first_page_py(
  account_id TEXT,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client.accounts.contacts.list(
      account_id=account_id,
      cursor=not_given if cursor is None else cursor,
      direction=not_given if direction is None else direction,
      limit=not_given if limit is None else limit,
      query=not_given if query is None else query,
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

-- A simpler wrapper around `beeper_desktop_api_accounts_contacts._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts._list_first_page(
  account_id TEXT,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_accounts_contacts._list_first_page_py(
      account_id, cursor, direction, "limit", query
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts._list_next_page(request_options JSONB)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from beeper_desktop_api.types.shared import User
  from beeper_desktop_api.pagination import SyncCursorSearch
  from beeper_desktop_api._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client._request_api_list(
    model=User,
    page=SyncCursorSearch[User],
    options=FinalRequestOptions.construct(**json.loads(request_options))
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts.list(
  account_id TEXT,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL
)
RETURNS SETOF beeper_desktop_api.user
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM beeper_desktop_api_accounts_contacts._list_first_page(
      account_id, cursor, direction, "limit", query
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN beeper_desktop_api_accounts_contacts._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::beeper_desktop_api.user, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts._search(
  account_id TEXT, query TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.accounts.contacts.with_raw_response.search(
      account_id=account_id,
      query=query,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_accounts_contacts.search(
  account_id TEXT, query TEXT
)
RETURNS beeper_desktop_api_accounts_contacts.contact_search_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_accounts_contacts.contact_search_response,
      beeper_desktop_api_accounts_contacts._search(account_id, query)
    );
  END;
$$;