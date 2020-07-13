defmodule InnCheckerService.Fsm.InnStateMachine do
  alias InnCheckerService.Documents

  use Machinery,
    field: :state,
    states: ["created", "correct", "incorrect"],
    transitions: %{
      "created" => ["correct", "incorrect"]
    }

  def persist(struct, next_state) do
    {:ok, inn} = Documents.update_inn(struct, %{state: next_state})
    inn
  end
end
