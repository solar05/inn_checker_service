defmodule InnCheckerServiceWeb.Services.DocumentChecker do
  alias InnCheckerService.Fsm.DocumentFSM
  alias InnCheckerServiceWeb.Endpoint
  alias InnCheckerServiceWeb.Services.InnChecker
  alias InnCheckerServiceWeb.Services.SnilsChecker

  def check_document(document) do
    result =
      case document.type do
        "inn" ->
          InnCheckerServiceWeb.Services.InnChecker.check_inn(document)

        "snils" ->
          SnilsChecker.check_snils(document)

        _ ->
          false
      end

    if result do
      DocumentFSM.persist(document, "correct")
      Endpoint.broadcast!("document:checks", "document_correct", %{id: document.id})
    else
      DocumentFSM.persist(document, "incorrect")
      Endpoint.broadcast!("document:checks", "document_incorrect", %{id: document.id})
    end
  end

  def check_document_api(document) do
    result =
      case document.type do
        "inn" ->
          InnChecker.check_inn(document)

        "snils" ->
          SnilsChecker.check_snils(document)

        _ ->
          false
      end

    if result do
      DocumentFSM.persist(document, "correct")
    else
      DocumentFSM.persist(document, "incorrect")
    end
  end
end
