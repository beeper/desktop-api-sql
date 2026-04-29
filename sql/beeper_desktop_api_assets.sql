ALTER TYPE beeper_desktop_api_assets.asset_download_response
  ADD ATTRIBUTE error TEXT, ADD ATTRIBUTE srcURL TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.make_asset_download_response(
  error TEXT DEFAULT NULL, srcURL TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_assets.asset_download_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(error, srcURL)::beeper_desktop_api_assets.asset_download_response;
$$;

ALTER TYPE beeper_desktop_api_assets.asset_upload_response
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE error TEXT,
  ADD ATTRIBUTE fileName TEXT,
  ADD ATTRIBUTE fileSize DOUBLE PRECISION,
  ADD ATTRIBUTE height DOUBLE PRECISION,
  ADD ATTRIBUTE mimeType TEXT,
  ADD ATTRIBUTE srcURL TEXT,
  ADD ATTRIBUTE uploadID TEXT,
  ADD ATTRIBUTE width DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.make_asset_upload_response(
  duration DOUBLE PRECISION DEFAULT NULL,
  error TEXT DEFAULT NULL,
  fileName TEXT DEFAULT NULL,
  fileSize DOUBLE PRECISION DEFAULT NULL,
  height DOUBLE PRECISION DEFAULT NULL,
  mimeType TEXT DEFAULT NULL,
  srcURL TEXT DEFAULT NULL,
  uploadID TEXT DEFAULT NULL,
  width DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_assets.asset_upload_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    duration,
    error,
    fileName,
    fileSize,
    height,
    mimeType,
    srcURL,
    uploadID,
    width
  )::beeper_desktop_api_assets.asset_upload_response;
$$;

ALTER TYPE beeper_desktop_api_assets.asset_upload_base64_response
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE error TEXT,
  ADD ATTRIBUTE fileName TEXT,
  ADD ATTRIBUTE fileSize DOUBLE PRECISION,
  ADD ATTRIBUTE height DOUBLE PRECISION,
  ADD ATTRIBUTE mimeType TEXT,
  ADD ATTRIBUTE srcURL TEXT,
  ADD ATTRIBUTE uploadID TEXT,
  ADD ATTRIBUTE width DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.make_asset_upload_base64_response(
  duration DOUBLE PRECISION DEFAULT NULL,
  error TEXT DEFAULT NULL,
  fileName TEXT DEFAULT NULL,
  fileSize DOUBLE PRECISION DEFAULT NULL,
  height DOUBLE PRECISION DEFAULT NULL,
  mimeType TEXT DEFAULT NULL,
  srcURL TEXT DEFAULT NULL,
  uploadID TEXT DEFAULT NULL,
  width DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_assets.asset_upload_base64_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    duration,
    error,
    fileName,
    fileSize,
    height,
    mimeType,
    srcURL,
    uploadID,
    width
  )::beeper_desktop_api_assets.asset_upload_base64_response;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets._download(url TEXT)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.assets.with_raw_response.download(
      url=url,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.download(url TEXT)
RETURNS beeper_desktop_api_assets.asset_download_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_assets.asset_download_response,
      beeper_desktop_api_assets._download(url)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets._serve(url TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.assets.with_raw_response.serve(
      url=url,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.serve(url TEXT)
RETURNS BYTEA
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::BYTEA, beeper_desktop_api_assets._serve(url)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets._upload(
  file TEXT, file_name TEXT DEFAULT NULL, mime_type TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.assets.with_raw_response.upload(
      file=file,
      file_name=not_given if file_name is None else file_name,
      mime_type=not_given if mime_type is None else mime_type,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.upload(
  file TEXT, file_name TEXT DEFAULT NULL, mime_type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_assets.asset_upload_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_assets.asset_upload_response,
      beeper_desktop_api_assets._upload(file, file_name, mime_type)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets._upload_base64(
  content TEXT, file_name TEXT DEFAULT NULL, mime_type TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.assets.with_raw_response.upload_base64(
      content=content,
      file_name=not_given if file_name is None else file_name,
      mime_type=not_given if mime_type is None else mime_type,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_assets.upload_base64(
  content TEXT, file_name TEXT DEFAULT NULL, mime_type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_assets.asset_upload_base64_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_assets.asset_upload_base64_response,
      beeper_desktop_api_assets._upload_base64(content, file_name, mime_type)
    );
  END;
$$;