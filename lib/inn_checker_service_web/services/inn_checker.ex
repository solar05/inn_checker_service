defmodule InnCheckerServiceWeb.Services.InnChecker do
  import Phoenix.Channel

  alias InnCheckerService.Documents
  alias InnCheckerService.Fsm.InnStateMachine

  def check_inn(inn, socket) do
    if Documents.Inn.is_control_sum_valid(inn) do
      InnStateMachine.persist(inn, "correct")
      broadcast!(socket, "inn_correct", %{id: inn.id})
      {:noreply, socket}
    else
      InnStateMachine.persist(inn, "incorrect")
      broadcast!(socket, "inn_incorrect", %{id: inn.id})
      {:noreply, socket}
    end
  end
end
