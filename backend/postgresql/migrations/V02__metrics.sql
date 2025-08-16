CREATE SCHEMA IF NOT EXISTS metrics;

CREATE TYPE metrics.request_type AS ENUM (
    'accept',
    'cancel',
    'voice_message',
    'voice_wish',
    'call_passenger',
    'create_route',
    'choose_route',
    'business',
    'home',
    'find',
    'change_rate'
);

CREATE TABLE IF NOT EXISTS metrics.last_requests (
    user_id TEXT PRIMARY KEY,
    type metrics.request_type,
    request_ts TIMESTAMPTZ NOT NULL
);


CREATE TYPE metrics.counter_category AS ENUM (
    'cancellations',
    'repetitions',
    'fallbacks'
);
CREATE TABLE IF NOT EXISTS metrics.counters (
    name metrics.counter_category PRIMARY KEY,
    value BIGINT NOT NULL DEFAULT 0
);
INSERT INTO metrics.counters (name)
VALUES
    ('cancellations'),
    ('repetitions'),
    ('fallbacks')
ON CONFLICT DO NOTHING;


CREATE TABLE IF NOT EXISTS metrics.retention_stats (
    user_id TEXT PRIMARY KEY,
    total_requests INTEGER NOT NULL DEFAULT 0,
    first_request_ts TIMESTAMPTZ NOT NULL,
    third_request_ts TIMESTAMPTZ
);
CREATE OR REPLACE PROCEDURE metrics.update_retention_stats(
    p_user_id TEXT,
    p_now TIMESTAMPTZ
) AS $$
BEGIN
    INSERT INTO metrics.retention_stats AS rs
        (user_id, total_requests, first_request_ts)
    VALUES (p_user_id, 1, p_now)
    ON CONFLICT (user_id) DO UPDATE SET
        total_requests = rs.total_requests + 1,
        third_request_ts = CASE WHEN rs.total_requests = 2 THEN p_now ELSE rs.third_request_ts END;
END;
$$ LANGUAGE plpgsql;


CREATE TYPE metrics.timing_category AS ENUM (
    'create_route',
    'business',
    'order_deciding'
);
CREATE TABLE IF NOT EXISTS metrics.timings (
    category metrics.timing_category PRIMARY KEY,
    sum_s DOUBLE PRECISION NOT NULL DEFAULT 0,
    count BIGINT NOT NULL DEFAULT 0
);
INSERT INTO metrics.timings (category)
VALUES
    ('create_route'),
    ('business'),
    ('order_deciding')
ON CONFLICT DO NOTHING;


CREATE TABLE IF NOT EXISTS metrics.requests_count_by_session (
    session_id TEXT,
    type metrics.request_type,
    user_id TEXT,
    count INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(session_id, type)
);
CREATE OR REPLACE PROCEDURE metrics.update_requests_stats(
    p_session_id TEXT,
    p_user_id TEXT,
    p_request_type metrics.request_type
) AS $$
BEGIN
    INSERT INTO metrics.requests_count_by_session AS rcbs
        (session_id, type, user_id, count)
    VALUES (p_session_id, p_request_type, p_user_id, 1)
    ON CONFLICT (session_id, type) DO UPDATE SET
        count = rcbs.count + 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE metrics.register_request(
    p_session_id TEXT,
    p_user_id TEXT,
    p_request_type metrics.request_type,
    p_now TIMESTAMPTZ,
    p_duration_s DOUBLE PRECISION
) AS $$
DECLARE
    request_timing metrics.timing_category;
BEGIN
    IF p_request_type IS NULL THEN
        RETURN;
    END IF;

    INSERT INTO metrics.last_requests AS lr (user_id, type, request_ts)
    VALUES (p_user_id, p_request_type, p_now)
    ON CONFLICT (user_id) DO UPDATE SET
        type = EXCLUDED.type,
        request_ts = EXCLUDED.request_ts;

    CALL metrics.update_retention_stats(p_user_id, p_now);

    SELECT CASE
        WHEN p_request_type = 'create_route' THEN 'create_route'::metrics.timing_category
        WHEN p_request_type = 'business' THEN 'business'::metrics.timing_category
        WHEN p_request_type = 'accept' THEN 'order_deciding'::metrics.timing_category
        WHEN p_request_type = 'cancel' THEN 'order_deciding'::metrics.timing_category
        ELSE NULL END
    INTO request_timing;
    IF request_timing IS NOT NULL THEN
        UPDATE metrics.timings SET
            sum_s = sum_s + p_duration_s,
            count = count + 1
        WHERE category = request_timing;
    END IF;

    CALL metrics.update_requests_stats(p_session_id, p_user_id, p_request_type);
END;
$$ LANGUAGE plpgsql;
