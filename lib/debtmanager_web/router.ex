defmodule DebtmanagerWeb.Router do
  use DebtmanagerWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", DebtmanagerWeb do
    pipe_through :browser

    get "/", DebtController, :overview
  end

  scope "/", DebtmanagerWeb do
    pipe_through [:browser, :protected]

    get "/friendships", FriendshipController, :index
    post "/friendships/", FriendshipController, :add
    put "/friendships/accept/", FriendshipController, :accept
    delete "/friendships/deny/", FriendshipController, :deny
    delete "/friendships/remove/", FriendshipController, :remove
  end

  scope "/", DebtmanagerWeb do
    pipe_through [:browser, :protected]

    get "/debts", DebtController, :index
    get "/debts/new", DebtController, :new
    post "/debts", DebtController, :create
    put "/debts/:id/remind", DebtController, :remind
    put "/debts/:id/pay", DebtController, :pay
    get "/debts/history", DebtController, :history
    post "/debts/history", DebtController, :show
  end





  # Other scopes may use custom stacks.
  # scope "/api", DebtmanagerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DebtmanagerWeb.Telemetry
    end
  end
end
