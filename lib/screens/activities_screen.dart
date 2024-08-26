import 'dart:async';

import 'package:fitness_tracker/data/categories.dart';
import 'package:fitness_tracker/data/fitness_activity_client.dart';
import 'package:fitness_tracker/main.dart';
import 'package:fitness_tracker/models/activities_filter.dart';
import 'package:fitness_tracker/models/fitness_activity.dart';
import 'package:fitness_tracker/screens/goals_screen.dart';
import 'package:fitness_tracker/utils/formatting_util.dart';
import 'package:fitness_tracker/utils/themes.dart';
import 'package:fitness_tracker/widgets/activities_actions/edit_activity.dart';
import 'package:fitness_tracker/widgets/activities_actions/filter_activities.dart';
import 'package:fitness_tracker/widgets/activities_actions/new_activity.dart';
import 'package:fitness_tracker/widgets/activities_list/activities_list.dart';
import 'package:fitness_tracker/widgets/added_filters.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ActivitiesScreenState();
  }
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<FitnessActivity> _registeredActivities = [];
  List<FitnessActivity> _filteredActivities = [];
  var _isLoading = true;
  String? _error;
  ActivitiesFilter? _filter;
  var _isSearchVisible = false;
  String _searchedText = '';
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadFitnessActivities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadFitnessActivities() async {
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<FitnessActivity> loadedItems = [];
      for (final item in listData.entries) {
        final category = availableCategories.entries
            .firstWhere((categoryItem) =>
                categoryItem.value.title == item.value['category'])
            .value;

        final date = createDateFromString(item.value['date']);
        final time = createTimeFromString(item.value['time']);

        if (date == null || time == null) {
          setState(() {
            _error = 'Invalid data! Problem with parsing date or time.';
          });
          return;
        }

        loadedItems.add(
          FitnessActivity(
            id: item.key,
            title: item.value['title'],
            description: item.value['description'],
            date: date,
            time: time,
            duration: createDurationFromMinutes(item.value['duration']),
            category: category,
          ),
        );
      }
      setState(() {
        _registeredActivities = loadedItems;
        _registeredActivities.sort((a, b) => a.date.compareTo(b.date));
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchedText = _searchController.text;
      });
    });
  }

  void _addFitnessActivity() async {
    final newItem = await Navigator.of(context).push<FitnessActivity>(
      MaterialPageRoute(
        builder: (ctx) => const NewActivity(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _registeredActivities.add(newItem);
    });
  }

  void _openFilterActivitiesOverlay() {
    _closeSearch();
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => FilterActivities(
        onFilterActivities: _addFilters,
      ),
    );
  }

  void _openSearch() {
    setState(() {
      _isSearchVisible = true;
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearchVisible = false;
      _searchController.text = '';
      _searchedText = '';
    });
  }

  void _removeActivity(FitnessActivity activity) async {
    final activityIndex = _registeredActivities.indexOf(activity);
    setState(() {
      _registeredActivities.remove(activity);
    });

    final response = await http.delete(getDeleteUrl(activity.id));

    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        _registeredActivities.insert(activityIndex, activity);
      });
    }
  }

  void _editActivity(FitnessActivity activity) async {
    final activityIndex = _registeredActivities.indexOf(activity);
    final newItem = await Navigator.of(context).push<FitnessActivity>(
      MaterialPageRoute(
        builder: (ctx) => EditActivity(activity: activity),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _registeredActivities.removeAt(activityIndex);
      _registeredActivities.insert(activityIndex, newItem);
    });
  }

  void _addFilters(ActivitiesFilter filter) {
    setState(() {
      _filter = filter;
    });
  }

  void _removeFilters() {
    setState(() {
      _filter = null;
      _filteredActivities = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No activities found. Start adding some!'),
    );

    if (_isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    }

    if (_registeredActivities.isNotEmpty) {
      if (_filter == null && _searchedText.isEmpty) {
        mainContent = ActivitiesList(
          activities: _registeredActivities,
          onRemoveActivity: _removeActivity,
          onChangeActivity: _editActivity,
        );
      } else {
        DateTime startDate = _filter?.dateRange?.start ?? DateTime.now();
        DateTime endDate = _filter?.dateRange?.end ?? DateTime.now();

        _filteredActivities = (_filter?.category != null)
            ? _registeredActivities
                .where((activity) => activity.category == _filter?.category)
                .toList()
            : _registeredActivities;

        _filteredActivities = (_filter?.dateRange != null)
            ? _filteredActivities
                .where((activity) =>
                    activity.date.isAtSameMomentAs(startDate) ||
                    (activity.date.isAfter(startDate) &&
                        activity.date.isBefore(endDate)) ||
                    activity.date.isAtSameMomentAs(endDate))
                .toList()
            : _filteredActivities;

        if (_filteredActivities.isEmpty) {
          mainContent = const Center(
            child: Text('No activities found for that filter criteria.'),
          );
        } else {
          if (_searchedText.isNotEmpty) {
            _filteredActivities = _filteredActivities
                .where((activity) =>
                    activity.title.contains(_searchedText) ||
                    activity.description.contains(_searchedText))
                .toList();
          }

          if (_filteredActivities.isEmpty) {
            mainContent = const Center(
              child: Text('No activities found for that search criteria.'),
            );
          } else {
            mainContent = ActivitiesList(
              activities: _filteredActivities,
              onRemoveActivity: _removeActivity,
              onChangeActivity: _editActivity,
            );
          }
        }
      }
    }

    if (_error != null) {
      mainContent = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Row(
            children: [
              Text(
                'FITNESS',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'TRACKING',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _openSearch,
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: _openFilterActivitiesOverlay,
              icon: const Icon(Icons.filter_alt),
            ),
            IconButton(
              onPressed: _addFitnessActivity,
              icon: const Icon(Icons.add),
            ),
          ]),
      body: Column(children: [
        if (_isSearchVisible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: roundedPrimaryColorTextFieldBorder,
                hintText: 'Search...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: primaryColor,
                        ),
                        onPressed: _closeSearch,
                      )
                    : null,
              ),
            ),
          ),
        if (_filter != null)
          AddedFilters(filters: _filter!, onRemoveFilters: _removeFilters),
        Expanded(
          child: mainContent,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GoalsScreen(activities: _registeredActivities),
                  ),
                );
              },
              child: const Text(
                'Goals',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
