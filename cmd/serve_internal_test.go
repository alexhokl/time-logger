package cmd

import (
	"testing"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// newTestServeCommand builds a standalone command with its own serveOptions
// and the same flag definitions as serveCmd's init(), so tests can exercise
// bindEnvironmentVariablesToServeOptions without touching the package-level
// serveCmd/serveOpts globals.
func newTestServeCommand() (*cobra.Command, *serveOptions) {
	opts := &serveOptions{}
	cmd := &cobra.Command{Use: "serve"}
	flags := cmd.Flags()
	flags.IntVarP(&opts.Port, "port", "p", DefaultPort, "port to serve gRPC on")
	flags.StringVarP(&opts.DatabaseFilePath, "database", "d", "", "path to the SQLite database file")
	flags.StringVar(&opts.Hostname, "hostname", "", "Tailscale hostname")
	flags.StringVar(&opts.TailscaleAuthKey, "ts-auth-key", "", "Tailscale auth key")
	flags.StringVar(&opts.TailscaleStateDirectory, "ts-state-dir", "./tailscale-state",
		"directory in which to persist Tailscale state")
	return cmd, opts
}

func TestBindEnvironmentVariablesToServeOptionsPort(t *testing.T) {
	t.Run("an environment variable overrides the untouched default", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("port", 443)

		cmd, opts := newTestServeCommand()
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, 443, opts.Port,
			"TIME_LOGGER_PORT must take effect when --port is not explicitly passed")
	})

	t.Run("an explicit flag wins over the environment variable", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("port", 443)

		cmd, opts := newTestServeCommand()
		require.NoError(t, cmd.Flags().Set("port", "9000"))
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, 9000, opts.Port)
	})

	t.Run("the compiled-in default survives when neither is set", func(t *testing.T) {
		defer viper.Reset()

		cmd, opts := newTestServeCommand()
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, DefaultPort, opts.Port)
	})
}

func TestBindEnvironmentVariablesToServeOptionsTailscaleStateDirectory(t *testing.T) {
	t.Run("an environment variable overrides the untouched default", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("ts_state_dir", "/custom/state")

		cmd, opts := newTestServeCommand()
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, "/custom/state", opts.TailscaleStateDirectory)
	})

	t.Run("an explicit flag wins over the environment variable", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("ts_state_dir", "/custom/state")

		cmd, opts := newTestServeCommand()
		require.NoError(t, cmd.Flags().Set("ts-state-dir", "/explicit/state"))
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, "/explicit/state", opts.TailscaleStateDirectory)
	})

	t.Run("the compiled-in default survives when neither is set", func(t *testing.T) {
		defer viper.Reset()

		cmd, opts := newTestServeCommand()
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, "./tailscale-state", opts.TailscaleStateDirectory)
	})
}

func TestBindEnvironmentVariablesToServeOptionsEmptyDefaultFields(t *testing.T) {
	t.Run("an environment variable fills in an untouched empty flag", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("hostname", "time-logger")
		viper.Set("database", "/data/timelogger.db")
		viper.Set("ts_auth_key", "tskey-secret")

		cmd, opts := newTestServeCommand()
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, "time-logger", opts.Hostname)
		assert.Equal(t, "/data/timelogger.db", opts.DatabaseFilePath)
		assert.Equal(t, "tskey-secret", opts.TailscaleAuthKey)
	})

	t.Run("an explicit flag is not overwritten", func(t *testing.T) {
		defer viper.Reset()
		viper.Set("hostname", "from-env")

		cmd, opts := newTestServeCommand()
		require.NoError(t, cmd.Flags().Set("hostname", "from-flag"))
		bindEnvironmentVariablesToServeOptions(cmd, opts)

		assert.Equal(t, "from-flag", opts.Hostname)
	})
}
