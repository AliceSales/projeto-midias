# EmpatiaKuma

Projeto Godot 4 para medir empatia baseado em escolhas de Bartolomeu Kuma.

## Estrutura
- **scenes/**
  - Main.tscn
  - NPC.tscn
- **scripts/**
  - DataSender.gd
  - GameManager.gd
  - NPC.gd
- **assets/** (coloque sprites e vídeos aqui)

## Configuração
1. No **App Script** do Google Sheets, configure o endpoint e copie a URL.
2. No editor Godot, selecione o nó **DataSender** em `Main.tscn` e cole a URL no `endpoint_url`.
3. Instancie NPCs em `Main.tscn` e ajuste `npc_name` no Inspector.
4. Adicione seu **Player** (CharacterBody2D + animações) como filho de **Main**.
5. Rode o jogo e veja as entradas aparecerem na planilha.

## Licença
Use livremente para seu projeto acadêmico!
