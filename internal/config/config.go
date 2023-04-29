package config

import (
	"errors"
	"os"

	"gopkg.in/yaml.v3"
)

var (
	ErrReadingConfig = errors.New("failed to read configuration file")
	ErrParsingConfig = errors.New("failed to parse configuration file")
)

// Config is a struct that contains all the configuration parameters.
type Config struct {
	Server struct {
		Address  string `yaml:"address"`
		CertFile string `yaml:"cert-file"`
		KeyFile  string `yaml:"key-file"`
	}
	Postgres struct {
		Dsn string `yaml:"dsn"`
	}
}

// Load reads the configuration file, parses it and returns the parsed Config struct.
// If there was an error reading the file or parsing it, zero value of Config is returned
// along with the error.
func Load() (Config, error) {
	var config Config

	rawYAML, err := os.ReadFile("config.yaml")
	if err != nil {
		return config, ErrReadingConfig
	}

	err = yaml.Unmarshal(rawYAML, &config)
	if err != nil {
		return config, ErrParsingConfig
	}

	return config, nil
}
