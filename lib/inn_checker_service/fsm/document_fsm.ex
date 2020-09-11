defmodule InnCheckerService.Fsm.DocumentFSM do
  alias InnCheckerService.Papers

  use Machinery,
    field: :state,
    states: ["created", "correct", "incorrect"],
    transitions: %{
      "created" => ["correct", "incorrect"]
    }

  def persist(struct, next_state) do
    {:ok, inn} = Papers.update_document(struct, %{state: next_state})
    inn
  end
end
