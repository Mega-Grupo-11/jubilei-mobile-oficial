import 'package:flutter/material.dart';

class TaskFormScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  String _selectedPriority = 'Média';
  List<String> _selectedTags = [];
  final List<String> _availableTags = ['Urgente', 'Trabalho', 'Pessoal'];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!['title'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
      _dateController.text = widget.task!['date'] ?? '';
      _timeController.text = widget.task!['time'] ?? '';
      _selectedPriority = widget.task!['priority'] ?? 'Média';
      _selectedTags = List<String>.from(widget.task!['tags'] ?? []);
    } else {
      // Data padrão: hoje
      _dateController.text =
          DateTime.now().day.toString().padLeft(2, '0') +
          '/' +
          DateTime.now().month.toString().padLeft(2, '0') +
          '/' +
          DateTime.now().year.toString();

      // Hora padrão: agora
      _timeController.text =
          DateTime.now().hour.toString().padLeft(2, '0') +
          ':' +
          DateTime.now().minute.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova tarefa'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: _saveTask)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Digite o título da tarefa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Digite a descrição da tarefa',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              Text('Data', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'DD/MM/YYYY',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          _dateController.text =
                              picked.day.toString().padLeft(2, '0') +
                              '/' +
                              picked.month.toString().padLeft(2, '0') +
                              '/' +
                              picked.year.toString();
                        });
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16),

              Text('Horário', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: 'HH:mm',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _timeController.text =
                              picked.hour.toString().padLeft(2, '0') +
                              ':' +
                              picked.minute.toString().padLeft(2, '0');
                        });
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 16),

              Text('Prioridade', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPriorityButton('Baixa', Colors.green),
                  _buildPriorityButton('Média', Colors.orange),
                  _buildPriorityButton('Alta', Colors.red),
                ],
              ),
              SizedBox(height: 16),

              Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTags.remove(tag);
                            } else {
                              _selectedTags.add(tag);
                            }
                          });
                        },
                        child: Chip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          backgroundColor:
                              isSelected
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade200,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String priority, Color color) {
    final isSelected = _selectedPriority == priority;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          priority,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'priority': _selectedPriority,
        'tags': _selectedTags,
        'completed': false,
      };

      Navigator.pop(context, newTask);
    }
  }
}
