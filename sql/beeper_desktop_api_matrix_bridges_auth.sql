ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response
  ADD ATTRIBUTE flows beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_list_flows_response(
  flows beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    flows
  )::beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_list_flows_response_flow(
  id TEXT, description TEXT, name TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, description, name
  )::beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response_flow;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response
  ADD ATTRIBUTE login_ids TEXT[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_list_logins_response(
  login_ids TEXT[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    login_ids
  )::beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait,
  ADD ATTRIBUTE instructions TEXT,
  ADD ATTRIBUTE login_id TEXT,
  ADD ATTRIBUTE step_id TEXT,
  ADD ATTRIBUTE user_input beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input,
  ADD ATTRIBUTE cookies beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie,
  ADD ATTRIBUTE complete beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response(
  type TEXT,
  display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait DEFAULT NULL,
  instructions TEXT DEFAULT NULL,
  login_id TEXT DEFAULT NULL,
  step_id TEXT DEFAULT NULL,
  user_input beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input DEFAULT NULL,
  cookies beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie DEFAULT NULL,
  complete beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    display_and_wait,
    instructions,
    login_id,
    step_id,
    user_input,
    cookies,
    complete
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE data TEXT,
  ADD ATTRIBUTE image_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_display_and_wait(
  type TEXT, data TEXT DEFAULT NULL, image_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, data, image_url
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_display_and_wait;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field[],
  ADD ATTRIBUTE attachments beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_user_input(
  fields beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field[],
  attachments beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, attachments
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE default_value TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE options TEXT[],
  ADD ATTRIBUTE pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_user_input_field(
  id TEXT,
  name TEXT,
  type TEXT,
  default_value TEXT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  options TEXT[] DEFAULT NULL,
  pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, type, default_value, description, options, pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE filename TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE info beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_user_input_attachment(
  content TEXT,
  filename TEXT,
  type TEXT,
  info beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, filename, type, info
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info
  ADD ATTRIBUTE h DOUBLE PRECISION,
  ADD ATTRIBUTE mimetype TEXT,
  ADD ATTRIBUTE size DOUBLE PRECISION,
  ADD ATTRIBUTE w DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_user_input_attachment_info(
  h DOUBLE PRECISION DEFAULT NULL,
  mimetype TEXT DEFAULT NULL,
  size DOUBLE PRECISION DEFAULT NULL,
  w DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    h, mimetype, size, w
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_user_input_attachment_info;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field[],
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE extract_js TEXT,
  ADD ATTRIBUTE user_agent TEXT,
  ADD ATTRIBUTE wait_for_url_pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_cookie(
  fields beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field[],
  url TEXT,
  extract_js TEXT DEFAULT NULL,
  user_agent TEXT DEFAULT NULL,
  wait_for_url_pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, url, extract_js, user_agent, wait_for_url_pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE cookie_domain TEXT,
  ADD ATTRIBUTE request_url_regex TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_cookie_field(
  name TEXT,
  type TEXT,
  cookie_domain TEXT DEFAULT NULL,
  request_url_regex TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, type, cookie_domain, request_url_regex
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_cookie_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete
  ADD ATTRIBUTE user_login_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_start_login_response_complete(
  user_login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    user_login_id
  )::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response_complete;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait,
  ADD ATTRIBUTE instructions TEXT,
  ADD ATTRIBUTE login_id TEXT,
  ADD ATTRIBUTE step_id TEXT,
  ADD ATTRIBUTE user_input beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input,
  ADD ATTRIBUTE cookies beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie,
  ADD ATTRIBUTE complete beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response(
  type TEXT,
  display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait DEFAULT NULL,
  instructions TEXT DEFAULT NULL,
  login_id TEXT DEFAULT NULL,
  step_id TEXT DEFAULT NULL,
  user_input beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input DEFAULT NULL,
  cookies beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie DEFAULT NULL,
  complete beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    display_and_wait,
    instructions,
    login_id,
    step_id,
    user_input,
    cookies,
    complete
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE data TEXT,
  ADD ATTRIBUTE image_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_display_and_wait(
  type TEXT, data TEXT DEFAULT NULL, image_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, data, image_url
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_display_and_wait;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field[],
  ADD ATTRIBUTE attachments beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_user_input(
  fields beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field[],
  attachments beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, attachments
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE default_value TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE options TEXT[],
  ADD ATTRIBUTE pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_user_input_field(
  id TEXT,
  name TEXT,
  type TEXT,
  default_value TEXT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  options TEXT[] DEFAULT NULL,
  pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, type, default_value, description, options, pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE filename TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE info beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_user_input_attachment(
  content TEXT,
  filename TEXT,
  type TEXT,
  info beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, filename, type, info
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info
  ADD ATTRIBUTE h DOUBLE PRECISION,
  ADD ATTRIBUTE mimetype TEXT,
  ADD ATTRIBUTE size DOUBLE PRECISION,
  ADD ATTRIBUTE w DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_user_input_attachment_info(
  h DOUBLE PRECISION DEFAULT NULL,
  mimetype TEXT DEFAULT NULL,
  size DOUBLE PRECISION DEFAULT NULL,
  w DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    h, mimetype, size, w
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_user_input_attachment_info;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field[],
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE extract_js TEXT,
  ADD ATTRIBUTE user_agent TEXT,
  ADD ATTRIBUTE wait_for_url_pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_cookie(
  fields beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field[],
  url TEXT,
  extract_js TEXT DEFAULT NULL,
  user_agent TEXT DEFAULT NULL,
  wait_for_url_pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, url, extract_js, user_agent, wait_for_url_pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE cookie_domain TEXT,
  ADD ATTRIBUTE request_url_regex TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_cookie_field(
  name TEXT,
  type TEXT,
  cookie_domain TEXT DEFAULT NULL,
  request_url_regex TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, type, cookie_domain, request_url_regex
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_cookie_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete
  ADD ATTRIBUTE user_login_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_cookies_response_complete(
  user_login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    user_login_id
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response_complete;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait,
  ADD ATTRIBUTE instructions TEXT,
  ADD ATTRIBUTE login_id TEXT,
  ADD ATTRIBUTE step_id TEXT,
  ADD ATTRIBUTE user_input beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input,
  ADD ATTRIBUTE cookies beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie,
  ADD ATTRIBUTE complete beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response(
  type TEXT,
  display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait DEFAULT NULL,
  instructions TEXT DEFAULT NULL,
  login_id TEXT DEFAULT NULL,
  step_id TEXT DEFAULT NULL,
  user_input beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input DEFAULT NULL,
  cookies beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie DEFAULT NULL,
  complete beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    display_and_wait,
    instructions,
    login_id,
    step_id,
    user_input,
    cookies,
    complete
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE data TEXT,
  ADD ATTRIBUTE image_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_display_and_wait(
  type TEXT, data TEXT DEFAULT NULL, image_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, data, image_url
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_display_and_wait;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field[],
  ADD ATTRIBUTE attachments beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_user_input(
  fields beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field[],
  attachments beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, attachments
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE default_value TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE options TEXT[],
  ADD ATTRIBUTE pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_user_input_field(
  id TEXT,
  name TEXT,
  type TEXT,
  default_value TEXT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  options TEXT[] DEFAULT NULL,
  pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, type, default_value, description, options, pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE filename TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE info beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_user_input_attachment(
  content TEXT,
  filename TEXT,
  type TEXT,
  info beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, filename, type, info
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info
  ADD ATTRIBUTE h DOUBLE PRECISION,
  ADD ATTRIBUTE mimetype TEXT,
  ADD ATTRIBUTE size DOUBLE PRECISION,
  ADD ATTRIBUTE w DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_user_input_attachment_info(
  h DOUBLE PRECISION DEFAULT NULL,
  mimetype TEXT DEFAULT NULL,
  size DOUBLE PRECISION DEFAULT NULL,
  w DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    h, mimetype, size, w
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_user_input_attachment_info;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field[],
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE extract_js TEXT,
  ADD ATTRIBUTE user_agent TEXT,
  ADD ATTRIBUTE wait_for_url_pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_cookie(
  fields beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field[],
  url TEXT,
  extract_js TEXT DEFAULT NULL,
  user_agent TEXT DEFAULT NULL,
  wait_for_url_pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, url, extract_js, user_agent, wait_for_url_pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE cookie_domain TEXT,
  ADD ATTRIBUTE request_url_regex TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_cookie_field(
  name TEXT,
  type TEXT,
  cookie_domain TEXT DEFAULT NULL,
  request_url_regex TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, type, cookie_domain, request_url_regex
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_cookie_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete
  ADD ATTRIBUTE user_login_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_submit_user_input_response_complete(
  user_login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    user_login_id
  )::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response_complete;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait,
  ADD ATTRIBUTE instructions TEXT,
  ADD ATTRIBUTE login_id TEXT,
  ADD ATTRIBUTE step_id TEXT,
  ADD ATTRIBUTE user_input beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input,
  ADD ATTRIBUTE cookies beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie,
  ADD ATTRIBUTE complete beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response(
  type TEXT,
  display_and_wait beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait DEFAULT NULL,
  instructions TEXT DEFAULT NULL,
  login_id TEXT DEFAULT NULL,
  step_id TEXT DEFAULT NULL,
  user_input beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input DEFAULT NULL,
  cookies beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie DEFAULT NULL,
  complete beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    display_and_wait,
    instructions,
    login_id,
    step_id,
    user_input,
    cookies,
    complete
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE data TEXT,
  ADD ATTRIBUTE image_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_display_and_wait(
  type TEXT, data TEXT DEFAULT NULL, image_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, data, image_url
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_display_and_wait;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field[],
  ADD ATTRIBUTE attachments beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_user_input(
  fields beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field[],
  attachments beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment[] DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, attachments
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE default_value TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE options TEXT[],
  ADD ATTRIBUTE pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_user_input_field(
  id TEXT,
  name TEXT,
  type TEXT,
  default_value TEXT DEFAULT NULL,
  description TEXT DEFAULT NULL,
  options TEXT[] DEFAULT NULL,
  pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, type, default_value, description, options, pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE filename TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE info beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_user_input_attachment(
  content TEXT,
  filename TEXT,
  type TEXT,
  info beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, filename, type, info
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info
  ADD ATTRIBUTE h DOUBLE PRECISION,
  ADD ATTRIBUTE mimetype TEXT,
  ADD ATTRIBUTE size DOUBLE PRECISION,
  ADD ATTRIBUTE w DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_user_input_attachment_info(
  h DOUBLE PRECISION DEFAULT NULL,
  mimetype TEXT DEFAULT NULL,
  size DOUBLE PRECISION DEFAULT NULL,
  w DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    h, mimetype, size, w
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_user_input_attachment_info;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie
  ADD ATTRIBUTE fields beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field[],
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE extract_js TEXT,
  ADD ATTRIBUTE user_agent TEXT,
  ADD ATTRIBUTE wait_for_url_pattern TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_cookie(
  fields beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field[],
  url TEXT,
  extract_js TEXT DEFAULT NULL,
  user_agent TEXT DEFAULT NULL,
  wait_for_url_pattern TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    fields, url, extract_js, user_agent, wait_for_url_pattern
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE cookie_domain TEXT,
  ADD ATTRIBUTE request_url_regex TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_cookie_field(
  name TEXT,
  type TEXT,
  cookie_domain TEXT DEFAULT NULL,
  request_url_regex TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, type, cookie_domain, request_url_regex
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_cookie_field;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete
  ADD ATTRIBUTE user_login_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_wait_for_step_response_complete(
  user_login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    user_login_id
  )::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response_complete;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response
  ADD ATTRIBUTE bridge_bot TEXT,
  ADD ATTRIBUTE command_prefix TEXT,
  ADD ATTRIBUTE homeserver TEXT,
  ADD ATTRIBUTE login_flows beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow[],
  ADD ATTRIBUTE logins beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login[],
  ADD ATTRIBUTE network beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network,
  ADD ATTRIBUTE management_room TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response(
  bridge_bot TEXT,
  command_prefix TEXT,
  homeserver TEXT,
  login_flows beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow[],
  logins beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login[],
  network beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network,
  management_room TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    bridge_bot,
    command_prefix,
    homeserver,
    login_flows,
    logins,
    network,
    management_room
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response_login_flow(
  id TEXT, description TEXT, name TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, description, name
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_flow;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE profile beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile,
  ADD ATTRIBUTE state beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state,
  ADD ATTRIBUTE space_room TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response_login(
  id TEXT,
  name TEXT,
  profile beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile,
  state beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state,
  space_room TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, profile, state, space_room
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile
  ADD ATTRIBUTE avatar TEXT,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE phone TEXT,
  ADD ATTRIBUTE username TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response_login_profile(
  avatar TEXT DEFAULT NULL,
  email TEXT DEFAULT NULL,
  name TEXT DEFAULT NULL,
  phone TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    avatar, email, name, phone, username
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_profile;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state
  ADD ATTRIBUTE state_event TEXT,
  ADD ATTRIBUTE "timestamp" DOUBLE PRECISION,
  ADD ATTRIBUTE error TEXT,
  ADD ATTRIBUTE info JSONB,
  ADD ATTRIBUTE message TEXT,
  ADD ATTRIBUTE reason TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response_login_state(
  state_event TEXT,
  "timestamp" DOUBLE PRECISION,
  error TEXT DEFAULT NULL,
  info JSONB DEFAULT NULL,
  message TEXT DEFAULT NULL,
  reason TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    state_event, "timestamp", error, info, message, reason
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_login_state;
$$;

ALTER TYPE beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network
  ADD ATTRIBUTE beeper_bridge_type TEXT,
  ADD ATTRIBUTE displayname TEXT,
  ADD ATTRIBUTE network_icon TEXT,
  ADD ATTRIBUTE network_id TEXT,
  ADD ATTRIBUTE network_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.make_auth_whoami_response_network(
  beeper_bridge_type TEXT,
  displayname TEXT,
  network_icon TEXT,
  network_id TEXT,
  network_url TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    beeper_bridge_type, displayname, network_icon, network_id, network_url
  )::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response_network;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._list_flows(
  bridge_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.list_flows(
      bridge_id=bridge_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.list_flows(
  bridge_id TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_list_flows_response,
      beeper_desktop_api_matrix_bridges_auth._list_flows(bridge_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._list_logins(
  bridge_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.list_logins(
      bridge_id=bridge_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.list_logins(
  bridge_id TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_list_logins_response,
      beeper_desktop_api_matrix_bridges_auth._list_logins(bridge_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._logout(
  bridge_id TEXT, login_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.logout(
      bridge_id=bridge_id,
      login_id=login_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.logout(
  bridge_id TEXT, login_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_matrix_bridges_auth._logout(bridge_id, login_id);
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._start_login(
  bridge_id TEXT, flow_id TEXT, login_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.start_login(
      bridge_id=bridge_id,
      flow_id=flow_id,
      login_id=not_given if login_id is None else login_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.start_login(
  bridge_id TEXT, flow_id TEXT, login_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_start_login_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_start_login_response,
      beeper_desktop_api_matrix_bridges_auth._start_login(
        bridge_id, flow_id, login_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._submit_cookies(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT, body JSONB
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.submit_cookies(
      bridge_id=bridge_id,
      login_process_id=login_process_id,
      step_id=step_id,
      body=json.loads(body),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.submit_cookies(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT, body JSONB
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_submit_cookies_response,
      beeper_desktop_api_matrix_bridges_auth._submit_cookies(
        bridge_id, login_process_id, step_id, body
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._submit_user_input(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT, body JSONB
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json

  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.submit_user_input(
      bridge_id=bridge_id,
      login_process_id=login_process_id,
      step_id=step_id,
      body=json.loads(body),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.submit_user_input(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT, body JSONB
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_submit_user_input_response,
      beeper_desktop_api_matrix_bridges_auth._submit_user_input(
        bridge_id, login_process_id, step_id, body
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._wait_for_step(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.wait_for_step(
      bridge_id=bridge_id,
      login_process_id=login_process_id,
      step_id=step_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.wait_for_step(
  bridge_id TEXT, login_process_id TEXT, step_id TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_wait_for_step_response,
      beeper_desktop_api_matrix_bridges_auth._wait_for_step(
        bridge_id, login_process_id, step_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth._whoami(
  bridge_id TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.matrix.bridges.auth.with_raw_response.whoami(
      bridge_id=bridge_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_matrix_bridges_auth.whoami(
  bridge_id TEXT
)
RETURNS beeper_desktop_api_matrix_bridges_auth.auth_whoami_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_matrix_bridges_auth.auth_whoami_response,
      beeper_desktop_api_matrix_bridges_auth._whoami(bridge_id)
    );
  END;
$$;