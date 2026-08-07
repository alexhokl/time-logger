// Package cmd implements the time-logger command line interface, which serves
// both as the server (via the serve subcommand) and as the gRPC client for
// every other verb.
package cmd

import (
	"fmt"

	"github.com/alexhokl/helper/cli"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// AppName is the binary name, used for the config file name and the Viper
// environment variable prefix.
const AppName = "time-logger"

// envPrefix namespaces environment variables, e.g. TIME_LOGGER_SERVICE.
const envPrefix = "time_logger"

type rootOptions struct {
	serviceURI              string
	allowInsecureConnection bool
	cfgFile                 string
	format                  string
	fields                  []string
}

var rootOpts rootOptions

var rootCmd = &cobra.Command{
	Use:   AppName,
	Short: "Track where your time goes",
	Long: `time-logger runs the time tracking server and acts as its client.

Use the serve subcommand to run the gRPC server; every other command talks to
a running server over gRPC.`,
	SilenceUsage: true,
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		bindEnvironmentVariablesToRootOptions(&rootOpts)
		// The server does not connect to itself, so the client-only flags are
		// neither required nor validated for it.
		if isServerCommand(cmd) {
			return nil
		}
		return validateFormat(rootOpts.format)
	},
}

// Execute runs the root command. Errors are already reported by Cobra, so the
// return value is discarded; main sets the exit code from the command itself.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		//nolint:gocritic // Cobra has already printed the error.
		exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	persistentFlags := rootCmd.PersistentFlags()
	persistentFlags.StringVar(&rootOpts.cfgFile, "config", "",
		fmt.Sprintf("config file (default is $HOME/.%s.yaml)", AppName))
	persistentFlags.StringVarP(&rootOpts.serviceURI, "service", "s", "",
		"host:port of the time-logger server")
	persistentFlags.BoolVarP(&rootOpts.allowInsecureConnection, "insecure", "i", false,
		"allow a plaintext connection to the server")
	persistentFlags.StringVarP(&rootOpts.format, "format", "f", "text",
		"output format: text, json or csv")
	persistentFlags.StringSliceVar(&rootOpts.fields, "fields", nil,
		"restrict output to these fields (json and csv formats only)")
}

func initConfig() {
	cli.ConfigureViper(rootOpts.cfgFile, AppName, false, "")
}

// bindEnvironmentVariablesToRootOptions falls back to Viper for any flag the
// user did not pass, so configuration can come from the config file or the
// environment. Explicit flags always win because they are only overridden when
// still at their zero value.
func bindEnvironmentVariablesToRootOptions(opts *rootOptions) {
	if opts.serviceURI == "" {
		opts.serviceURI = viper.GetString("service")
	}
	if !opts.allowInsecureConnection {
		opts.allowInsecureConnection = viper.GetBool("insecure")
	}
	if opts.cfgFile == "" {
		opts.cfgFile = viper.GetString("config")
	}
	if opts.format == "" {
		opts.format = viper.GetString("format")
	}
}

// isServerCommand reports whether the command being run is the server rather
// than a client verb.
func isServerCommand(cmd *cobra.Command) bool {
	for c := cmd; c != nil; c = c.Parent() {
		if c.Name() == "serve" {
			return true
		}
	}
	return false
}
