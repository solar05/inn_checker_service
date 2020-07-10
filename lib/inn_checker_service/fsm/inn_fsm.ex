defmodule InnCheckerService.Fsm.InnStateMachine do
  use Machinery,
    field: :state,
    states: ["created", "in_progress", "complete", "canceled"],
    transitions: %{
      "created" => ["in_progress", "complete"],
      "in_progress" => "complete",
      "*" => "canceled"
    }
end
