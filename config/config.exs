# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :skill_sanity,
  ecto_repos: [SkillSanity.Repo],
  generators: [timestamp_type: :utc_datetime],
  ash_domains: [SkillSanity.Skills]

# Configures the endpoint
config :skill_sanity, SkillSanityWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SkillSanityWeb.ErrorHTML, json: SkillSanityWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SkillSanity.PubSub,
  live_view: [signing_salt: "XzW6tLUn"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :skill_sanity, SkillSanity.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  skill_sanity: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  skill_sanity: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Use Elixir's Logger backends
config :logger, backends: [LoggerBackends.Console, SkillSanity.Shared.Logger.AppSignalBackend]

# Configures console Logger backend
config :logger, LoggerBackends.Console,
  format: "$time $metadata[$level] $message\n",
  metadata: :all

# Configure custom Logger backend for App Signal
config :logger, SkillSanity.Shared.Logger.AppSignalBackend,
  format: "logfmt",
  application_config: [
    skill_sanity: [
      group: :skill_sanity,
      max_level: :info
    ],
    phoenix: [
      group: :phoenix,
      max_level: :fatal
    ],
    phoenix_live_view: [
      group: :phoenix_live_view,
      max_level: :fatal
    ],
    ecto_sql: [
      group: :ecto,
      max_level: :info
    ],
    ash: [
      group: :ash,
      max_level: :info
    ],
    default: [
      group: :default,
      max_level: :info
    ]
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Spark formatter config for Ash resources
config :spark, :formatter,
  remove_parens?: true,
  "Ash.Resource": [
    type: Ash.Resource,
    section_order: [
      :authentication,
      :token,
      :attributes,
      :identities,
      :relationships,
      :archive,
      :paper_trail,
      :state_machine,
      :preparations,
      :changes,
      :aggregates,
      :calculations,
      :validations,
      :actions,
      :code_interface,
      :policies,
      :field_policies,
      :postgres
    ]
  ]

# Ash tracing
config :ash, :tracer, [AshAppsignal]

config :ash_appsignal,
  trace_types: [
    :custom,
    :action,
    :changeset,
    :validation,
    :change,
    :before_transaction,
    :before_action,
    :after_transaction,
    :after_action,
    :custom_flow_step,
    :flow,
    :query,
    :preparation
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
