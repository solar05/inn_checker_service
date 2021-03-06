defmodule InnCheckerServiceWeb.Router do
  use InnCheckerServiceWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :guardian do
    plug InnCheckerServiceWeb.Authentication.Pipeline
  end

  pipeline :token do
    plug InnCheckerServiceWeb.Plugs.TokensService
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InnCheckerServiceWeb.Api, as: :api do
    pipe_through :api
    resources "/documents", DocumentController, only: [:create]
    get "/documents/:type/:number", DocumentController, :show
  end

  scope "/", InnCheckerServiceWeb do
    pipe_through [:browser, :guardian, :token]
    get "/", PageController, :index
    get "/about", PageController, :about
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    resources "/documents", DocumentController, only: [:new]
  end

  scope "/admin", InnCheckerServiceWeb do
    pipe_through [:browser, :token, :guardian, :browser_auth]
    get "/users/:client", UserController, :create
    post "/users/:client", UserController, :delete
    live_dashboard "/dashboard", metrics: InnCheckerServiceWeb.Telemetry
    resources "/users", UserController, only: [:index]
    delete "/logout", SessionController, :delete
    resources "/documents", DocumentController, only: [:index, :show, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", InnCheckerServiceWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do

  #  scope "/" do
  #    pipe_through :browser
  #    live_dashboard "/dashboard", metrics: InnCheckerServiceWeb.Telemetry
  #  end
  # end
end
