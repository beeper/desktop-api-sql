# Beeper Desktop API PostgreSQL Extension

> [!NOTE]
>
> The Beeper Desktop API PostgreSQL Extension is currently **experimental** and we're excited for you to experiment with it!
>
> This extension has not yet been exhaustively tested in production environments and may be missing some features you'd expect in a stable release. As we continue development, there may be breaking changes that require updates to your code.
>
> **We'd love your feedback!** Please share any suggestions, bug reports, feature requests, or general thoughts by [filing an issue](https://www.github.com/beeper/desktop-api-sql/issues/new).

The Beeper Desktop API PostgreSQL Extension provides convenient access to the [Beeper Desktop REST API](https://developers.beeper.com/desktop-api/) from PostgreSQL.

The REST API documentation can be found on [developers.beeper.com](https://developers.beeper.com/desktop-api/).

## Installation

Clone the repository:

```sh
git clone git@github.com:beeper/desktop-api-sql.git
cd desktop-api-sql
```

Install the extension:

```sh
make install
```

Load it into the relevant database:

```sql
CREATE EXTENSION IF NOT EXISTS plpython3u; -- Dependency
CREATE EXTENSION beeper_desktop_api;
```

And install the Python SDK dependency:

```sh
# install from the production repo
pip install git+ssh://git@github.com/beeper/desktop-api-python.git
```

See [`./scripts/test`](./scripts/test) how to use a [Python virtual environment](https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments) if you prefer that instead.

Use [the troubleshooting section](#troubleshooting) if you encounter issues during or after installation.

## Requirements

This extension requires:

- PostgreSQL 14 or higher
- [PL/Python](https://www.postgresql.org/docs/current/plpython.html)
- Python 3.9 or higher
- The beeper_desktop_api Python package

## Usage

```sql
SELECT *
FROM beeper_desktop_api_chats.search(
  account_ids := ARRAY[
    'matrix', 'discordgo', 'local-whatsapp_ba_EvYDBBsZbRQAy3UOSWqG0LuTVkc'
  ],
  include_muted := TRUE,
  "limit" := 3,
  type := 'single'
);
```

## Client configuration

Configure the client by setting configuration parameters at the database level:

```sql
ALTER DATABASE my_database SET beeper_desktop_api.access_token = 'My Access Token';
```

> [!NOTE]
>
> `ALTER DATABASE` persistently alters the database, but doesn't take effect until the next session. To
> ephemerally modify the current session, use `SET beeper_desktop_api.access_token TO 'My Access Token';`.

See this table for the available configuration parameters:

| Parameter                         | Required | Default value              |
| --------------------------------- | -------- | -------------------------- |
| `beeper_desktop_api.access_token` | true     | -                          |
| `beeper_desktop_api.base_url`     | false    | `'http://localhost:23373'` |

## Requests and responses

To send a request to the Beeper Desktop API, call the relevant SQL function with values corresponding to the parameter types and `SELECT` the columns you need from the returned rows.

To construct [composite type](https://www.postgresql.org/docs/current/rowtypes.html) parameters, use the parameter type's provided `make_*` function. For example, `beeper_desktop_api_chats.update_params_draft` may be constructed like so:

```sql
beeper_desktop_api_chats.make_update_params_draft(
  text := 'text',
  attachments := $$
  {
    "foo": {
      "uploadID": "uploadID",
      "id": "id",
      "duration": 0,
      "fileName": "fileName",
      "mimeType": "mimeType",
      "size": {
        "height": 0,
        "width": 0
      },
      "type": "image"
    }
  }
  $$::JSONB
)
```

## Pagination

For Beeper Desktop API endpoints that return a paginated lists of results, the extension automatically fetches more pages as needed.

For example, the following query will make the minimum number of requests necessary to satisfy the `LIMIT`:

```sql
SELECT *
FROM beeper_desktop_api_messages.search(
  account_ids := ARRAY[
    'discordgo', 'local-whatsapp_ba_EvYDBBsZbRQAy3UOSWqG0LuTVkc'
  ],
  "limit" := 10,
  query := 'oauth'
)
LIMIT 200;
```

> [!IMPORTANT]
>
> Place your `LIMIT` as close to the paginated function call as possible. If the `LIMIT` is too far
> removed, then PostgreSQL may not [push down the condition](https://wiki.postgresql.org/wiki/Inlining_of_SQL_functions),
> causing all pages to be requested and buffered.

## Caching

Sending requests to the Beeper Desktop API for every SQL query can be slow. Combine [materialized views](https://www.postgresql.org/docs/current/rules-materializedviews.html) with [`pg_cron`](https://github.com/citusdata/pg_cron) for scheduled data pulls:

```sql
CREATE MATERIALIZED VIEW beeper_desktop_api_messages AS
SELECT *
FROM beeper_desktop_api_messages.search(
  account_ids := ARRAY[
    'discordgo', 'local-whatsapp_ba_EvYDBBsZbRQAy3UOSWqG0LuTVkc'
  ],
  "limit" := 10,
  query := 'oauth'
);

-- Refresh the view every 4 hours.
SELECT cron.schedule(
  'refresh-beeper-desktop-api-messages',
  '0 */4 * * *',
  'REFRESH MATERIALIZED VIEW CONCURRENTLY beeper_desktop_api_messages'
);
```

## Troubleshooting

### Installation

If you encounter an error such as:

```
Operation not permitted
```

Then run with `sudo`. If necessary, ensure your terminal has full disk access.

If you encounter an error such as:

```
make: pg_config: Command not found
```

Then ensure you have `pg_config` installed and in your `PATH`. If necessary, tell `make` where to find it:

```sh
PG_CONFIG=/path/to/pg_config make install
```

To install the extension in a custom prefix on PostgreSQL 18 or later, pass the `prefix` argument:

```sh
make install prefix=/usr/local/extras
```

You must also ensure that the prefix is included in the following [`postgresql.conf` parameters](https://www.postgresql.org/docs/current/config-setting.html#CONFIG-SETTING-CONFIGURATION-FILE):

```conf
extension_control_path = '/usr/local/extras/postgresql/share:$system'
dynamic_library_path   = '/usr/local/extras/postgresql/lib:$libdir'
```

### Loading

If you encounter an error such as:

```
ERROR: could not load library
```

Then ensure your Python installation is linked to the directory where PostgreSQL was looking for it. You can print out the directory of your Python installation with this command:

```sh
python3 -c "import sys; print(sys.prefix)"
```

## Semantic versioning

This package generally follows [SemVer](https://semver.org/spec/v2.0.0.html) conventions, though certain backwards-incompatible changes may be released as minor versions:

1. Changes to library internals which are technically public but not intended or documented for external use. _(Please open a GitHub issue to let us know if you are relying on such internals.)_
2. Changes that we do not expect to impact the vast majority of users in practice.

We take backwards-compatibility seriously and work hard to ensure you can rely on a smooth upgrade experience.

We are keen for your feedback; please open an [issue](https://www.github.com/beeper/desktop-api-sql/issues) with questions, bugs, or suggestions.
