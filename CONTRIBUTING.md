## Project Structure

### `/cmd`
All project executables.
All packages here are `main`.

### `/cmd/app`
Package of the main project application (entry point).

### `/internal`
Private project code.

### `/internal/service`
Package with main application business logic code.

### `/internal/config`
Package that parses and validates configuration file of the application.

### `/internal/server`
Package with application server implementation.

### `/pkg`
Code that can be used by external applications.

### `/pkg/proto`
Protobuf definitions of the application.

### `/pkg/pb`
Code generated from protobuf definitions at `/pkg/proto`.
See [gRPC section](#grpc) for more information.

## Migrations
We use a [goose](https://github.com/pressly/goose) as a migration tool.
Make sure it is installed and is in your PATH.

Migrations are stored in the `/migrations` directory.
Migrations naming format is `xxxxx_migration_name.sql`.

Create a new SQL migration:
```bash
goose -s -dir ./migrations create migration-name sql
```

Check current migration status of the database:
```bash
goose -dir ./migrations postgres "postgres://user:password@localhost:5432/database?sslmode=disable" status
```

Migrate the database to the latest version:
```bash
goose -dir ./migrations postgres "postgres://user:password@localhost:5432/database?sslmode=disable" up
```

## gRPC
TODO: Coming soon...
