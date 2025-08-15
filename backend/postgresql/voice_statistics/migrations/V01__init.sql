CREATE SCHEMA IF NOT EXISTS voice_statistics;

CREATE TABLE IF NOT EXISTS voice_statistics.stop_words (
    word TEXT PRIMARY KEY
);

CREATE TYPE voice_statistics.request_type AS ENUM (
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

CREATE TABLE IF NOT EXISTS voice_statistics.words_count_by_word_and_type (
    word TEXT NOT NULL,
    type voice_statistics.request_type NOT NULL,
    count BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY(word, type)
);


CREATE TABLE IF NOT EXISTS voice_statistics.words_count_by_type (
    type voice_statistics.request_type NOT NULL,
    count BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY(type)
);
INSERT INTO voice_statistics.words_count_by_type(type)
VALUES
    ('accept'),
    ('cancel'),
    ('voice_message'),
    ('voice_wish'),
    ('call_passenger'),
    ('create_route'),
    ('choose_route'),
    ('business'),
    ('home'),
    ('find'),
    ('change_rate')
ON CONFLICT DO NOTHING;


CREATE OR REPLACE PROCEDURE voice_statistics.update_statistics(
    p_words TEXT[],
    p_request_type voice_statistics.request_type
) AS $$
DECLARE
    filtered_words TEXT[];
BEGIN
    -- Filter out stop words with a single query
    SELECT array_agg(word)
    INTO filtered_words
    FROM unnest(p_words) AS word
    WHERE word NOT IN (SELECT word FROM voice_statistics.stop_words);

    -- Exit early if no words left after filtering
    IF filtered_words IS NULL OR array_length(filtered_words, 1) = 0 THEN
        RETURN;
    END IF;

    -- Update words_count_by_word_and_type with a single bulk operation
    INSERT INTO voice_statistics.words_count_by_word_and_type (word, type, count)
    SELECT word, update_statistics.p_request_type, 1
    FROM unnest(filtered_words) AS word
    ON CONFLICT (word, type) DO UPDATE
    SET count = words_count_by_word_and_type.count + 1;

    -- Update words_count_by_type with a single operation
    -- (We multiply by the count of filtered words to do this in one operation)
    UPDATE voice_statistics.words_count_by_type
    SET count = words_count_by_type.count + array_length(filtered_words, 1)
    WHERE words_count_by_type.type = p_request_type;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE voice_statistics.count_in_request_type AS (
    type voice_statistics.request_type,
    count INTEGER
);

CREATE TYPE voice_statistics.word_statistics AS (
    word TEXT,
    count_by_types voice_statistics.count_in_request_type[]
);

CREATE OR REPLACE FUNCTION voice_statistics.get_words_statistics(
    p_words TEXT[]
) RETURNS SETOF voice_statistics.word_statistics AS $$
BEGIN
    RETURN QUERY
    SELECT
        in_word,
        array_agg(ROW(wcbywt.type, wcbywt.count)::voice_statistics.count_in_request_type)
    FROM unnest(p_words) AS in_word
    JOIN voice_statistics.words_count_by_word_and_type AS wcbywt
        ON wcbywt.word = in_word
    GROUP BY in_word;
END;
$$ LANGUAGE plpgsql;
