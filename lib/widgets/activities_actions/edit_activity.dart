import 'package:fitness_tracker/data/categories.dart';
import 'package:fitness_tracker/data/fitness_activity_client.dart';
import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/models/category.dart';
import 'package:fitness_tracker/models/fitness_activity.dart';
import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:duration_picker/duration_picker.dart';

class EditActivity extends StatefulWidget {
  const EditActivity({super.key, required this.activity});

  final FitnessActivity activity;

  @override
  State<EditActivity> createState() {
    return _EditActivityState();
  }
}

class _EditActivityState extends State<EditActivity> {
  final _formKey = GlobalKey<FormState>();

  String? _enteredTitle;
  String? _enteredDescription;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Duration? _selectedDuration;
  Category? _selectedCategory;
  var _isSending = false;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year, now.month + 1, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.activity.date,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      if (pickedDate == null) {
        return;
      }
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: widget.activity.time,
    );
    setState(() {
      if (pickedTime == null) {
        return;
      }
      _selectedTime = pickedTime;
    });
  }

  void _presentDurationPicker() async {
    final pickedDuration = await showDurationPicker(
      context: context,
      initialTime: widget.activity.duration,
      baseUnit: BaseUnit.minute,
      lowerBound: const Duration(minutes: 5),
    );
    setState(() {
      if (pickedDuration == null) {
        return;
      }
      _selectedDuration = pickedDuration;
    });
  }

  void _editFitnessActivity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final fitnessActivity = widget.activity;
      _enteredTitle ??= fitnessActivity.title;
      _enteredDescription ??= fitnessActivity.description;
      _selectedDuration ??= fitnessActivity.duration;
      _selectedDate ??= fitnessActivity.date;
      _selectedTime ??= fitnessActivity.time;
      _selectedCategory ??= fitnessActivity.category;

      final response = await http.patch(
        getPatchUrl(widget.activity.id),
        headers: headers,
        body: json.encode(
          {
            'title': _enteredTitle,
            'description': _enteredDescription,
            'duration': _selectedDuration?.inMinutes,
            'date': readableDate(_selectedDate!),
            'time': readableTimeOfDay(_selectedTime!),
            'category': _selectedCategory?.title,
          },
        ),
      );

      if (response.statusCode >= 400) {
        _isSending = false;
        return;
      }

      if (!mounted) return;

      Navigator.of(context).pop(FitnessActivity(
        id: fitnessActivity.id,
        title: _enteredTitle!,
        description: _enteredDescription!,
        date: _selectedDate!,
        time: _selectedTime!,
        duration: _selectedDuration!,
        category: _selectedCategory!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fitnessActivity = widget.activity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit a Fitness activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  initialValue: fitnessActivity.title,
                  maxLength: 50,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    label: const Text('Title'),
                    floatingLabelStyle: const TextStyle(
                      color: primaryColor,
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: roundedPrimaryColorTextFieldBorder,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  cursorColor: primaryColor,
                  maxLength: 200,
                  maxLines: 3,
                  initialValue: fitnessActivity.description,
                  decoration: InputDecoration(
                    label: const Text('Description (Optional)'),
                    floatingLabelStyle: const TextStyle(
                      color: primaryColor,
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: roundedPrimaryColorTextFieldBorder,
                  ),
                  keyboardType: TextInputType.multiline,
                  onSaved: (newValue) {
                    _enteredDescription = newValue!;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Select date'),
                TextButton(
                  style: roundedBorderTextButton,
                  onPressed: _presentDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        readableDate(_selectedDate ??= fitnessActivity.date),
                        style: primaryColorText,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.calendar_month,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text('Select time'),
                TextButton(
                  style: roundedBorderTextButton,
                  onPressed: _presentTimePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        readableTimeOfDay(
                            _selectedTime ??= fitnessActivity.time),
                        style: primaryColorText,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.watch,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Select duration'),
                TextButton(
                  style: roundedBorderTextButton,
                  onPressed: _presentDurationPicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        readableDuration(
                            _selectedDuration ??= fitnessActivity.duration),
                        style: primaryColorText,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.timer,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Select category',
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                  child: DropdownButtonFormField(
                    value: fitnessActivity.category,
                    items: [
                      for (final category in availableCategories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Text(
                            category.value.title,
                            style: TextStyle(
                              color: category.value.color,
                            ),
                          ),
                        ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _isSending ? null : _editFitnessActivity,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Edit Fitness activity'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
