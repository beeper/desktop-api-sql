ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response
  ADD ATTRIBUTE appState beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_mark_backed_up_response(
  appState beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    appState
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state
  ADD ATTRIBUTE e2ee beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee,
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE matrix beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix,
  ADD ATTRIBUTE verification beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_mark_backed_up_response_app_state(
  e2ee beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee,
  state TEXT,
  matrix beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix DEFAULT NULL,
  verification beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    e2ee, state, matrix, verification
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee
  ADD ATTRIBUTE crossSigning BOOLEAN,
  ADD ATTRIBUTE firstSyncDone BOOLEAN,
  ADD ATTRIBUTE hasBackedUpCode BOOLEAN,
  ADD ATTRIBUTE initialized BOOLEAN,
  ADD ATTRIBUTE keyBackup BOOLEAN,
  ADD ATTRIBUTE secrets beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret,
  ADD ATTRIBUTE secretStorage BOOLEAN,
  ADD ATTRIBUTE verified BOOLEAN,
  ADD ATTRIBUTE recoveryCodeGeneratedAt DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_mark_backed_up_response_app_state_e2ee(
  crossSigning BOOLEAN,
  firstSyncDone BOOLEAN,
  hasBackedUpCode BOOLEAN,
  initialized BOOLEAN,
  keyBackup BOOLEAN,
  secrets beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret,
  secretStorage BOOLEAN,
  verified BOOLEAN,
  recoveryCodeGeneratedAt DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    crossSigning,
    firstSyncDone,
    hasBackedUpCode,
    initialized,
    keyBackup,
    secrets,
    secretStorage,
    verified,
    recoveryCodeGeneratedAt
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret
  ADD ATTRIBUTE masterKey BOOLEAN,
  ADD ATTRIBUTE megolmBackupKey BOOLEAN,
  ADD ATTRIBUTE recoveryCode BOOLEAN,
  ADD ATTRIBUTE selfSigningKey BOOLEAN,
  ADD ATTRIBUTE userSigningKey BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.mke_recovery_code_mark_backed_up_response_app_state_e2ee_secret(
  masterKey BOOLEAN,
  megolmBackupKey BOOLEAN,
  recoveryCode BOOLEAN,
  selfSigningKey BOOLEAN,
  userSigningKey BOOLEAN
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    masterKey, megolmBackupKey, recoveryCode, selfSigningKey, userSigningKey
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_e2ee_secret;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix
  ADD ATTRIBUTE deviceID TEXT,
  ADD ATTRIBUTE homeserver TEXT,
  ADD ATTRIBUTE userID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_mark_backed_up_response_app_state_matrix(
  deviceID TEXT, homeserver TEXT, userID TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    deviceID, homeserver, userID
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_matrix;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification
  ADD ATTRIBUTE availableActions TEXT[],
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE error beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error,
  ADD ATTRIBUTE "from" TEXT,
  ADD ATTRIBUTE fromDevice TEXT,
  ADD ATTRIBUTE otherDevice TEXT,
  ADD ATTRIBUTE qrData TEXT,
  ADD ATTRIBUTE sas beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa,
  ADD ATTRIBUTE supportsSAS BOOLEAN,
  ADD ATTRIBUTE supportsScanQRCode BOOLEAN,
  ADD ATTRIBUTE verificationID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.mke_rcovery_code_mark_backed_up_response_app_state_verification(
  availableActions TEXT[],
  state TEXT,
  error beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error DEFAULT NULL,
  "from" TEXT DEFAULT NULL,
  fromDevice TEXT DEFAULT NULL,
  otherDevice TEXT DEFAULT NULL,
  qrData TEXT DEFAULT NULL,
  sas beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa DEFAULT NULL,
  supportsSAS BOOLEAN DEFAULT NULL,
  supportsScanQRCode BOOLEAN DEFAULT NULL,
  verificationID TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    availableActions,
    state,
    error,
    "from",
    fromDevice,
    otherDevice,
    qrData,
    sas,
    supportsSAS,
    supportsScanQRCode,
    verificationID
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error
  ADD ATTRIBUTE code TEXT, ADD ATTRIBUTE reason TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.mke_rcovery_cde_mrk_bcked_up_rsponse_app_stte_vrification_error(
  code TEXT, reason TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    code, reason
  )::beeper_desktop_api_app_e2ee_recovery_code.rcovery_cde_mrk_backed_up_response_app_state_verification_error;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa
  ADD ATTRIBUTE decimals TEXT, ADD ATTRIBUTE emojis TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.mke_rcovery_cde_mrk_bcked_up_response_app_state_verification_sa(
  decimals TEXT, emojis TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    decimals, emojis
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response_app_state_verification_sa;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response
  ADD ATTRIBUTE appState beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response(
  appState beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    appState
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state
  ADD ATTRIBUTE e2ee beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee,
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE matrix beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix,
  ADD ATTRIBUTE verification beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state(
  e2ee beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee,
  state TEXT,
  matrix beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix DEFAULT NULL,
  verification beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    e2ee, state, matrix, verification
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee
  ADD ATTRIBUTE crossSigning BOOLEAN,
  ADD ATTRIBUTE firstSyncDone BOOLEAN,
  ADD ATTRIBUTE hasBackedUpCode BOOLEAN,
  ADD ATTRIBUTE initialized BOOLEAN,
  ADD ATTRIBUTE keyBackup BOOLEAN,
  ADD ATTRIBUTE secrets beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret,
  ADD ATTRIBUTE secretStorage BOOLEAN,
  ADD ATTRIBUTE verified BOOLEAN,
  ADD ATTRIBUTE recoveryCodeGeneratedAt DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_e2ee(
  crossSigning BOOLEAN,
  firstSyncDone BOOLEAN,
  hasBackedUpCode BOOLEAN,
  initialized BOOLEAN,
  keyBackup BOOLEAN,
  secrets beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret,
  secretStorage BOOLEAN,
  verified BOOLEAN,
  recoveryCodeGeneratedAt DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    crossSigning,
    firstSyncDone,
    hasBackedUpCode,
    initialized,
    keyBackup,
    secrets,
    secretStorage,
    verified,
    recoveryCodeGeneratedAt
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret
  ADD ATTRIBUTE masterKey BOOLEAN,
  ADD ATTRIBUTE megolmBackupKey BOOLEAN,
  ADD ATTRIBUTE recoveryCode BOOLEAN,
  ADD ATTRIBUTE selfSigningKey BOOLEAN,
  ADD ATTRIBUTE userSigningKey BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_e2ee_secret(
  masterKey BOOLEAN,
  megolmBackupKey BOOLEAN,
  recoveryCode BOOLEAN,
  selfSigningKey BOOLEAN,
  userSigningKey BOOLEAN
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    masterKey, megolmBackupKey, recoveryCode, selfSigningKey, userSigningKey
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_e2ee_secret;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix
  ADD ATTRIBUTE deviceID TEXT,
  ADD ATTRIBUTE homeserver TEXT,
  ADD ATTRIBUTE userID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_matrix(
  deviceID TEXT, homeserver TEXT, userID TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    deviceID, homeserver, userID
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_matrix;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification
  ADD ATTRIBUTE availableActions TEXT[],
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE error beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error,
  ADD ATTRIBUTE "from" TEXT,
  ADD ATTRIBUTE fromDevice TEXT,
  ADD ATTRIBUTE otherDevice TEXT,
  ADD ATTRIBUTE qrData TEXT,
  ADD ATTRIBUTE sas beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa,
  ADD ATTRIBUTE supportsSAS BOOLEAN,
  ADD ATTRIBUTE supportsScanQRCode BOOLEAN,
  ADD ATTRIBUTE verificationID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_verification(
  availableActions TEXT[],
  state TEXT,
  error beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error DEFAULT NULL,
  "from" TEXT DEFAULT NULL,
  fromDevice TEXT DEFAULT NULL,
  otherDevice TEXT DEFAULT NULL,
  qrData TEXT DEFAULT NULL,
  sas beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa DEFAULT NULL,
  supportsSAS BOOLEAN DEFAULT NULL,
  supportsScanQRCode BOOLEAN DEFAULT NULL,
  verificationID TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    availableActions,
    state,
    error,
    "from",
    fromDevice,
    otherDevice,
    qrData,
    sas,
    supportsSAS,
    supportsScanQRCode,
    verificationID
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error
  ADD ATTRIBUTE code TEXT, ADD ATTRIBUTE reason TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_verification_error(
  code TEXT, reason TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    code, reason
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_error;
$$;

ALTER TYPE beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa
  ADD ATTRIBUTE decimals TEXT, ADD ATTRIBUTE emojis TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.make_recovery_code_verify_response_app_state_verification_sa(
  decimals TEXT, emojis TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    decimals, emojis
  )::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response_app_state_verification_sa;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code._mark_backed_up(

)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.app.e2ee.recovery_code.with_raw_response.mark_backed_up()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.mark_backed_up(

)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_mark_backed_up_response,
      beeper_desktop_api_app_e2ee_recovery_code._mark_backed_up()
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code._verify(
  recovery_code TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.app.e2ee.recovery_code.with_raw_response.verify(
      recovery_code=recovery_code,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_app_e2ee_recovery_code.verify(
  recovery_code TEXT
)
RETURNS beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_app_e2ee_recovery_code.recovery_code_verify_response,
      beeper_desktop_api_app_e2ee_recovery_code._verify(recovery_code)
    );
  END;
$$;