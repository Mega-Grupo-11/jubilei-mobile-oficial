import 'package:flutter/material.dart';
import 'task.dart';
import 'utils/image_utils.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Lista para armazenar as tarefas
  List<Map<String, dynamic>> _tasks = [];
  // Lista filtrada para pesquisa
  List<Map<String, dynamic>> _filteredTasks = [];
  // Controlador para o campo de pesquisa
  TextEditingController _searchController = TextEditingController();
  // Flag para mostrar a barra de pesquisa
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredTasks = List.from(_tasks); // Usa List.from para criar uma cópia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Adicionado para melhor contraste
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar tarefas...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey[300],
                    ), // Mais visível
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ), // Alterado para preto para melhor visibilidade
                  onChanged: _filterTasks,
                )
                : Row(
                  children: [
                    Image.asset(
                      'imgs/LOGO-E-IMG.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8),
                    Text('TO-DO TOOL'),
                  ],
                ),
        leading:
            _isSearching
                ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _filteredTasks = List.from(
                        _tasks,
                      ); // Usa List.from para criar uma cópia
                    });
                  },
                )
                : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
        actions: [
          if (!_isSearching)
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: _tasks.isEmpty ? _buildEmptyState() : _buildTaskList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _isSearching ? 1 : 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        ],
        onTap: (index) {
          if (index == 1) {
            // Ativa a pesquisa quando o ícone de pesquisa é pressionado
            setState(() {
              _isSearching = true;
            });
          } else if (_isSearching) {
            // Se estiver na pesquisa e clicar em home, desativa a pesquisa
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filteredTasks = List.from(_tasks);
            });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Aguarda o retorno da tela de criação de tarefas
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );

          // Verifica se retornou uma tarefa
          if (result != null) {
            setState(() {
              _tasks.add(result);
              // Atualiza a lista filtrada
              if (_isSearching && _searchController.text.isNotEmpty) {
                _filterTasks(_searchController.text);
              } else {
                _filteredTasks = List.from(_tasks);
              }
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Método para filtrar tarefas com base no texto de pesquisa
  void _filterTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        // Se a consulta estiver vazia, mostre todas as tarefas
        _filteredTasks = List.from(_tasks);
      } else {
        // Filtrar baseado no título, descrição ou tags
        _filteredTasks =
            _tasks.where((task) {
              final title = task['title'].toString().toLowerCase();
              final description = task['description'].toString().toLowerCase();
              final queryLower = query.toLowerCase();

              // Verifica nas tags
              bool matchesTag = false;
              if (task['tags'] != null && task['tags'] is List) {
                for (String tag in task['tags']) {
                  if (tag.toLowerCase().contains(queryLower)) {
                    matchesTag = true;
                    break;
                  }
                }
              }

              return title.contains(queryLower) ||
                  description.contains(queryLower) ||
                  matchesTag;
            }).toList();

        // Log para depuração
        print(
          'Pesquisando por: $query - Encontrados: ${_filteredTasks.length}',
        );
      }
    });
  }

  // Widget para mostrar quando não há tarefas - Atualizado com a imagem
  Widget _buildEmptyState() {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adicionada a imagem logo com tamanho consistente
          Container(
            width: screenSize.width * 0.5, // 50% da largura da tela
            height:
                screenSize.width *
                0.4, // 40% da largura da tela (mantém proporção)
            child: Image.asset('imgs/LOGO-E-IMG.png', fit: BoxFit.contain),
          ),
          SizedBox(height: 20),
          Text(
            'Bem-vindo(a)!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'adicione sua primeira tarefa',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Icon(Icons.arrow_downward, size: 40, color: Colors.blue[900]),
        ],
      ),
    );
  }

  // Widget para exibir a lista de tarefas
  Widget _buildTaskList() {
    // Usa a lista filtrada em vez da lista completa
    final tasksToShow = _filteredTasks;

    if (tasksToShow.isEmpty && _isSearching) {
      // Mostra mensagem quando a pesquisa não retorna resultados
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma tarefa encontrada',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tente outros termos de pesquisa',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasksToShow.length,
      itemBuilder: (context, index) {
        final task = tasksToShow[index];

        // Define a cor baseada na prioridade
        Color priorityColor;
        switch (task['priority']) {
          case 'Baixa':
            priorityColor = Colors.green;
            break;
          case 'Alta':
            priorityColor = Colors.red;
            break;
          default:
            priorityColor = Colors.orange;
        }

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              task['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task['description'].isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      task['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${task['date']} às ${task['time']}'),
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task['priority'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              value: task['completed'] ?? false,
              onChanged: (value) {
                setState(() {
                  task['completed'] = value;
                });
              },
            ),
            onTap: () {
              _showTaskDetails(task, _tasks.indexOf(task));
            },
          ),
        );
      },
    );
  }

  // Novo método para exibir o modal de detalhes da tarefa
  void _showTaskDetails(Map<String, dynamic> task, int index) {
    // Define a cor baseada na prioridade
    Color priorityColor;
    switch (task['priority']) {
      case 'Baixa':
        priorityColor = Colors.green;
        break;
      case 'Alta':
        priorityColor = Colors.red;
        break;
      default:
        priorityColor = Colors.orange;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Barra de título do modal
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detalhes da Tarefa',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Conteúdo do modal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título da tarefa
                        Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Status de conclusão
                        Row(
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Chip(
                              backgroundColor:
                                  task['completed']
                                      ? Colors.green[100]
                                      : Colors.grey[200],
                              label: Text(
                                task['completed'] ? 'Concluída' : 'Pendente',
                                style: TextStyle(
                                  color:
                                      task['completed']
                                          ? Colors.green[800]
                                          : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Data e hora
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 10),
                            Text(
                              '${task['date']} às ${task['time']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Prioridade
                        Row(
                          children: [
                            Text(
                              'Prioridade:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                task['priority'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Descrição
                        Text(
                          'Descrição:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          task['description'].isEmpty
                              ? 'Sem descrição'
                              : task['description'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),

                        // Tags
                        if (task['tags'].isNotEmpty) ...[
                          Text(
                            'Tags:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                (task['tags'] as List<String>).map((tag) {
                                  return Chip(
                                    label: Text(
                                      tag,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue,
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 24),
                        ],

                        // Botões de ação
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () async {
                                  // Fecha o modal
                                  Navigator.pop(context);
                                  // Abre a tela de edição
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              TaskFormScreen(task: task),
                                    ),
                                  );

                                  // Atualiza a tarefa se houver alterações
                                  if (result != null) {
                                    setState(() {
                                      _tasks[index] = result;
                                      if (_isSearching) {
                                        _filterTasks(_searchController.text);
                                      } else {
                                        _filteredTasks = List.from(_tasks);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  task['completed'] ? Icons.close : Icons.check,
                                ),
                                label: Text(
                                  task['completed']
                                      ? 'Marcar como pendente'
                                      : 'Marcar como concluída',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      task['completed']
                                          ? Colors.red
                                          : Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  setState(() {
                                    task['completed'] = !task['completed'];
                                    if (_isSearching) {
                                      _filterTasks(_searchController.text);
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
