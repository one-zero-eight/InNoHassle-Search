package main

import (
	"fmt"
	"log"
	"net/http"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"github.com/one-zero-eight/Search/internal/config"
	"github.com/one-zero-eight/Search/internal/server"
	"github.com/one-zero-eight/Search/pkg/pb/search/v1/searchv1connect"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatal(err)
	}

	search := &server.SearchServer{}
	mux := http.NewServeMux()
	path, handler := searchv1connect.NewSearchServiceHandler(search)
	mux.Handle(path, handler)

	fmt.Printf("listening on %s\n", cfg.Server.Address)
	if err := http.ListenAndServe(
		cfg.Server.Address,
		// Use h2c, so we can serve HTTP/2 without TLS.
		h2c.NewHandler(mux, &http2.Server{}),
	); err != nil {
		log.Fatalln("failed to serve")
	}
}
