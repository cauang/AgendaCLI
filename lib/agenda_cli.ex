defmodule AgendaCli do

  def main do
    IO.puts("Bem-vindo à Agenda CLI!")
    state = AgendaCli.Store.load()
    loop(state)
  end

  defp loop(state) do
    input = IO.gets("agenda> ") |> String.trim()

    if input != "" do
      process_command(input, state)
    else
      loop(state)
    end
  end

  defp process_command("exit", _state) do
    IO.puts("Encerrando a aplicação...")
  end

  defp process_command("list", state) do
    AgendaCli.Contacts.list(state)
    loop(state)
  end

  defp process_command("show " <> id, state) do
    AgendaCli.Contacts.show(state, String.trim(id))
    loop(state)
  end

  defp process_command("del " <> id, state) do
    novo_state = AgendaCli.Contacts.del(state, String.trim(id))
    AgendaCli.Store.save(novo_state)
    IO.puts("Contato removido.")
    loop(novo_state)
  end

  defp process_command("search " <> resto, state) do
    tupla_busca = parse_search(String.trim(resto))
    AgendaCli.Contacts.search(state, tupla_busca)
    loop(state)
  end

  defp process_command("add " <> resto, state) do
    palavras = String.split(resto, " ")
    campos = parse_flags(palavras)

    novo_state = AgendaCli.Contacts.add(state, campos)
    AgendaCli.Store.save(novo_state)
    IO.puts("Contato adicionado com sucesso.")
    loop(novo_state)
  end

  defp process_command("edit " <> resto, state) do
    [id_str | flags_lista] = String.split(resto, " ")
    campos_para_atualizar = parse_flags(flags_lista)

    novo_state = AgendaCli.Contacts.edit(state, id_str, campos_para_atualizar)
    AgendaCli.Store.save(novo_state)
    IO.puts("Contato atualizado com sucesso.")
    loop(novo_state)
  end

  defp process_command(comando_invalido, state) do
    IO.puts("Comando não reconhecido: #{comando_invalido}")
    loop(state)
  end

  def parse_search("-name " <> valor), do: salvar_parse({:name, String.trim(valor)})
  def parse_search("--name " <> valor), do: salvar_parse({:name, String.trim(valor)})

  def parse_search("-phone " <> valor), do: salvar_parse({:phone, String.trim(valor)})
  def parse_search("--phone " <> valor), do: salvar_parse({:phone, String.trim(valor)})

  def parse_search("-email " <> valor), do: salvar_parse({:email, String.trim(valor)})
  def parse_search("--email " <> valor), do: salvar_parse({:email, String.trim(valor)})

  def parse_search(_), do: {:error, ""}

  defp salvar_parse(resultado_tupla) do
    conteudo_json = Jason.encode!(["#{inspect(resultado_tupla)}"])
    File.write!("lib/parse.json", conteudo_json)
    resultado_tupla
  end

  defp parse_flags(lista_args, mapa_acumulado \\ %{})
  defp parse_flags([], mapa_acumulado), do: mapa_acumulado

  defp parse_flags(["-name" | cauda], mapa), do: extrair_valor(:name, cauda, mapa)
  defp parse_flags(["--name" | cauda], mapa), do: extrair_valor(:name, cauda, mapa)

  defp parse_flags(["-company" | cauda], mapa), do: extrair_valor(:company, cauda, mapa)
  defp parse_flags(["--company" | cauda], mapa), do: extrair_valor(:company, cauda, mapa)

  defp parse_flags(["-phone" | cauda], mapa), do: extrair_valor(:phone, cauda, mapa)
  defp parse_flags(["--phone" | cauda], mapa), do: extrair_valor(:phone, cauda, mapa)

  defp parse_flags(["-email" | cauda], mapa), do: extrair_valor(:email, cauda, mapa)
  defp parse_flags(["--email" | cauda], mapa), do: extrair_valor(:email, cauda, mapa)

  defp parse_flags([_ignorar | cauda], mapa), do: parse_flags(cauda, mapa)

  defp extrair_valor(chave_flag, lista_restante, mapa_acumulado) do
    {palavras_do_valor, resto_da_lista} = Enum.split_while(lista_restante, fn palavra ->
      not String.starts_with?(palavra, "-")
    end)

    valor_final = Enum.join(palavras_do_valor, " ")
    novo_mapa = Map.put(mapa_acumulado, chave_flag, valor_final)

    parse_flags(resto_da_lista, novo_mapa)
  end
end
