defmodule AgendaCli.Contacts do

  def add(state, campos) do
    proximo_id = gerar_proximo_id(state)

    novo_contato = %{
      "id" => proximo_id,
      "name" => Map.get(campos, :name, ""),
      "company" => Map.get(campos, :company, ""),
      "phone" => Map.get(campos, :phone, ""),
      "email" => Map.get(campos, :email, "")
    }

    state ++ [novo_contato]
  end

  defp gerar_proximo_id([]), do: 1
  defp gerar_proximo_id(state) do
      maior_id = state
        |> Enum.map(fn c -> c["id"] end)
        |> Enum.max()
    maior_id + 1
  end

  # --- LISTAR ---
  @spec list(any()) :: :ok
  def list(state) do
    IO.puts("ID | NOME | EMPRESA | TELEFONE | EMAIL")
    IO.puts("---------------------------------------------")
    Enum.each(state, fn c ->
      IO.puts("#{c["id"]} | #{c["name"]} | #{c["company"]} | #{c["phone"]} | #{c["email"]}")
    end)
    IO.puts("---------------------------------------------")
  end

  # --- MOSTRAR (SHOW) ---
  def show(state, id_str) do
    id = String.to_integer(id_str)
    IO.puts("---------------------------------------------")
    case Enum.find(state, fn c -> c["id"] == id end) do
      nil -> IO.puts("Contato não encontrado.")
      c ->
        IO.puts("ID: #{c["id"]}")
        IO.puts("Nome: #{c["name"]}")
        IO.puts("Empresa: #{c["company"]}")
        IO.puts("Telefone: #{c["phone"]}")
        IO.puts("Email: #{c["email"]}")
    IO.puts("---------------------------------------------")
    end
  end

  # --- DELETAR ---
  def del(state, id_str) do
    id = String.to_integer(id_str)
    Enum.reject(state, fn c -> c["id"] == id end)
  end

  # --- EDITAR ---
  def edit(state, id_str, atualizacoes) do
    id = String.to_integer(id_str)

    Enum.map(state, fn c ->
      if c["id"] == id do
        %{
          c |
          "name" => Map.get(atualizacoes, :name, c["name"]),
          "company" => Map.get(atualizacoes, :company, c["company"]),
          "phone" => Map.get(atualizacoes, :phone, c["phone"]),
          "email" => Map.get(atualizacoes, :email, c["email"])
        }
      else
        c
      end
    end)
  end

  # --- BUSCAR (SEARCH) ---
  def search(state, {:name, valor}), do: buscar_por(state, "name", valor)
  def search(state, {:phone, valor}), do: buscar_por(state, "phone", valor)
  def search(state, {:email, valor}), do: buscar_por(state, "email", valor)
  def search(_state, {:error, _}), do: IO.puts("Flag de busca inválida.")

  defp buscar_por(state, chave_do_mapa, valor_buscado) do
    valor_minusculo = String.downcase(valor_buscado)

    resultados = Enum.filter(state, fn c ->
      String.downcase(c[chave_do_mapa]) |> String.contains?(valor_minusculo)
    end)

    IO.puts("Resultados encontrados:")
    list(resultados)
  end
end
