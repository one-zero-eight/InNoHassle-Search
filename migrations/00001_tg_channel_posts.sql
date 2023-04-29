-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS telegram_channel_post (
    id               int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    channel_name     text NOT NULL,
    channel_username text NOT NULL,
    message_id       int  NOT NULL,
    message_date     int  NOT NULL,
    message_text     text NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS telegram_channel_post;
-- +goose StatementEnd
