import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'add_activity_map.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'address': TextEditingController(),
    'date': TextEditingController(),
    'time': TextEditingController(),
  };

  String category = 'Sport'; // Default category
  LatLng? location;

  @override
  void dispose() {
    // Dispose controllers to free resources
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'C R E A T E  A C T I V I T Y',
          style: TextStyle(
            color: Color(0xFF81B29A),
            fontFamily: 'Barlow',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3D405B),
        iconTheme: const IconThemeData(color: Color(0xFF81B29A)),
      ),
      endDrawer: const CustomDrawer(),
      backgroundColor: const Color(0xFF3D405B),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Title',
                  controller: _controllers['title']!,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a title'
                              : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Description',
                  controller: _controllers['description']!,
                  maxLines: 3,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a description'
                              : null,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Category',
                  value: category,
                  onChanged: (value) => setState(() => category = value!),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Address',
                  controller: _controllers['address']!,
                  readOnly: true,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddActivityMap(
                              onLocationSelected: (
                                LatLng selectedLocation,
                                String address,
                              ) {
                                setState(() {
                                  location = selectedLocation;
                                  _controllers['address']!.text = address;
                                });
                              },
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Date',
                  controller: _controllers['date']!,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _controllers['date']!.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Time',
                  controller: _controllers['time']!,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _controllers['time']!.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81B29A),
                      foregroundColor: const Color(0xFF3D405B),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(
                          'Activity created: ${_controllers['title']!.text}, ${_controllers['description']!.text}, $category, ${_controllers['address']!.text}',
                        );
                      }
                    },
                    child: const Text('Create Activity'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, bool isValid) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF3D405B)),
      filled: true,
      fillColor: const Color(0xFFF4F1DE),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isValid ? const Color(0xFF81B29A) : const Color(0xFFE07A5F),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isValid ? const Color(0xFF81B29A) : const Color(0xFFE07A5F),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, controller.text.isNotEmpty),
      style: const TextStyle(color: Color(0xFF3D405B)),
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: (value) {
        setState(() {});
      },
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(label, value.isNotEmpty),
      style: const TextStyle(color: Color(0xFF3D405B)),
      items:
          [
                'Sport',
                'Coffee',
                'Just Meet',
                'Walk',
                'Study',
                'Cook',
                'Board Games',
              ]
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
