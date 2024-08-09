extends Node

# Um dicionário para armazenar os recursos de áudio carregados
var samples = {}

# Carrega um sample de áudio pelo nome
func load_sample(name: String, path: String) -> void:
	if name in samples:
		print("Sample '%s' já carregado." % name)
	else:
		var sample = load(path)
		if sample:
			samples[name] = sample
			print("Sample '%s' carregado com sucesso." % name)
		else:
			print("Erro ao carregar o sample '%s'." % name)

# Retorna um recurso de áudio pelo nome
func get_resource(name: String) -> AudioStream:
	if name in samples:
		return samples[name]
	else:
		print("Sample '%s' não encontrado!" % name)
		return null

# Limpa todos os samples carregados
func clear_samples() -> void:
	samples.clear()
	print("Todos os samples foram limpos.")

