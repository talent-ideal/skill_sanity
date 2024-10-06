defmodule SkillSanity.Shared.Logger.AppSignalBackend do
  @moduledoc """
  Logger backend for AppSignal.

  ## Configuration

  You can specify the group and maximum log level to be sent to App Signal for each application:

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
          # use this block to override the defaults
          default: [
            group: :others, # otherwise, defaults to :default
            max_level: :warn # otherwise, defaults to :info
          ]
        ]

  """

  @behaviour :gen_event

  @default_opts [default_group: :default, default_max_level: :info, format: :plaintext]

  @levels %{
    fatal: 0,
    error: 1,
    warn: 2,
    info: 3,
    debug: 4,
    trace: 5
  }

  @impl true
  def init(atom) when is_atom(atom) do
    init({__MODULE__, Application.get_env(:logger, __MODULE__, [])})
  end

  @impl true
  def init({__MODULE__, opts}) do
    {:ok,
     Keyword.merge(
       @default_opts,
       opts
     )}
  end

  @impl true
  def handle_call({:configure, _opts}, state) do
    {:ok, :ok, state}
  end

  @impl true
  def handle_info(_info, state) do
    {:ok, state}
  end

  @impl true
  def handle_event(
        {level, _gl, {Logger, message, _timestamp, metadata}},
        opts
      ) do
    application = metadata[:application] || :default

    application_config =
      opts[:application_config][application] || opts[:application_config][:default]

    group = metadata[:group] || application_config[:group] || opts[:default_group]
    max_level = application_config[:max_level] || opts[:default_max_level]

    log_event(
      @levels[level],
      @levels[max_level],
      group,
      message,
      metadata,
      opts
    )

    {:ok, opts}
  end

  def log_event(level, max_level, group, message, metadata, opts)
      when level <= max_level do
    Appsignal.Logger.log(
      level,
      to_string(group),
      IO.chardata_to_string(message),
      Enum.into(metadata, %{}),
      opts[:format]
    )
  end

  def log_event(_level, _max_level, _group, _message, _metadata, _opts),
    do: :noop
end
