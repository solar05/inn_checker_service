defmodule InnCheckerServiceWeb.Services.InnChecker do
  alias InnCheckerService.Documents
  alias InnCheckerService.Fsm.InnStateMachine
  alias InnCheckerServiceWeb.Endpoint

  def check_inn(inn) do
    if Documents.Inn.is_control_sum_valid(inn) do
      InnStateMachine.persist(inn, "correct")
      Endpoint.broadcast!("inn:checks", "inn_correct", %{id: inn.id})
    else
      InnStateMachine.persist(inn, "incorrect")
      Endpoint.broadcast!("inn:checks", "inn_incorrect", %{id: inn.id})
    end
  end
end
