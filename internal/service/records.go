package service

import (
	"context"

	"github.com/one-zero-eight/Search/internal/models"
	"github.com/one-zero-eight/Search/internal/repository"
)

type Dependencies struct {
	RecordsRepo repository.RecordsRepo
}

type Service struct {
	repo repository.RecordsRepo
}

func NewService(deps Dependencies) *Service {
	return &Service{repo: deps.RecordsRepo}
}

func (s *Service) AddTgPost(ctx context.Context, post *models.TgChannelPost) error {
	return s.repo.AddTgPost(ctx, post)
}
