tool
extends EditorPlugin

func _enter_tree():
    # Adiciona um callback para quando o jogo começa
    get_tree().connect("paused_state_changed", self, "_on_paused_state_changed")

func _exit_tree():
    # Remove o callback quando o plugin é desligado
    get_tree().disconnect("paused_state_changed", self, "_on_paused_state_changed")

func _on_paused_state_changed(paused):
    if not paused:
        # Alterna para a hierarquia remota quando o jogo começa
        var editor_interface = get_editor_interface()
        if editor_interface:
            var dock = editor_interface.get_editor_docks().get_dock("Scene")
            if dock:
                dock.set_current_tab("Remote")
