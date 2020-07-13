defmodule InnCheckerService.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias InnCheckerService.Repo

  alias InnCheckerService.Documents.Inn

  @doc """
  Returns the list of inns.

  ## Examples

      iex> list_inns()
      [%Inn{}, ...]

  """
  def list_inns do
    Repo.all(Inn)
  end

  def last_50 do
    Repo.all(from i in Inn, order_by: [desc: i.inserted_at], limit: 50)
  end

  @doc """
  Gets a single inn.

  Raises `Ecto.NoResultsError` if the Inn does not exist.

  ## Examples

      iex> get_inn!(123)
      %Inn{}

      iex> get_inn!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inn!(id), do: Repo.get!(Inn, id)

  @doc """
  Creates a inn.

  ## Examples

      iex> create_inn(%{field: value})
      {:ok, %Inn{}}

      iex> create_inn(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inn(attrs \\ %{}) do
    %Inn{}
    |> Inn.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inn.

  ## Examples

      iex> update_inn(inn, %{field: new_value})
      {:ok, %Inn{}}

      iex> update_inn(inn, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inn(%Inn{} = inn, attrs) do
    inn
    |> Inn.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inn.

  ## Examples

      iex> delete_inn(inn)
      {:ok, %Inn{}}

      iex> delete_inn(inn)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inn(%Inn{} = inn) do
    Repo.delete(inn)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inn changes.

  ## Examples

      iex> change_inn(inn)
      %Ecto.Changeset{data: %Inn{}}

  """
  def change_inn(%Inn{} = inn, attrs \\ %{}) do
    Inn.changeset(inn, attrs)
  end
end
