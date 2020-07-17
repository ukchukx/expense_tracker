defmodule ExpenseTracker.Router do
  # alias ExpenseTracker.Middleware.{Telemetry, Uniqueness, Validate}
  # alias ExpenseTracker.Aggregates.{User, Book, Movie}
  # alias ExpenseTracker.Commands.{
  #   CreateUser,
  #   DisableUser,
  #   EnableUser,
  #   UpdateUser,
  #   CreateBook,
  #   UpdateBook,
  #   DeleteBook,
  #   CreateMovie,
  #   UpdateMovie,
  #   DeleteMovie
  # }

  use Commanded.Commands.Router

  # middleware Telemetry
  # middleware Validate
  # middleware Uniqueness

  # identify User, by: :user_id,   prefix: "user-"
  # identify Book, by: :book_id,   prefix: "book-"
  # identify Movie, by: :movie_id,   prefix: "movie-"

  # dispatch [
  #   CreateUser,
  #   DisableUser,
  #   EnableUser,
  #   UpdateUser
  # ], to: User, lifespan: User, timeout: Application.get_env(:stash, :router)[:timeout]
end
