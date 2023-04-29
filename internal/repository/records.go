package repository

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/one-zero-eight/Search/internal/models"
)

type RecordsRepo interface {
	AddTgPost(ctx context.Context, post *models.TgChannelPost) error
}

type recordsRepo struct {
	pool *pgxpool.Pool
}

func NewRecordsRepo(pool *pgxpool.Pool) RecordsRepo {
	return &recordsRepo{pool: pool}
}

func (r *recordsRepo) AddTgPost(ctx context.Context, post *models.TgChannelPost) error {
	exec, err := r.pool.Exec(
		ctx,
		"INSERT INTO telegram_channel_post (channel_name, channel_username, message_id, message_date, message_text) VALUES ($1, $2, $3, $4, $5) RETURNING id",
		post.ChannelName, post.ChannelUsername, post.MessageId, post.MessageDate, post.MessageText,
	)
	if err != nil {
		return fmt.Errorf("failed to insert record: %w", err)
	}
	if exec.RowsAffected() != 1 {
		return fmt.Errorf("failed to insert record: %d rows affected", exec.RowsAffected())
	}
	return nil
}
