defmodule AgendaCli.Store do
  @arquivo "contacts.json"

  def load do
    case File.read(@arquivo) do
      {:ok, conteudo} ->
        case Jason.decode(conteudo) do
          {:ok, dados} -> dados
          _ -> []
        end
      _ -> []
    end
  end

  def save(contatos) do
    json_formatado = Jason.encode!(contatos, pretty: true)
    File.write!(@arquivo, json_formatado)
  end
end
