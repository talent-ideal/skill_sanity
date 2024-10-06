defmodule SkillSanityWeb.Plugs.HealthCheck do
  @behaviour Plug

  require Logger
  import Plug.Conn

  @impl true
  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health_check"} = conn, _opts) do
    case SkillSanity.Repo.query("SELECT 1") do
      {:ok, _} ->
        send_resp(conn, 200, "ok")

      error ->
        Logger.error("Healthcheck failed", %{error: inspect(error)})
        send_resp(conn, 503, "error")
    end
    |> halt()
  end

  @impl true
  def call(conn, _opts), do: conn
end
