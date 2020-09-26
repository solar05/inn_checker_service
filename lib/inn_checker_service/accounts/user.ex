defmodule InnCheckerService.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @operator_actions ["show_document", "delete_document", "index_documents"]
  @admin_actions [
    "show_document",
    "delete_document",
    "index_users",
    "ban_users",
    "unban_users",
    "index_documents"
  ]

  schema "users" do
    field :login, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :role, :string

    timestamps([:utc_datetime])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:login, :password, :role])
    |> validate_required([:login, :password])
    |> unique_constraint(:login)
    |> put_encrypted_password()
  end

  defp put_encrypted_password(%{valid?: true, changes: %{password: pw}} = changeset) do
    put_change(changeset, :encrypted_password, Argon2.hash_pwd_salt(pw))
  end

  defp put_encrypted_password(changeset) do
    changeset
  end

  def can?(user, action) do
    case user.role do
      "operator" -> Enum.member?(@operator_actions, action)
      "admin" -> Enum.member?(@admin_actions, action)
      _ -> false
    end
  end
end
