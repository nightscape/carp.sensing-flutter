/// The core CARP domain classes like [Study], [Task], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [CARPDataPoint] as well as deseralization of [Study] objects
/// obtained from a [StudyManager].
library core;

import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import 'package:carp_mobile_sensing/runtime/runtime.dart';

part 'serialization.dart';
part 'study.dart';
part 'tasks.dart';
part 'carp_datapoint.dart';
part 'datum.dart';
part 'measures.dart';
part 'device_info.dart';
part 'managers.dart';
part 'sampling_schema.dart';
part 'privacy_schema.dart';
part 'core.g.dart';
