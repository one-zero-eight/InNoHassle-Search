package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/one-zero-eight/Search/internal/config"
	"github.com/one-zero-eight/Search/internal/repository"
	"github.com/one-zero-eight/Search/internal/server"
	"github.com/one-zero-eight/Search/internal/service"
	"github.com/one-zero-eight/Search/pkg/pb/search/v1/searchv1connect"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatal(err)
	}

	ctx := context.Background()
	db, err := connectToDB(ctx, cfg.Postgres.Dsn)
	if err != nil {
		log.Fatal(err)
	}
	search := service.NewService(service.Dependencies{
		RecordsRepo: repository.NewRecordsRepo(db),
	})
	searchServer := server.NewSearchServer(search)
	mux := http.NewServeMux()
	path, handler := searchv1connect.NewSearchServiceHandler(searchServer)
	mux.Handle(path, handler)

	fmt.Printf("listening on %s\n", cfg.Server.Address)
	if err := http.ListenAndServeTLS(
		cfg.Server.Address,
		cfg.Server.CertFile,
		cfg.Server.KeyFile,
		mux,
	); err != nil {
		log.Fatalln("failed to serve: ", err)
	}
}

func connectToDB(ctx context.Context, dsn string) (*pgxpool.Pool, error) {
	for i := 0; i < 5; i++ {
		pool, err := pgxpool.New(ctx, dsn)
		if err != nil {
			log.Println("failed to connect to db: ", err)
			log.Println("retrying after 5 seconds...")
			time.Sleep(time.Second * 5)
			continue
		}
		return pool, nil
	}
	return nil, fmt.Errorf("failed to connect to db)")
}
