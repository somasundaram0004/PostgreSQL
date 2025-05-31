CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE ROLE user_read_only WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;



GRANT user_read_only TO pg_read_all_data, pg_read_all_settings, pg_read_all_stats, pg_monitor, pg_read_server_files ;

-- Role: vault
-- DROP ROLE IF EXISTS vault;

CREATE ROLE vault WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:Mr/GPDcLkTtbnDa5AW+FeA==$9/dL7rxBxB4uaj0kkXt4eeJFr+OE6QQYEkEzRY9xCcQ=:rctaoDVVRV/cCkmC7Hr5sQrph7TpofUdiWaJ5WYKVD0=';

GRANT pg_checkpoint, pg_create_subscription, pg_execute_server_program, pg_maintain, pg_monitor, pg_use_reserved_connections TO vault;

CREATE DATABASE vault
    WITH
    OWNER = vault
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE vault_kv_store (
  parent_path TEXT COLLATE "C" NOT NULL,
  path        TEXT COLLATE "C",
  key         TEXT COLLATE "C",
  value       BYTEA,
  CONSTRAINT pkey PRIMARY KEY (path, key)
);

CREATE INDEX parent_path_idx ON vault_kv_store (parent_path);

CREATE TABLE vault_ha_locks (
  ha_key                                      TEXT COLLATE "C" NOT NULL,
  ha_identity                                 TEXT COLLATE "C" NOT NULL,
  ha_value                                    TEXT COLLATE "C",
  valid_until                                 TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT ha_key PRIMARY KEY (ha_key)
);
CREATE FUNCTION vault_kv_put(_parent_path TEXT, _path TEXT, _key TEXT, _value BYTEA) RETURNS VOID AS
$$
BEGIN
    LOOP
        -- first try to update the key
        UPDATE vault_kv_store
          SET (parent_path, path, key, value) = (_parent_path, _path, _key, _value)
          WHERE _path = path AND key = _key;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO vault_kv_store (parent_path, path, key, value)
              VALUES (_parent_path, _path, _key, _value);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- Do nothing, and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$
LANGUAGE plpgsql;
