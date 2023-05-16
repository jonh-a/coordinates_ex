defmodule CoordinatesWeb.Router do
  use CoordinatesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CoordinatesWeb do
    pipe_through :api
    get("/status", StatusController, :status)
    get("/random", RandomLocationController, :random_location)
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:coordinates, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
