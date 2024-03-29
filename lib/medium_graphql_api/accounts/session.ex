defmodule MediumGraphqlApi.Accounts.Session do
  alias MediumGraphqlApi.Accounts.User
  alias MediumGraphqlApi.Repo

  def authenticate(args) do
    user = Repo.get_by(User, email: String.downcase(args.email))

    case check_password(user, args) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect login credentials"}
    end
  end

  defp check_password(user, args) do
    case user do
      nil -> Pbkdf2.no_user_verify()
      _ -> Pbkdf2.verify_pass(args.password, user.password_hash)
    end
  end
end
