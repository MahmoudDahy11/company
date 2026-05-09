// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncQueueOperation, String>
  operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SyncQueueOperation>($SyncQueueTable.$converteroperation);
  static const VerificationMeta _targetTableNameMeta = const VerificationMeta(
    'targetTableName',
  );
  @override
  late final GeneratedColumn<String> targetTableName = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncQueueStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending'),
      ).withConverter<SyncQueueStatus>($SyncQueueTable.$converterstatus);
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    targetTableName,
    recordId,
    payload,
    createdAt,
    status,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableNameMeta,
        targetTableName.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableNameMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operation: $SyncQueueTable.$converteroperation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}operation'],
        )!,
      ),
      targetTableName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: $SyncQueueTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncQueueOperation, String, String>
  $converteroperation = const EnumNameConverter<SyncQueueOperation>(
    SyncQueueOperation.values,
  );
  static JsonTypeConverter2<SyncQueueStatus, String, String> $converterstatus =
      const EnumNameConverter<SyncQueueStatus>(SyncQueueStatus.values);
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final SyncQueueOperation operation;
  final String targetTableName;
  final int recordId;
  final String payload;
  final DateTime createdAt;
  final SyncQueueStatus status;
  final int retryCount;
  const SyncQueueData({
    required this.id,
    required this.operation,
    required this.targetTableName,
    required this.recordId,
    required this.payload,
    required this.createdAt,
    required this.status,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['operation'] = Variable<String>(
        $SyncQueueTable.$converteroperation.toSql(operation),
      );
    }
    map['table_name'] = Variable<String>(targetTableName);
    map['record_id'] = Variable<int>(recordId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['status'] = Variable<String>(
        $SyncQueueTable.$converterstatus.toSql(status),
      );
    }
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      targetTableName: Value(targetTableName),
      recordId: Value(recordId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      status: Value(status),
      retryCount: Value(retryCount),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: $SyncQueueTable.$converteroperation.fromJson(
        serializer.fromJson<String>(json['operation']),
      ),
      targetTableName: serializer.fromJson<String>(json['targetTableName']),
      recordId: serializer.fromJson<int>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: $SyncQueueTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(
        $SyncQueueTable.$converteroperation.toJson(operation),
      ),
      'targetTableName': serializer.toJson<String>(targetTableName),
      'recordId': serializer.toJson<int>(recordId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(
        $SyncQueueTable.$converterstatus.toJson(status),
      ),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncQueueData copyWith({
    int? id,
    SyncQueueOperation? operation,
    String? targetTableName,
    int? recordId,
    String? payload,
    DateTime? createdAt,
    SyncQueueStatus? status,
    int? retryCount,
  }) => SyncQueueData(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    targetTableName: targetTableName ?? this.targetTableName,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      targetTableName: data.targetTableName.present
          ? data.targetTableName.value
          : this.targetTableName,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTableName: $targetTableName, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operation,
    targetTableName,
    recordId,
    payload,
    createdAt,
    status,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.targetTableName == this.targetTableName &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<SyncQueueOperation> operation;
  final Value<String> targetTableName;
  final Value<int> recordId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<SyncQueueStatus> status;
  final Value<int> retryCount;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.targetTableName = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required SyncQueueOperation operation,
    required String targetTableName,
    required int recordId,
    required String payload,
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : operation = Value(operation),
       targetTableName = Value(targetTableName),
       recordId = Value(recordId),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? targetTableName,
    Expression<int>? recordId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (targetTableName != null) 'table_name': targetTableName,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<SyncQueueOperation>? operation,
    Value<String>? targetTableName,
    Value<int>? recordId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<SyncQueueStatus>? status,
    Value<int>? retryCount,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      targetTableName: targetTableName ?? this.targetTableName,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(
        $SyncQueueTable.$converteroperation.toSql(operation.value),
      );
    }
    if (targetTableName.present) {
      map['table_name'] = Variable<String>(targetTableName.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SyncQueueTable.$converterstatus.toSql(status.value),
      );
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTableName: $targetTableName, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

class $WorkersTable extends Workers with TableInfo<$WorkersTable, Worker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Worker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Worker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Worker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $WorkersTable createAlias(String alias) {
    return $WorkersTable(attachedDatabase, alias);
  }
}

class Worker extends DataClass implements Insertable<Worker> {
  final int id;
  final String name;
  final DateTime createdAt;
  final bool isActive;
  const Worker({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WorkersCompanion toCompanion(bool nullToAbsent) {
    return WorkersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Worker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Worker(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Worker copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    bool? isActive,
  }) => Worker(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  Worker copyWithCompanion(WorkersCompanion data) {
    return Worker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Worker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Worker &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class WorkersCompanion extends UpdateCompanion<Worker> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const WorkersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WorkersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Worker> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WorkersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
  }) {
    return WorkersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $WorkerProductionEntriesTable extends WorkerProductionEntries
    with TableInfo<$WorkerProductionEntriesTable, WorkerProductionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkerProductionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workerIdMeta = const VerificationMeta(
    'workerId',
  );
  @override
  late final GeneratedColumn<int> workerId = GeneratedColumn<int>(
    'worker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workers (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stitchCountMeta = const VerificationMeta(
    'stitchCount',
  );
  @override
  late final GeneratedColumn<int> stitchCount = GeneratedColumn<int>(
    'stitch_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workerId,
    date,
    stitchCount,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worker_production_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkerProductionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('worker_id')) {
      context.handle(
        _workerIdMeta,
        workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('stitch_count')) {
      context.handle(
        _stitchCountMeta,
        stitchCount.isAcceptableOrUnknown(
          data['stitch_count']!,
          _stitchCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stitchCountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkerProductionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkerProductionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worker_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      stitchCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stitch_count'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkerProductionEntriesTable createAlias(String alias) {
    return $WorkerProductionEntriesTable(attachedDatabase, alias);
  }
}

class WorkerProductionEntry extends DataClass
    implements Insertable<WorkerProductionEntry> {
  final int id;
  final int workerId;
  final DateTime date;
  final int stitchCount;
  final String? notes;
  const WorkerProductionEntry({
    required this.id,
    required this.workerId,
    required this.date,
    required this.stitchCount,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['worker_id'] = Variable<int>(workerId);
    map['date'] = Variable<DateTime>(date);
    map['stitch_count'] = Variable<int>(stitchCount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkerProductionEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkerProductionEntriesCompanion(
      id: Value(id),
      workerId: Value(workerId),
      date: Value(date),
      stitchCount: Value(stitchCount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WorkerProductionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkerProductionEntry(
      id: serializer.fromJson<int>(json['id']),
      workerId: serializer.fromJson<int>(json['workerId']),
      date: serializer.fromJson<DateTime>(json['date']),
      stitchCount: serializer.fromJson<int>(json['stitchCount']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workerId': serializer.toJson<int>(workerId),
      'date': serializer.toJson<DateTime>(date),
      'stitchCount': serializer.toJson<int>(stitchCount),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkerProductionEntry copyWith({
    int? id,
    int? workerId,
    DateTime? date,
    int? stitchCount,
    Value<String?> notes = const Value.absent(),
  }) => WorkerProductionEntry(
    id: id ?? this.id,
    workerId: workerId ?? this.workerId,
    date: date ?? this.date,
    stitchCount: stitchCount ?? this.stitchCount,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkerProductionEntry copyWithCompanion(
    WorkerProductionEntriesCompanion data,
  ) {
    return WorkerProductionEntry(
      id: data.id.present ? data.id.value : this.id,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      date: data.date.present ? data.date.value : this.date,
      stitchCount: data.stitchCount.present
          ? data.stitchCount.value
          : this.stitchCount,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkerProductionEntry(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('date: $date, ')
          ..write('stitchCount: $stitchCount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workerId, date, stitchCount, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkerProductionEntry &&
          other.id == this.id &&
          other.workerId == this.workerId &&
          other.date == this.date &&
          other.stitchCount == this.stitchCount &&
          other.notes == this.notes);
}

class WorkerProductionEntriesCompanion
    extends UpdateCompanion<WorkerProductionEntry> {
  final Value<int> id;
  final Value<int> workerId;
  final Value<DateTime> date;
  final Value<int> stitchCount;
  final Value<String?> notes;
  const WorkerProductionEntriesCompanion({
    this.id = const Value.absent(),
    this.workerId = const Value.absent(),
    this.date = const Value.absent(),
    this.stitchCount = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkerProductionEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int workerId,
    required DateTime date,
    required int stitchCount,
    this.notes = const Value.absent(),
  }) : workerId = Value(workerId),
       date = Value(date),
       stitchCount = Value(stitchCount);
  static Insertable<WorkerProductionEntry> custom({
    Expression<int>? id,
    Expression<int>? workerId,
    Expression<DateTime>? date,
    Expression<int>? stitchCount,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workerId != null) 'worker_id': workerId,
      if (date != null) 'date': date,
      if (stitchCount != null) 'stitch_count': stitchCount,
      if (notes != null) 'notes': notes,
    });
  }

  WorkerProductionEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? workerId,
    Value<DateTime>? date,
    Value<int>? stitchCount,
    Value<String?>? notes,
  }) {
    return WorkerProductionEntriesCompanion(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      date: date ?? this.date,
      stitchCount: stitchCount ?? this.stitchCount,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (stitchCount.present) {
      map['stitch_count'] = Variable<int>(stitchCount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkerProductionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('date: $date, ')
          ..write('stitchCount: $stitchCount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WorkerAdvancesTable extends WorkerAdvances
    with TableInfo<$WorkerAdvancesTable, WorkerAdvance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkerAdvancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workerIdMeta = const VerificationMeta(
    'workerId',
  );
  @override
  late final GeneratedColumn<int> workerId = GeneratedColumn<int>(
    'worker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workers (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carriedOverMeta = const VerificationMeta(
    'carriedOver',
  );
  @override
  late final GeneratedColumn<bool> carriedOver = GeneratedColumn<bool>(
    'carried_over',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carried_over" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workerId,
    amount,
    date,
    notes,
    carriedOver,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worker_advances';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkerAdvance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('worker_id')) {
      context.handle(
        _workerIdMeta,
        workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('carried_over')) {
      context.handle(
        _carriedOverMeta,
        carriedOver.isAcceptableOrUnknown(
          data['carried_over']!,
          _carriedOverMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkerAdvance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkerAdvance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worker_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      carriedOver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carried_over'],
      )!,
    );
  }

  @override
  $WorkerAdvancesTable createAlias(String alias) {
    return $WorkerAdvancesTable(attachedDatabase, alias);
  }
}

class WorkerAdvance extends DataClass implements Insertable<WorkerAdvance> {
  final int id;
  final int workerId;
  final double amount;
  final DateTime date;
  final String? notes;
  final bool carriedOver;
  const WorkerAdvance({
    required this.id,
    required this.workerId,
    required this.amount,
    required this.date,
    this.notes,
    required this.carriedOver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['worker_id'] = Variable<int>(workerId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['carried_over'] = Variable<bool>(carriedOver);
    return map;
  }

  WorkerAdvancesCompanion toCompanion(bool nullToAbsent) {
    return WorkerAdvancesCompanion(
      id: Value(id),
      workerId: Value(workerId),
      amount: Value(amount),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      carriedOver: Value(carriedOver),
    );
  }

  factory WorkerAdvance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkerAdvance(
      id: serializer.fromJson<int>(json['id']),
      workerId: serializer.fromJson<int>(json['workerId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      carriedOver: serializer.fromJson<bool>(json['carriedOver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workerId': serializer.toJson<int>(workerId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'carriedOver': serializer.toJson<bool>(carriedOver),
    };
  }

  WorkerAdvance copyWith({
    int? id,
    int? workerId,
    double? amount,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    bool? carriedOver,
  }) => WorkerAdvance(
    id: id ?? this.id,
    workerId: workerId ?? this.workerId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    carriedOver: carriedOver ?? this.carriedOver,
  );
  WorkerAdvance copyWithCompanion(WorkerAdvancesCompanion data) {
    return WorkerAdvance(
      id: data.id.present ? data.id.value : this.id,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      carriedOver: data.carriedOver.present
          ? data.carriedOver.value
          : this.carriedOver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkerAdvance(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('carriedOver: $carriedOver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workerId, amount, date, notes, carriedOver);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkerAdvance &&
          other.id == this.id &&
          other.workerId == this.workerId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.carriedOver == this.carriedOver);
}

class WorkerAdvancesCompanion extends UpdateCompanion<WorkerAdvance> {
  final Value<int> id;
  final Value<int> workerId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<bool> carriedOver;
  const WorkerAdvancesCompanion({
    this.id = const Value.absent(),
    this.workerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.carriedOver = const Value.absent(),
  });
  WorkerAdvancesCompanion.insert({
    this.id = const Value.absent(),
    required int workerId,
    required double amount,
    required DateTime date,
    this.notes = const Value.absent(),
    this.carriedOver = const Value.absent(),
  }) : workerId = Value(workerId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<WorkerAdvance> custom({
    Expression<int>? id,
    Expression<int>? workerId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<bool>? carriedOver,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workerId != null) 'worker_id': workerId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (carriedOver != null) 'carried_over': carriedOver,
    });
  }

  WorkerAdvancesCompanion copyWith({
    Value<int>? id,
    Value<int>? workerId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<bool>? carriedOver,
  }) {
    return WorkerAdvancesCompanion(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      carriedOver: carriedOver ?? this.carriedOver,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (carriedOver.present) {
      map['carried_over'] = Variable<bool>(carriedOver.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkerAdvancesCompanion(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('carriedOver: $carriedOver')
          ..write(')'))
        .toString();
  }
}

class $StitchRatesTable extends StitchRates
    with TableInfo<$StitchRatesTable, StitchRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StitchRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, rate, effectiveFrom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stitch_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<StitchRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StitchRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StitchRate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_from'],
      )!,
    );
  }

  @override
  $StitchRatesTable createAlias(String alias) {
    return $StitchRatesTable(attachedDatabase, alias);
  }
}

class StitchRate extends DataClass implements Insertable<StitchRate> {
  final int id;
  final double rate;
  final DateTime effectiveFrom;
  const StitchRate({
    required this.id,
    required this.rate,
    required this.effectiveFrom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rate'] = Variable<double>(rate);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    return map;
  }

  StitchRatesCompanion toCompanion(bool nullToAbsent) {
    return StitchRatesCompanion(
      id: Value(id),
      rate: Value(rate),
      effectiveFrom: Value(effectiveFrom),
    );
  }

  factory StitchRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StitchRate(
      id: serializer.fromJson<int>(json['id']),
      rate: serializer.fromJson<double>(json['rate']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rate': serializer.toJson<double>(rate),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
    };
  }

  StitchRate copyWith({int? id, double? rate, DateTime? effectiveFrom}) =>
      StitchRate(
        id: id ?? this.id,
        rate: rate ?? this.rate,
        effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      );
  StitchRate copyWithCompanion(StitchRatesCompanion data) {
    return StitchRate(
      id: data.id.present ? data.id.value : this.id,
      rate: data.rate.present ? data.rate.value : this.rate,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StitchRate(')
          ..write('id: $id, ')
          ..write('rate: $rate, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rate, effectiveFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StitchRate &&
          other.id == this.id &&
          other.rate == this.rate &&
          other.effectiveFrom == this.effectiveFrom);
}

class StitchRatesCompanion extends UpdateCompanion<StitchRate> {
  final Value<int> id;
  final Value<double> rate;
  final Value<DateTime> effectiveFrom;
  const StitchRatesCompanion({
    this.id = const Value.absent(),
    this.rate = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
  });
  StitchRatesCompanion.insert({
    this.id = const Value.absent(),
    required double rate,
    required DateTime effectiveFrom,
  }) : rate = Value(rate),
       effectiveFrom = Value(effectiveFrom);
  static Insertable<StitchRate> custom({
    Expression<int>? id,
    Expression<double>? rate,
    Expression<DateTime>? effectiveFrom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rate != null) 'rate': rate,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
    });
  }

  StitchRatesCompanion copyWith({
    Value<int>? id,
    Value<double>? rate,
    Value<DateTime>? effectiveFrom,
  }) {
    return StitchRatesCompanion(
      id: id ?? this.id,
      rate: rate ?? this.rate,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StitchRatesCompanion(')
          ..write('id: $id, ')
          ..write('rate: $rate, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }
}

class $WorkerAbsentDaysTable extends WorkerAbsentDays
    with TableInfo<$WorkerAbsentDaysTable, WorkerAbsentDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkerAbsentDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workerIdMeta = const VerificationMeta(
    'workerId',
  );
  @override
  late final GeneratedColumn<int> workerId = GeneratedColumn<int>(
    'worker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workers (id)',
    ),
  );
  static const VerificationMeta _monthStartMeta = const VerificationMeta(
    'monthStart',
  );
  @override
  late final GeneratedColumn<DateTime> monthStart = GeneratedColumn<DateTime>(
    'month_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _absentDaysMeta = const VerificationMeta(
    'absentDays',
  );
  @override
  late final GeneratedColumn<int> absentDays = GeneratedColumn<int>(
    'absent_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, workerId, monthStart, absentDays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worker_absent_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkerAbsentDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('worker_id')) {
      context.handle(
        _workerIdMeta,
        workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('month_start')) {
      context.handle(
        _monthStartMeta,
        monthStart.isAcceptableOrUnknown(data['month_start']!, _monthStartMeta),
      );
    } else if (isInserting) {
      context.missing(_monthStartMeta);
    }
    if (data.containsKey('absent_days')) {
      context.handle(
        _absentDaysMeta,
        absentDays.isAcceptableOrUnknown(data['absent_days']!, _absentDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workerId, monthStart},
  ];
  @override
  WorkerAbsentDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkerAbsentDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worker_id'],
      )!,
      monthStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}month_start'],
      )!,
      absentDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}absent_days'],
      )!,
    );
  }

  @override
  $WorkerAbsentDaysTable createAlias(String alias) {
    return $WorkerAbsentDaysTable(attachedDatabase, alias);
  }
}

class WorkerAbsentDay extends DataClass implements Insertable<WorkerAbsentDay> {
  final int id;
  final int workerId;
  final DateTime monthStart;
  final int absentDays;
  const WorkerAbsentDay({
    required this.id,
    required this.workerId,
    required this.monthStart,
    required this.absentDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['worker_id'] = Variable<int>(workerId);
    map['month_start'] = Variable<DateTime>(monthStart);
    map['absent_days'] = Variable<int>(absentDays);
    return map;
  }

  WorkerAbsentDaysCompanion toCompanion(bool nullToAbsent) {
    return WorkerAbsentDaysCompanion(
      id: Value(id),
      workerId: Value(workerId),
      monthStart: Value(monthStart),
      absentDays: Value(absentDays),
    );
  }

  factory WorkerAbsentDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkerAbsentDay(
      id: serializer.fromJson<int>(json['id']),
      workerId: serializer.fromJson<int>(json['workerId']),
      monthStart: serializer.fromJson<DateTime>(json['monthStart']),
      absentDays: serializer.fromJson<int>(json['absentDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workerId': serializer.toJson<int>(workerId),
      'monthStart': serializer.toJson<DateTime>(monthStart),
      'absentDays': serializer.toJson<int>(absentDays),
    };
  }

  WorkerAbsentDay copyWith({
    int? id,
    int? workerId,
    DateTime? monthStart,
    int? absentDays,
  }) => WorkerAbsentDay(
    id: id ?? this.id,
    workerId: workerId ?? this.workerId,
    monthStart: monthStart ?? this.monthStart,
    absentDays: absentDays ?? this.absentDays,
  );
  WorkerAbsentDay copyWithCompanion(WorkerAbsentDaysCompanion data) {
    return WorkerAbsentDay(
      id: data.id.present ? data.id.value : this.id,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      monthStart: data.monthStart.present
          ? data.monthStart.value
          : this.monthStart,
      absentDays: data.absentDays.present
          ? data.absentDays.value
          : this.absentDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkerAbsentDay(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('monthStart: $monthStart, ')
          ..write('absentDays: $absentDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workerId, monthStart, absentDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkerAbsentDay &&
          other.id == this.id &&
          other.workerId == this.workerId &&
          other.monthStart == this.monthStart &&
          other.absentDays == this.absentDays);
}

class WorkerAbsentDaysCompanion extends UpdateCompanion<WorkerAbsentDay> {
  final Value<int> id;
  final Value<int> workerId;
  final Value<DateTime> monthStart;
  final Value<int> absentDays;
  const WorkerAbsentDaysCompanion({
    this.id = const Value.absent(),
    this.workerId = const Value.absent(),
    this.monthStart = const Value.absent(),
    this.absentDays = const Value.absent(),
  });
  WorkerAbsentDaysCompanion.insert({
    this.id = const Value.absent(),
    required int workerId,
    required DateTime monthStart,
    this.absentDays = const Value.absent(),
  }) : workerId = Value(workerId),
       monthStart = Value(monthStart);
  static Insertable<WorkerAbsentDay> custom({
    Expression<int>? id,
    Expression<int>? workerId,
    Expression<DateTime>? monthStart,
    Expression<int>? absentDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workerId != null) 'worker_id': workerId,
      if (monthStart != null) 'month_start': monthStart,
      if (absentDays != null) 'absent_days': absentDays,
    });
  }

  WorkerAbsentDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? workerId,
    Value<DateTime>? monthStart,
    Value<int>? absentDays,
  }) {
    return WorkerAbsentDaysCompanion(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      monthStart: monthStart ?? this.monthStart,
      absentDays: absentDays ?? this.absentDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
    }
    if (monthStart.present) {
      map['month_start'] = Variable<DateTime>(monthStart.value);
    }
    if (absentDays.present) {
      map['absent_days'] = Variable<int>(absentDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkerAbsentDaysCompanion(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('monthStart: $monthStart, ')
          ..write('absentDays: $absentDays')
          ..write(')'))
        .toString();
  }
}

class $WomenStaffMembersTable extends WomenStaffMembers
    with TableInfo<$WomenStaffMembersTable, WomenStaffMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WomenStaffMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlySalaryMeta = const VerificationMeta(
    'monthlySalary',
  );
  @override
  late final GeneratedColumn<double> monthlySalary = GeneratedColumn<double>(
    'monthly_salary',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    monthlySalary,
    createdAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'women_staff_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<WomenStaffMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
        _monthlySalaryMeta,
        monthlySalary.isAcceptableOrUnknown(
          data['monthly_salary']!,
          _monthlySalaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlySalaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WomenStaffMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WomenStaffMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      monthlySalary: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_salary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $WomenStaffMembersTable createAlias(String alias) {
    return $WomenStaffMembersTable(attachedDatabase, alias);
  }
}

class WomenStaffMember extends DataClass
    implements Insertable<WomenStaffMember> {
  final int id;
  final String name;
  final double monthlySalary;
  final DateTime createdAt;
  final bool isActive;
  const WomenStaffMember({
    required this.id,
    required this.name,
    required this.monthlySalary,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['monthly_salary'] = Variable<double>(monthlySalary);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WomenStaffMembersCompanion toCompanion(bool nullToAbsent) {
    return WomenStaffMembersCompanion(
      id: Value(id),
      name: Value(name),
      monthlySalary: Value(monthlySalary),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory WomenStaffMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WomenStaffMember(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      monthlySalary: serializer.fromJson<double>(json['monthlySalary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'monthlySalary': serializer.toJson<double>(monthlySalary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  WomenStaffMember copyWith({
    int? id,
    String? name,
    double? monthlySalary,
    DateTime? createdAt,
    bool? isActive,
  }) => WomenStaffMember(
    id: id ?? this.id,
    name: name ?? this.name,
    monthlySalary: monthlySalary ?? this.monthlySalary,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  WomenStaffMember copyWithCompanion(WomenStaffMembersCompanion data) {
    return WomenStaffMember(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WomenStaffMember(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, monthlySalary, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WomenStaffMember &&
          other.id == this.id &&
          other.name == this.name &&
          other.monthlySalary == this.monthlySalary &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class WomenStaffMembersCompanion extends UpdateCompanion<WomenStaffMember> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> monthlySalary;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const WomenStaffMembersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WomenStaffMembersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double monthlySalary,
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       monthlySalary = Value(monthlySalary);
  static Insertable<WomenStaffMember> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? monthlySalary,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WomenStaffMembersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? monthlySalary,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
  }) {
    return WomenStaffMembersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<double>(monthlySalary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WomenStaffMembersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $StaffAdvancesTable extends StaffAdvances
    with TableInfo<$StaffAdvancesTable, StaffAdvance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffAdvancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES women_staff_members (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carriedOverMeta = const VerificationMeta(
    'carriedOver',
  );
  @override
  late final GeneratedColumn<bool> carriedOver = GeneratedColumn<bool>(
    'carried_over',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carried_over" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    staffId,
    amount,
    date,
    notes,
    carriedOver,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_advances';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffAdvance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('carried_over')) {
      context.handle(
        _carriedOverMeta,
        carriedOver.isAcceptableOrUnknown(
          data['carried_over']!,
          _carriedOverMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffAdvance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffAdvance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      carriedOver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carried_over'],
      )!,
    );
  }

  @override
  $StaffAdvancesTable createAlias(String alias) {
    return $StaffAdvancesTable(attachedDatabase, alias);
  }
}

class StaffAdvance extends DataClass implements Insertable<StaffAdvance> {
  final int id;
  final int staffId;
  final double amount;
  final DateTime date;
  final String? notes;
  final bool carriedOver;
  const StaffAdvance({
    required this.id,
    required this.staffId,
    required this.amount,
    required this.date,
    this.notes,
    required this.carriedOver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['carried_over'] = Variable<bool>(carriedOver);
    return map;
  }

  StaffAdvancesCompanion toCompanion(bool nullToAbsent) {
    return StaffAdvancesCompanion(
      id: Value(id),
      staffId: Value(staffId),
      amount: Value(amount),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      carriedOver: Value(carriedOver),
    );
  }

  factory StaffAdvance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffAdvance(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      carriedOver: serializer.fromJson<bool>(json['carriedOver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'carriedOver': serializer.toJson<bool>(carriedOver),
    };
  }

  StaffAdvance copyWith({
    int? id,
    int? staffId,
    double? amount,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    bool? carriedOver,
  }) => StaffAdvance(
    id: id ?? this.id,
    staffId: staffId ?? this.staffId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    carriedOver: carriedOver ?? this.carriedOver,
  );
  StaffAdvance copyWithCompanion(StaffAdvancesCompanion data) {
    return StaffAdvance(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      carriedOver: data.carriedOver.present
          ? data.carriedOver.value
          : this.carriedOver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffAdvance(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('carriedOver: $carriedOver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, staffId, amount, date, notes, carriedOver);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffAdvance &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.carriedOver == this.carriedOver);
}

class StaffAdvancesCompanion extends UpdateCompanion<StaffAdvance> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<bool> carriedOver;
  const StaffAdvancesCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.carriedOver = const Value.absent(),
  });
  StaffAdvancesCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    required double amount,
    required DateTime date,
    this.notes = const Value.absent(),
    this.carriedOver = const Value.absent(),
  }) : staffId = Value(staffId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<StaffAdvance> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<bool>? carriedOver,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (carriedOver != null) 'carried_over': carriedOver,
    });
  }

  StaffAdvancesCompanion copyWith({
    Value<int>? id,
    Value<int>? staffId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<bool>? carriedOver,
  }) {
    return StaffAdvancesCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      carriedOver: carriedOver ?? this.carriedOver,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (carriedOver.present) {
      map['carried_over'] = Variable<bool>(carriedOver.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffAdvancesCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('carriedOver: $carriedOver')
          ..write(')'))
        .toString();
  }
}

class $StaffDeductionsTable extends StaffDeductions
    with TableInfo<$StaffDeductionsTable, StaffDeduction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffDeductionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _staffIdMeta = const VerificationMeta(
    'staffId',
  );
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
    'staff_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES women_staff_members (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, staffId, amount, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_deductions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StaffDeduction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(
        _staffIdMeta,
        staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffDeduction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffDeduction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      staffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}staff_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $StaffDeductionsTable createAlias(String alias) {
    return $StaffDeductionsTable(attachedDatabase, alias);
  }
}

class StaffDeduction extends DataClass implements Insertable<StaffDeduction> {
  final int id;
  final int staffId;
  final double amount;
  final DateTime date;
  final String? notes;
  const StaffDeduction({
    required this.id,
    required this.staffId,
    required this.amount,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StaffDeductionsCompanion toCompanion(bool nullToAbsent) {
    return StaffDeductionsCompanion(
      id: Value(id),
      staffId: Value(staffId),
      amount: Value(amount),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory StaffDeduction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffDeduction(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StaffDeduction copyWith({
    int? id,
    int? staffId,
    double? amount,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => StaffDeduction(
    id: id ?? this.id,
    staffId: staffId ?? this.staffId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  StaffDeduction copyWithCompanion(StaffDeductionsCompanion data) {
    return StaffDeduction(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffDeduction(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, staffId, amount, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffDeduction &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.notes == this.notes);
}

class StaffDeductionsCompanion extends UpdateCompanion<StaffDeduction> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> notes;
  const StaffDeductionsCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  StaffDeductionsCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    required double amount,
    required DateTime date,
    this.notes = const Value.absent(),
  }) : staffId = Value(staffId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<StaffDeduction> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  StaffDeductionsCompanion copyWith({
    Value<int>? id,
    Value<int>? staffId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? notes,
  }) {
    return StaffDeductionsCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffDeductionsCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? phone;
  final DateTime createdAt;
  const Supplier({
    required this.id,
    required this.name,
    this.phone,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Supplier copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    DateTime? createdAt,
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    createdAt: createdAt ?? this.createdAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<DateTime> createdAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<DateTime>? createdAt,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ThreadPurchasesTable extends ThreadPurchases
    with TableInfo<$ThreadPurchasesTable, ThreadPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThreadPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorNumberMeta = const VerificationMeta(
    'colorNumber',
  );
  @override
  late final GeneratedColumn<String> colorNumber = GeneratedColumn<String>(
    'color_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierId,
    itemName,
    colorNumber,
    purchaseDate,
    price,
    quantity,
    unit,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thread_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThreadPurchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('color_number')) {
      context.handle(
        _colorNumberMeta,
        colorNumber.isAcceptableOrUnknown(
          data['color_number']!,
          _colorNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colorNumberMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThreadPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThreadPurchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      colorNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_number'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ThreadPurchasesTable createAlias(String alias) {
    return $ThreadPurchasesTable(attachedDatabase, alias);
  }
}

class ThreadPurchase extends DataClass implements Insertable<ThreadPurchase> {
  final int id;
  final int supplierId;
  final String itemName;
  final String colorNumber;
  final DateTime purchaseDate;
  final double price;
  final double quantity;
  final String unit;
  final String? notes;
  const ThreadPurchase({
    required this.id,
    required this.supplierId,
    required this.itemName,
    required this.colorNumber,
    required this.purchaseDate,
    required this.price,
    required this.quantity,
    required this.unit,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['item_name'] = Variable<String>(itemName);
    map['color_number'] = Variable<String>(colorNumber);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ThreadPurchasesCompanion toCompanion(bool nullToAbsent) {
    return ThreadPurchasesCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      itemName: Value(itemName),
      colorNumber: Value(colorNumber),
      purchaseDate: Value(purchaseDate),
      price: Value(price),
      quantity: Value(quantity),
      unit: Value(unit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ThreadPurchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThreadPurchase(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      colorNumber: serializer.fromJson<String>(json['colorNumber']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'itemName': serializer.toJson<String>(itemName),
      'colorNumber': serializer.toJson<String>(colorNumber),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ThreadPurchase copyWith({
    int? id,
    int? supplierId,
    String? itemName,
    String? colorNumber,
    DateTime? purchaseDate,
    double? price,
    double? quantity,
    String? unit,
    Value<String?> notes = const Value.absent(),
  }) => ThreadPurchase(
    id: id ?? this.id,
    supplierId: supplierId ?? this.supplierId,
    itemName: itemName ?? this.itemName,
    colorNumber: colorNumber ?? this.colorNumber,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    notes: notes.present ? notes.value : this.notes,
  );
  ThreadPurchase copyWithCompanion(ThreadPurchasesCompanion data) {
    return ThreadPurchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      colorNumber: data.colorNumber.present
          ? data.colorNumber.value
          : this.colorNumber,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThreadPurchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('itemName: $itemName, ')
          ..write('colorNumber: $colorNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    supplierId,
    itemName,
    colorNumber,
    purchaseDate,
    price,
    quantity,
    unit,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThreadPurchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.itemName == this.itemName &&
          other.colorNumber == this.colorNumber &&
          other.purchaseDate == this.purchaseDate &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.notes == this.notes);
}

class ThreadPurchasesCompanion extends UpdateCompanion<ThreadPurchase> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<String> itemName;
  final Value<String> colorNumber;
  final Value<DateTime> purchaseDate;
  final Value<double> price;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String?> notes;
  const ThreadPurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.colorNumber = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ThreadPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required String itemName,
    required String colorNumber,
    required DateTime purchaseDate,
    required double price,
    required double quantity,
    required String unit,
    this.notes = const Value.absent(),
  }) : supplierId = Value(supplierId),
       itemName = Value(itemName),
       colorNumber = Value(colorNumber),
       purchaseDate = Value(purchaseDate),
       price = Value(price),
       quantity = Value(quantity),
       unit = Value(unit);
  static Insertable<ThreadPurchase> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? itemName,
    Expression<String>? colorNumber,
    Expression<DateTime>? purchaseDate,
    Expression<double>? price,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (itemName != null) 'item_name': itemName,
      if (colorNumber != null) 'color_number': colorNumber,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
    });
  }

  ThreadPurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? supplierId,
    Value<String>? itemName,
    Value<String>? colorNumber,
    Value<DateTime>? purchaseDate,
    Value<double>? price,
    Value<double>? quantity,
    Value<String>? unit,
    Value<String?>? notes,
  }) {
    return ThreadPurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      itemName: itemName ?? this.itemName,
      colorNumber: colorNumber ?? this.colorNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (colorNumber.present) {
      map['color_number'] = Variable<String>(colorNumber.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('itemName: $itemName, ')
          ..write('colorNumber: $colorNumber, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SupplierPaymentsTable extends SupplierPayments
    with TableInfo<$SupplierPaymentsTable, SupplierPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierId,
    amount,
    paymentDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SupplierPaymentsTable createAlias(String alias) {
    return $SupplierPaymentsTable(attachedDatabase, alias);
  }
}

class SupplierPayment extends DataClass implements Insertable<SupplierPayment> {
  final int id;
  final int supplierId;
  final double amount;
  final DateTime paymentDate;
  final String? notes;
  const SupplierPayment({
    required this.id,
    required this.supplierId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['amount'] = Variable<double>(amount);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SupplierPaymentsCompanion toCompanion(bool nullToAbsent) {
    return SupplierPaymentsCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      amount: Value(amount),
      paymentDate: Value(paymentDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory SupplierPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierPayment(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'amount': serializer.toJson<double>(amount),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  SupplierPayment copyWith({
    int? id,
    int? supplierId,
    double? amount,
    DateTime? paymentDate,
    Value<String?> notes = const Value.absent(),
  }) => SupplierPayment(
    id: id ?? this.id,
    supplierId: supplierId ?? this.supplierId,
    amount: amount ?? this.amount,
    paymentDate: paymentDate ?? this.paymentDate,
    notes: notes.present ? notes.value : this.notes,
  );
  SupplierPayment copyWithCompanion(SupplierPaymentsCompanion data) {
    return SupplierPayment(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierPayment(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, supplierId, amount, paymentDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierPayment &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.amount == this.amount &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes);
}

class SupplierPaymentsCompanion extends UpdateCompanion<SupplierPayment> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<double> amount;
  final Value<DateTime> paymentDate;
  final Value<String?> notes;
  const SupplierPaymentsCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  SupplierPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required double amount,
    required DateTime paymentDate,
    this.notes = const Value.absent(),
  }) : supplierId = Value(supplierId),
       amount = Value(amount),
       paymentDate = Value(paymentDate);
  static Insertable<SupplierPayment> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<double>? amount,
    Expression<DateTime>? paymentDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
    });
  }

  SupplierPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? supplierId,
    Value<double>? amount,
    Value<DateTime>? paymentDate,
    Value<String?>? notes,
  }) {
    return SupplierPaymentsCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final bool isActive;
  const Client({
    required this.id,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Client copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    DateTime? createdAt,
    bool? isActive,
  }) => Client(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ClientModelsTable extends ClientModels
    with TableInfo<$ClientModelsTable, ClientModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _modelNameMeta = const VerificationMeta(
    'modelName',
  );
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
    'model_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pieceCountMeta = const VerificationMeta(
    'pieceCount',
  );
  @override
  late final GeneratedColumn<int> pieceCount = GeneratedColumn<int>(
    'piece_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerPieceMeta = const VerificationMeta(
    'pricePerPiece',
  );
  @override
  late final GeneratedColumn<double> pricePerPiece = GeneratedColumn<double>(
    'price_per_piece',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    modelName,
    pieceCount,
    pricePerPiece,
    date,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_models';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('model_name')) {
      context.handle(
        _modelNameMeta,
        modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta),
      );
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('piece_count')) {
      context.handle(
        _pieceCountMeta,
        pieceCount.isAcceptableOrUnknown(data['piece_count']!, _pieceCountMeta),
      );
    } else if (isInserting) {
      context.missing(_pieceCountMeta);
    }
    if (data.containsKey('price_per_piece')) {
      context.handle(
        _pricePerPieceMeta,
        pricePerPiece.isAcceptableOrUnknown(
          data['price_per_piece']!,
          _pricePerPieceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerPieceMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      modelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_name'],
      )!,
      pieceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}piece_count'],
      )!,
      pricePerPiece: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_piece'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ClientModelsTable createAlias(String alias) {
    return $ClientModelsTable(attachedDatabase, alias);
  }
}

class ClientModel extends DataClass implements Insertable<ClientModel> {
  final int id;
  final int clientId;
  final String modelName;
  final int pieceCount;
  final double pricePerPiece;
  final DateTime date;
  final String? notes;
  const ClientModel({
    required this.id,
    required this.clientId,
    required this.modelName,
    required this.pieceCount,
    required this.pricePerPiece,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['model_name'] = Variable<String>(modelName);
    map['piece_count'] = Variable<int>(pieceCount);
    map['price_per_piece'] = Variable<double>(pricePerPiece);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ClientModelsCompanion toCompanion(bool nullToAbsent) {
    return ClientModelsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      modelName: Value(modelName),
      pieceCount: Value(pieceCount),
      pricePerPiece: Value(pricePerPiece),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ClientModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientModel(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      modelName: serializer.fromJson<String>(json['modelName']),
      pieceCount: serializer.fromJson<int>(json['pieceCount']),
      pricePerPiece: serializer.fromJson<double>(json['pricePerPiece']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'modelName': serializer.toJson<String>(modelName),
      'pieceCount': serializer.toJson<int>(pieceCount),
      'pricePerPiece': serializer.toJson<double>(pricePerPiece),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ClientModel copyWith({
    int? id,
    int? clientId,
    String? modelName,
    int? pieceCount,
    double? pricePerPiece,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => ClientModel(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    modelName: modelName ?? this.modelName,
    pieceCount: pieceCount ?? this.pieceCount,
    pricePerPiece: pricePerPiece ?? this.pricePerPiece,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  ClientModel copyWithCompanion(ClientModelsCompanion data) {
    return ClientModel(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      pieceCount: data.pieceCount.present
          ? data.pieceCount.value
          : this.pieceCount,
      pricePerPiece: data.pricePerPiece.present
          ? data.pricePerPiece.value
          : this.pricePerPiece,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientModel(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('modelName: $modelName, ')
          ..write('pieceCount: $pieceCount, ')
          ..write('pricePerPiece: $pricePerPiece, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    modelName,
    pieceCount,
    pricePerPiece,
    date,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientModel &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.modelName == this.modelName &&
          other.pieceCount == this.pieceCount &&
          other.pricePerPiece == this.pricePerPiece &&
          other.date == this.date &&
          other.notes == this.notes);
}

class ClientModelsCompanion extends UpdateCompanion<ClientModel> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<String> modelName;
  final Value<int> pieceCount;
  final Value<double> pricePerPiece;
  final Value<DateTime> date;
  final Value<String?> notes;
  const ClientModelsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.modelName = const Value.absent(),
    this.pieceCount = const Value.absent(),
    this.pricePerPiece = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ClientModelsCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required String modelName,
    required int pieceCount,
    required double pricePerPiece,
    required DateTime date,
    this.notes = const Value.absent(),
  }) : clientId = Value(clientId),
       modelName = Value(modelName),
       pieceCount = Value(pieceCount),
       pricePerPiece = Value(pricePerPiece),
       date = Value(date);
  static Insertable<ClientModel> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? modelName,
    Expression<int>? pieceCount,
    Expression<double>? pricePerPiece,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (modelName != null) 'model_name': modelName,
      if (pieceCount != null) 'piece_count': pieceCount,
      if (pricePerPiece != null) 'price_per_piece': pricePerPiece,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  ClientModelsCompanion copyWith({
    Value<int>? id,
    Value<int>? clientId,
    Value<String>? modelName,
    Value<int>? pieceCount,
    Value<double>? pricePerPiece,
    Value<DateTime>? date,
    Value<String?>? notes,
  }) {
    return ClientModelsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      modelName: modelName ?? this.modelName,
      pieceCount: pieceCount ?? this.pieceCount,
      pricePerPiece: pricePerPiece ?? this.pricePerPiece,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (pieceCount.present) {
      map['piece_count'] = Variable<int>(pieceCount.value);
    }
    if (pricePerPiece.present) {
      map['price_per_piece'] = Variable<double>(pricePerPiece.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientModelsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('modelName: $modelName, ')
          ..write('pieceCount: $pieceCount, ')
          ..write('pricePerPiece: $pricePerPiece, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ClientPaymentsTable extends ClientPayments
    with TableInfo<$ClientPaymentsTable, ClientPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    amount,
    paymentDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ClientPaymentsTable createAlias(String alias) {
    return $ClientPaymentsTable(attachedDatabase, alias);
  }
}

class ClientPayment extends DataClass implements Insertable<ClientPayment> {
  final int id;
  final int clientId;
  final double amount;
  final DateTime paymentDate;
  final String? notes;
  const ClientPayment({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['amount'] = Variable<double>(amount);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ClientPaymentsCompanion toCompanion(bool nullToAbsent) {
    return ClientPaymentsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      amount: Value(amount),
      paymentDate: Value(paymentDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ClientPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientPayment(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'amount': serializer.toJson<double>(amount),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ClientPayment copyWith({
    int? id,
    int? clientId,
    double? amount,
    DateTime? paymentDate,
    Value<String?> notes = const Value.absent(),
  }) => ClientPayment(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    amount: amount ?? this.amount,
    paymentDate: paymentDate ?? this.paymentDate,
    notes: notes.present ? notes.value : this.notes,
  );
  ClientPayment copyWithCompanion(ClientPaymentsCompanion data) {
    return ClientPayment(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientPayment(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, amount, paymentDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientPayment &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.amount == this.amount &&
          other.paymentDate == this.paymentDate &&
          other.notes == this.notes);
}

class ClientPaymentsCompanion extends UpdateCompanion<ClientPayment> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<double> amount;
  final Value<DateTime> paymentDate;
  final Value<String?> notes;
  const ClientPaymentsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ClientPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required double amount,
    required DateTime paymentDate,
    this.notes = const Value.absent(),
  }) : clientId = Value(clientId),
       amount = Value(amount),
       paymentDate = Value(paymentDate);
  static Insertable<ClientPayment> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<double>? amount,
    Expression<DateTime>? paymentDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (amount != null) 'amount': amount,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (notes != null) 'notes': notes,
    });
  }

  ClientPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? clientId,
    Value<double>? amount,
    Value<DateTime>? paymentDate,
    Value<String?>? notes,
  }) {
    return ClientPaymentsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('amount: $amount, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceFaultRecordsTable extends MaintenanceFaultRecords
    with TableInfo<$MaintenanceFaultRecordsTable, MaintenanceFaultRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceFaultRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _machineNameMeta = const VerificationMeta(
    'machineName',
  );
  @override
  late final GeneratedColumn<String> machineName = GeneratedColumn<String>(
    'machine_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faultNameMeta = const VerificationMeta(
    'faultName',
  );
  @override
  late final GeneratedColumn<String> faultName = GeneratedColumn<String>(
    'fault_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    machineName,
    faultName,
    cost,
    totalCost,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_fault_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceFaultRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('machine_name')) {
      context.handle(
        _machineNameMeta,
        machineName.isAcceptableOrUnknown(
          data['machine_name']!,
          _machineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_machineNameMeta);
    }
    if (data.containsKey('fault_name')) {
      context.handle(
        _faultNameMeta,
        faultName.isAcceptableOrUnknown(data['fault_name']!, _faultNameMeta),
      );
    } else if (isInserting) {
      context.missing(_faultNameMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceFaultRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceFaultRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      machineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_name'],
      )!,
      faultName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fault_name'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MaintenanceFaultRecordsTable createAlias(String alias) {
    return $MaintenanceFaultRecordsTable(attachedDatabase, alias);
  }
}

class MaintenanceFaultRecord extends DataClass
    implements Insertable<MaintenanceFaultRecord> {
  final int id;
  final String machineName;
  final String faultName;
  final double cost;
  final double totalCost;
  final DateTime createdAt;
  const MaintenanceFaultRecord({
    required this.id,
    required this.machineName,
    required this.faultName,
    required this.cost,
    required this.totalCost,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['machine_name'] = Variable<String>(machineName);
    map['fault_name'] = Variable<String>(faultName);
    map['cost'] = Variable<double>(cost);
    map['total_cost'] = Variable<double>(totalCost);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MaintenanceFaultRecordsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceFaultRecordsCompanion(
      id: Value(id),
      machineName: Value(machineName),
      faultName: Value(faultName),
      cost: Value(cost),
      totalCost: Value(totalCost),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceFaultRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceFaultRecord(
      id: serializer.fromJson<int>(json['id']),
      machineName: serializer.fromJson<String>(json['machineName']),
      faultName: serializer.fromJson<String>(json['faultName']),
      cost: serializer.fromJson<double>(json['cost']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'machineName': serializer.toJson<String>(machineName),
      'faultName': serializer.toJson<String>(faultName),
      'cost': serializer.toJson<double>(cost),
      'totalCost': serializer.toJson<double>(totalCost),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MaintenanceFaultRecord copyWith({
    int? id,
    String? machineName,
    String? faultName,
    double? cost,
    double? totalCost,
    DateTime? createdAt,
  }) => MaintenanceFaultRecord(
    id: id ?? this.id,
    machineName: machineName ?? this.machineName,
    faultName: faultName ?? this.faultName,
    cost: cost ?? this.cost,
    totalCost: totalCost ?? this.totalCost,
    createdAt: createdAt ?? this.createdAt,
  );
  MaintenanceFaultRecord copyWithCompanion(
    MaintenanceFaultRecordsCompanion data,
  ) {
    return MaintenanceFaultRecord(
      id: data.id.present ? data.id.value : this.id,
      machineName: data.machineName.present
          ? data.machineName.value
          : this.machineName,
      faultName: data.faultName.present ? data.faultName.value : this.faultName,
      cost: data.cost.present ? data.cost.value : this.cost,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceFaultRecord(')
          ..write('id: $id, ')
          ..write('machineName: $machineName, ')
          ..write('faultName: $faultName, ')
          ..write('cost: $cost, ')
          ..write('totalCost: $totalCost, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, machineName, faultName, cost, totalCost, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceFaultRecord &&
          other.id == this.id &&
          other.machineName == this.machineName &&
          other.faultName == this.faultName &&
          other.cost == this.cost &&
          other.totalCost == this.totalCost &&
          other.createdAt == this.createdAt);
}

class MaintenanceFaultRecordsCompanion
    extends UpdateCompanion<MaintenanceFaultRecord> {
  final Value<int> id;
  final Value<String> machineName;
  final Value<String> faultName;
  final Value<double> cost;
  final Value<double> totalCost;
  final Value<DateTime> createdAt;
  const MaintenanceFaultRecordsCompanion({
    this.id = const Value.absent(),
    this.machineName = const Value.absent(),
    this.faultName = const Value.absent(),
    this.cost = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MaintenanceFaultRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String machineName,
    required String faultName,
    required double cost,
    required double totalCost,
    this.createdAt = const Value.absent(),
  }) : machineName = Value(machineName),
       faultName = Value(faultName),
       cost = Value(cost),
       totalCost = Value(totalCost);
  static Insertable<MaintenanceFaultRecord> custom({
    Expression<int>? id,
    Expression<String>? machineName,
    Expression<String>? faultName,
    Expression<double>? cost,
    Expression<double>? totalCost,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (machineName != null) 'machine_name': machineName,
      if (faultName != null) 'fault_name': faultName,
      if (cost != null) 'cost': cost,
      if (totalCost != null) 'total_cost': totalCost,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MaintenanceFaultRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? machineName,
    Value<String>? faultName,
    Value<double>? cost,
    Value<double>? totalCost,
    Value<DateTime>? createdAt,
  }) {
    return MaintenanceFaultRecordsCompanion(
      id: id ?? this.id,
      machineName: machineName ?? this.machineName,
      faultName: faultName ?? this.faultName,
      cost: cost ?? this.cost,
      totalCost: totalCost ?? this.totalCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (machineName.present) {
      map['machine_name'] = Variable<String>(machineName.value);
    }
    if (faultName.present) {
      map['fault_name'] = Variable<String>(faultName.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceFaultRecordsCompanion(')
          ..write('id: $id, ')
          ..write('machineName: $machineName, ')
          ..write('faultName: $faultName, ')
          ..write('cost: $cost, ')
          ..write('totalCost: $totalCost, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $WorkersTable workers = $WorkersTable(this);
  late final $WorkerProductionEntriesTable workerProductionEntries =
      $WorkerProductionEntriesTable(this);
  late final $WorkerAdvancesTable workerAdvances = $WorkerAdvancesTable(this);
  late final $StitchRatesTable stitchRates = $StitchRatesTable(this);
  late final $WorkerAbsentDaysTable workerAbsentDays = $WorkerAbsentDaysTable(
    this,
  );
  late final $WomenStaffMembersTable womenStaffMembers =
      $WomenStaffMembersTable(this);
  late final $StaffAdvancesTable staffAdvances = $StaffAdvancesTable(this);
  late final $StaffDeductionsTable staffDeductions = $StaffDeductionsTable(
    this,
  );
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ThreadPurchasesTable threadPurchases = $ThreadPurchasesTable(
    this,
  );
  late final $SupplierPaymentsTable supplierPayments = $SupplierPaymentsTable(
    this,
  );
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ClientModelsTable clientModels = $ClientModelsTable(this);
  late final $ClientPaymentsTable clientPayments = $ClientPaymentsTable(this);
  late final $MaintenanceFaultRecordsTable maintenanceFaultRecords =
      $MaintenanceFaultRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    syncQueue,
    workers,
    workerProductionEntries,
    workerAdvances,
    stitchRates,
    workerAbsentDays,
    womenStaffMembers,
    staffAdvances,
    staffDeductions,
    suppliers,
    threadPurchases,
    supplierPayments,
    clients,
    clientModels,
    clientPayments,
    maintenanceFaultRecords,
  ];
}

typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required SyncQueueOperation operation,
      required String targetTableName,
      required int recordId,
      required String payload,
      Value<DateTime> createdAt,
      Value<SyncQueueStatus> status,
      Value<int> retryCount,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<SyncQueueOperation> operation,
      Value<String> targetTableName,
      Value<int> recordId,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<SyncQueueStatus> status,
      Value<int> retryCount,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncQueueOperation, SyncQueueOperation, String>
  get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncQueueStatus, SyncQueueStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncQueueOperation, String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get targetTableName => $composableBuilder(
    column: $table.targetTableName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncQueueStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SyncQueueOperation> operation = const Value.absent(),
                Value<String> targetTableName = const Value.absent(),
                Value<int> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<SyncQueueStatus> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                operation: operation,
                targetTableName: targetTableName,
                recordId: recordId,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required SyncQueueOperation operation,
                required String targetTableName,
                required int recordId,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<SyncQueueStatus> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                operation: operation,
                targetTableName: targetTableName,
                recordId: recordId,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$WorkersTableCreateCompanionBuilder =
    WorkersCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });
typedef $$WorkersTableUpdateCompanionBuilder =
    WorkersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });

final class $$WorkersTableReferences
    extends BaseReferences<_$AppDatabase, $WorkersTable, Worker> {
  $$WorkersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $WorkerProductionEntriesTable,
    List<WorkerProductionEntry>
  >
  _workerProductionEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workerProductionEntries,
        aliasName: $_aliasNameGenerator(
          db.workers.id,
          db.workerProductionEntries.workerId,
        ),
      );

  $$WorkerProductionEntriesTableProcessedTableManager
  get workerProductionEntriesRefs {
    final manager = $$WorkerProductionEntriesTableTableManager(
      $_db,
      $_db.workerProductionEntries,
    ).filter((f) => f.workerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workerProductionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkerAdvancesTable, List<WorkerAdvance>>
  _workerAdvancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workerAdvances,
    aliasName: $_aliasNameGenerator(db.workers.id, db.workerAdvances.workerId),
  );

  $$WorkerAdvancesTableProcessedTableManager get workerAdvancesRefs {
    final manager = $$WorkerAdvancesTableTableManager(
      $_db,
      $_db.workerAdvances,
    ).filter((f) => f.workerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workerAdvancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkerAbsentDaysTable, List<WorkerAbsentDay>>
  _workerAbsentDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workerAbsentDays,
    aliasName: $_aliasNameGenerator(
      db.workers.id,
      db.workerAbsentDays.workerId,
    ),
  );

  $$WorkerAbsentDaysTableProcessedTableManager get workerAbsentDaysRefs {
    final manager = $$WorkerAbsentDaysTableTableManager(
      $_db,
      $_db.workerAbsentDays,
    ).filter((f) => f.workerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workerAbsentDaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkersTableFilterComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workerProductionEntriesRefs(
    Expression<bool> Function($$WorkerProductionEntriesTableFilterComposer f) f,
  ) {
    final $$WorkerProductionEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workerProductionEntries,
          getReferencedColumn: (t) => t.workerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkerProductionEntriesTableFilterComposer(
                $db: $db,
                $table: $db.workerProductionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> workerAdvancesRefs(
    Expression<bool> Function($$WorkerAdvancesTableFilterComposer f) f,
  ) {
    final $$WorkerAdvancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerAdvances,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerAdvancesTableFilterComposer(
            $db: $db,
            $table: $db.workerAdvances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workerAbsentDaysRefs(
    Expression<bool> Function($$WorkerAbsentDaysTableFilterComposer f) f,
  ) {
    final $$WorkerAbsentDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerAbsentDays,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerAbsentDaysTableFilterComposer(
            $db: $db,
            $table: $db.workerAbsentDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkersTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> workerProductionEntriesRefs<T extends Object>(
    Expression<T> Function($$WorkerProductionEntriesTableAnnotationComposer a)
    f,
  ) {
    final $$WorkerProductionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workerProductionEntries,
          getReferencedColumn: (t) => t.workerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkerProductionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.workerProductionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workerAdvancesRefs<T extends Object>(
    Expression<T> Function($$WorkerAdvancesTableAnnotationComposer a) f,
  ) {
    final $$WorkerAdvancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerAdvances,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerAdvancesTableAnnotationComposer(
            $db: $db,
            $table: $db.workerAdvances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workerAbsentDaysRefs<T extends Object>(
    Expression<T> Function($$WorkerAbsentDaysTableAnnotationComposer a) f,
  ) {
    final $$WorkerAbsentDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerAbsentDays,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerAbsentDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.workerAbsentDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkersTable,
          Worker,
          $$WorkersTableFilterComposer,
          $$WorkersTableOrderingComposer,
          $$WorkersTableAnnotationComposer,
          $$WorkersTableCreateCompanionBuilder,
          $$WorkersTableUpdateCompanionBuilder,
          (Worker, $$WorkersTableReferences),
          Worker,
          PrefetchHooks Function({
            bool workerProductionEntriesRefs,
            bool workerAdvancesRefs,
            bool workerAbsentDaysRefs,
          })
        > {
  $$WorkersTableTableManager(_$AppDatabase db, $WorkersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WorkersCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WorkersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workerProductionEntriesRefs = false,
                workerAdvancesRefs = false,
                workerAbsentDaysRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workerProductionEntriesRefs) db.workerProductionEntries,
                    if (workerAdvancesRefs) db.workerAdvances,
                    if (workerAbsentDaysRefs) db.workerAbsentDays,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workerProductionEntriesRefs)
                        await $_getPrefetchedData<
                          Worker,
                          $WorkersTable,
                          WorkerProductionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$WorkersTableReferences
                              ._workerProductionEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkersTableReferences(
                                db,
                                table,
                                p0,
                              ).workerProductionEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workerAdvancesRefs)
                        await $_getPrefetchedData<
                          Worker,
                          $WorkersTable,
                          WorkerAdvance
                        >(
                          currentTable: table,
                          referencedTable: $$WorkersTableReferences
                              ._workerAdvancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkersTableReferences(
                                db,
                                table,
                                p0,
                              ).workerAdvancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workerAbsentDaysRefs)
                        await $_getPrefetchedData<
                          Worker,
                          $WorkersTable,
                          WorkerAbsentDay
                        >(
                          currentTable: table,
                          referencedTable: $$WorkersTableReferences
                              ._workerAbsentDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkersTableReferences(
                                db,
                                table,
                                p0,
                              ).workerAbsentDaysRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkersTable,
      Worker,
      $$WorkersTableFilterComposer,
      $$WorkersTableOrderingComposer,
      $$WorkersTableAnnotationComposer,
      $$WorkersTableCreateCompanionBuilder,
      $$WorkersTableUpdateCompanionBuilder,
      (Worker, $$WorkersTableReferences),
      Worker,
      PrefetchHooks Function({
        bool workerProductionEntriesRefs,
        bool workerAdvancesRefs,
        bool workerAbsentDaysRefs,
      })
    >;
typedef $$WorkerProductionEntriesTableCreateCompanionBuilder =
    WorkerProductionEntriesCompanion Function({
      Value<int> id,
      required int workerId,
      required DateTime date,
      required int stitchCount,
      Value<String?> notes,
    });
typedef $$WorkerProductionEntriesTableUpdateCompanionBuilder =
    WorkerProductionEntriesCompanion Function({
      Value<int> id,
      Value<int> workerId,
      Value<DateTime> date,
      Value<int> stitchCount,
      Value<String?> notes,
    });

final class $$WorkerProductionEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkerProductionEntriesTable,
          WorkerProductionEntry
        > {
  $$WorkerProductionEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkersTable _workerIdTable(_$AppDatabase db) =>
      db.workers.createAlias(
        $_aliasNameGenerator(
          db.workerProductionEntries.workerId,
          db.workers.id,
        ),
      );

  $$WorkersTableProcessedTableManager get workerId {
    final $_column = $_itemColumn<int>('worker_id')!;

    final manager = $$WorkersTableTableManager(
      $_db,
      $_db.workers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkerProductionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkerProductionEntriesTable> {
  $$WorkerProductionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stitchCount => $composableBuilder(
    column: $table.stitchCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkersTableFilterComposer get workerId {
    final $$WorkersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableFilterComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerProductionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkerProductionEntriesTable> {
  $$WorkerProductionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stitchCount => $composableBuilder(
    column: $table.stitchCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkersTableOrderingComposer get workerId {
    final $$WorkersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableOrderingComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerProductionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkerProductionEntriesTable> {
  $$WorkerProductionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get stitchCount => $composableBuilder(
    column: $table.stitchCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkersTableAnnotationComposer get workerId {
    final $$WorkersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableAnnotationComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerProductionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkerProductionEntriesTable,
          WorkerProductionEntry,
          $$WorkerProductionEntriesTableFilterComposer,
          $$WorkerProductionEntriesTableOrderingComposer,
          $$WorkerProductionEntriesTableAnnotationComposer,
          $$WorkerProductionEntriesTableCreateCompanionBuilder,
          $$WorkerProductionEntriesTableUpdateCompanionBuilder,
          (WorkerProductionEntry, $$WorkerProductionEntriesTableReferences),
          WorkerProductionEntry,
          PrefetchHooks Function({bool workerId})
        > {
  $$WorkerProductionEntriesTableTableManager(
    _$AppDatabase db,
    $WorkerProductionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkerProductionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkerProductionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkerProductionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> stitchCount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkerProductionEntriesCompanion(
                id: id,
                workerId: workerId,
                date: date,
                stitchCount: stitchCount,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workerId,
                required DateTime date,
                required int stitchCount,
                Value<String?> notes = const Value.absent(),
              }) => WorkerProductionEntriesCompanion.insert(
                id: id,
                workerId: workerId,
                date: date,
                stitchCount: stitchCount,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkerProductionEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workerId,
                                referencedTable:
                                    $$WorkerProductionEntriesTableReferences
                                        ._workerIdTable(db),
                                referencedColumn:
                                    $$WorkerProductionEntriesTableReferences
                                        ._workerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkerProductionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkerProductionEntriesTable,
      WorkerProductionEntry,
      $$WorkerProductionEntriesTableFilterComposer,
      $$WorkerProductionEntriesTableOrderingComposer,
      $$WorkerProductionEntriesTableAnnotationComposer,
      $$WorkerProductionEntriesTableCreateCompanionBuilder,
      $$WorkerProductionEntriesTableUpdateCompanionBuilder,
      (WorkerProductionEntry, $$WorkerProductionEntriesTableReferences),
      WorkerProductionEntry,
      PrefetchHooks Function({bool workerId})
    >;
typedef $$WorkerAdvancesTableCreateCompanionBuilder =
    WorkerAdvancesCompanion Function({
      Value<int> id,
      required int workerId,
      required double amount,
      required DateTime date,
      Value<String?> notes,
      Value<bool> carriedOver,
    });
typedef $$WorkerAdvancesTableUpdateCompanionBuilder =
    WorkerAdvancesCompanion Function({
      Value<int> id,
      Value<int> workerId,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> notes,
      Value<bool> carriedOver,
    });

final class $$WorkerAdvancesTableReferences
    extends BaseReferences<_$AppDatabase, $WorkerAdvancesTable, WorkerAdvance> {
  $$WorkerAdvancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkersTable _workerIdTable(_$AppDatabase db) =>
      db.workers.createAlias(
        $_aliasNameGenerator(db.workerAdvances.workerId, db.workers.id),
      );

  $$WorkersTableProcessedTableManager get workerId {
    final $_column = $_itemColumn<int>('worker_id')!;

    final manager = $$WorkersTableTableManager(
      $_db,
      $_db.workers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkerAdvancesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkerAdvancesTable> {
  $$WorkerAdvancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkersTableFilterComposer get workerId {
    final $$WorkersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableFilterComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAdvancesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkerAdvancesTable> {
  $$WorkerAdvancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkersTableOrderingComposer get workerId {
    final $$WorkersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableOrderingComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAdvancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkerAdvancesTable> {
  $$WorkerAdvancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => column,
  );

  $$WorkersTableAnnotationComposer get workerId {
    final $$WorkersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableAnnotationComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAdvancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkerAdvancesTable,
          WorkerAdvance,
          $$WorkerAdvancesTableFilterComposer,
          $$WorkerAdvancesTableOrderingComposer,
          $$WorkerAdvancesTableAnnotationComposer,
          $$WorkerAdvancesTableCreateCompanionBuilder,
          $$WorkerAdvancesTableUpdateCompanionBuilder,
          (WorkerAdvance, $$WorkerAdvancesTableReferences),
          WorkerAdvance,
          PrefetchHooks Function({bool workerId})
        > {
  $$WorkerAdvancesTableTableManager(
    _$AppDatabase db,
    $WorkerAdvancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkerAdvancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkerAdvancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkerAdvancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> carriedOver = const Value.absent(),
              }) => WorkerAdvancesCompanion(
                id: id,
                workerId: workerId,
                amount: amount,
                date: date,
                notes: notes,
                carriedOver: carriedOver,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workerId,
                required double amount,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<bool> carriedOver = const Value.absent(),
              }) => WorkerAdvancesCompanion.insert(
                id: id,
                workerId: workerId,
                amount: amount,
                date: date,
                notes: notes,
                carriedOver: carriedOver,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkerAdvancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workerId,
                                referencedTable: $$WorkerAdvancesTableReferences
                                    ._workerIdTable(db),
                                referencedColumn:
                                    $$WorkerAdvancesTableReferences
                                        ._workerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkerAdvancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkerAdvancesTable,
      WorkerAdvance,
      $$WorkerAdvancesTableFilterComposer,
      $$WorkerAdvancesTableOrderingComposer,
      $$WorkerAdvancesTableAnnotationComposer,
      $$WorkerAdvancesTableCreateCompanionBuilder,
      $$WorkerAdvancesTableUpdateCompanionBuilder,
      (WorkerAdvance, $$WorkerAdvancesTableReferences),
      WorkerAdvance,
      PrefetchHooks Function({bool workerId})
    >;
typedef $$StitchRatesTableCreateCompanionBuilder =
    StitchRatesCompanion Function({
      Value<int> id,
      required double rate,
      required DateTime effectiveFrom,
    });
typedef $$StitchRatesTableUpdateCompanionBuilder =
    StitchRatesCompanion Function({
      Value<int> id,
      Value<double> rate,
      Value<DateTime> effectiveFrom,
    });

class $$StitchRatesTableFilterComposer
    extends Composer<_$AppDatabase, $StitchRatesTable> {
  $$StitchRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StitchRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $StitchRatesTable> {
  $$StitchRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StitchRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StitchRatesTable> {
  $$StitchRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );
}

class $$StitchRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StitchRatesTable,
          StitchRate,
          $$StitchRatesTableFilterComposer,
          $$StitchRatesTableOrderingComposer,
          $$StitchRatesTableAnnotationComposer,
          $$StitchRatesTableCreateCompanionBuilder,
          $$StitchRatesTableUpdateCompanionBuilder,
          (
            StitchRate,
            BaseReferences<_$AppDatabase, $StitchRatesTable, StitchRate>,
          ),
          StitchRate,
          PrefetchHooks Function()
        > {
  $$StitchRatesTableTableManager(_$AppDatabase db, $StitchRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StitchRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StitchRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StitchRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> effectiveFrom = const Value.absent(),
              }) => StitchRatesCompanion(
                id: id,
                rate: rate,
                effectiveFrom: effectiveFrom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double rate,
                required DateTime effectiveFrom,
              }) => StitchRatesCompanion.insert(
                id: id,
                rate: rate,
                effectiveFrom: effectiveFrom,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StitchRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StitchRatesTable,
      StitchRate,
      $$StitchRatesTableFilterComposer,
      $$StitchRatesTableOrderingComposer,
      $$StitchRatesTableAnnotationComposer,
      $$StitchRatesTableCreateCompanionBuilder,
      $$StitchRatesTableUpdateCompanionBuilder,
      (
        StitchRate,
        BaseReferences<_$AppDatabase, $StitchRatesTable, StitchRate>,
      ),
      StitchRate,
      PrefetchHooks Function()
    >;
typedef $$WorkerAbsentDaysTableCreateCompanionBuilder =
    WorkerAbsentDaysCompanion Function({
      Value<int> id,
      required int workerId,
      required DateTime monthStart,
      Value<int> absentDays,
    });
typedef $$WorkerAbsentDaysTableUpdateCompanionBuilder =
    WorkerAbsentDaysCompanion Function({
      Value<int> id,
      Value<int> workerId,
      Value<DateTime> monthStart,
      Value<int> absentDays,
    });

final class $$WorkerAbsentDaysTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkerAbsentDaysTable, WorkerAbsentDay> {
  $$WorkerAbsentDaysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkersTable _workerIdTable(_$AppDatabase db) =>
      db.workers.createAlias(
        $_aliasNameGenerator(db.workerAbsentDays.workerId, db.workers.id),
      );

  $$WorkersTableProcessedTableManager get workerId {
    final $_column = $_itemColumn<int>('worker_id')!;

    final manager = $$WorkersTableTableManager(
      $_db,
      $_db.workers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkerAbsentDaysTableFilterComposer
    extends Composer<_$AppDatabase, $WorkerAbsentDaysTable> {
  $$WorkerAbsentDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get monthStart => $composableBuilder(
    column: $table.monthStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get absentDays => $composableBuilder(
    column: $table.absentDays,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkersTableFilterComposer get workerId {
    final $$WorkersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableFilterComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAbsentDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkerAbsentDaysTable> {
  $$WorkerAbsentDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get monthStart => $composableBuilder(
    column: $table.monthStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get absentDays => $composableBuilder(
    column: $table.absentDays,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkersTableOrderingComposer get workerId {
    final $$WorkersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableOrderingComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAbsentDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkerAbsentDaysTable> {
  $$WorkerAbsentDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get monthStart => $composableBuilder(
    column: $table.monthStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get absentDays => $composableBuilder(
    column: $table.absentDays,
    builder: (column) => column,
  );

  $$WorkersTableAnnotationComposer get workerId {
    final $$WorkersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableAnnotationComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkerAbsentDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkerAbsentDaysTable,
          WorkerAbsentDay,
          $$WorkerAbsentDaysTableFilterComposer,
          $$WorkerAbsentDaysTableOrderingComposer,
          $$WorkerAbsentDaysTableAnnotationComposer,
          $$WorkerAbsentDaysTableCreateCompanionBuilder,
          $$WorkerAbsentDaysTableUpdateCompanionBuilder,
          (WorkerAbsentDay, $$WorkerAbsentDaysTableReferences),
          WorkerAbsentDay,
          PrefetchHooks Function({bool workerId})
        > {
  $$WorkerAbsentDaysTableTableManager(
    _$AppDatabase db,
    $WorkerAbsentDaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkerAbsentDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkerAbsentDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkerAbsentDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<DateTime> monthStart = const Value.absent(),
                Value<int> absentDays = const Value.absent(),
              }) => WorkerAbsentDaysCompanion(
                id: id,
                workerId: workerId,
                monthStart: monthStart,
                absentDays: absentDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workerId,
                required DateTime monthStart,
                Value<int> absentDays = const Value.absent(),
              }) => WorkerAbsentDaysCompanion.insert(
                id: id,
                workerId: workerId,
                monthStart: monthStart,
                absentDays: absentDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkerAbsentDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workerId,
                                referencedTable:
                                    $$WorkerAbsentDaysTableReferences
                                        ._workerIdTable(db),
                                referencedColumn:
                                    $$WorkerAbsentDaysTableReferences
                                        ._workerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkerAbsentDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkerAbsentDaysTable,
      WorkerAbsentDay,
      $$WorkerAbsentDaysTableFilterComposer,
      $$WorkerAbsentDaysTableOrderingComposer,
      $$WorkerAbsentDaysTableAnnotationComposer,
      $$WorkerAbsentDaysTableCreateCompanionBuilder,
      $$WorkerAbsentDaysTableUpdateCompanionBuilder,
      (WorkerAbsentDay, $$WorkerAbsentDaysTableReferences),
      WorkerAbsentDay,
      PrefetchHooks Function({bool workerId})
    >;
typedef $$WomenStaffMembersTableCreateCompanionBuilder =
    WomenStaffMembersCompanion Function({
      Value<int> id,
      required String name,
      required double monthlySalary,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });
typedef $$WomenStaffMembersTableUpdateCompanionBuilder =
    WomenStaffMembersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> monthlySalary,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });

final class $$WomenStaffMembersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WomenStaffMembersTable,
          WomenStaffMember
        > {
  $$WomenStaffMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StaffAdvancesTable, List<StaffAdvance>>
  _staffAdvancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.staffAdvances,
    aliasName: $_aliasNameGenerator(
      db.womenStaffMembers.id,
      db.staffAdvances.staffId,
    ),
  );

  $$StaffAdvancesTableProcessedTableManager get staffAdvancesRefs {
    final manager = $$StaffAdvancesTableTableManager(
      $_db,
      $_db.staffAdvances,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staffAdvancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StaffDeductionsTable, List<StaffDeduction>>
  _staffDeductionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.staffDeductions,
    aliasName: $_aliasNameGenerator(
      db.womenStaffMembers.id,
      db.staffDeductions.staffId,
    ),
  );

  $$StaffDeductionsTableProcessedTableManager get staffDeductionsRefs {
    final manager = $$StaffDeductionsTableTableManager(
      $_db,
      $_db.staffDeductions,
    ).filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _staffDeductionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WomenStaffMembersTableFilterComposer
    extends Composer<_$AppDatabase, $WomenStaffMembersTable> {
  $$WomenStaffMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> staffAdvancesRefs(
    Expression<bool> Function($$StaffAdvancesTableFilterComposer f) f,
  ) {
    final $$StaffAdvancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.staffAdvances,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffAdvancesTableFilterComposer(
            $db: $db,
            $table: $db.staffAdvances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> staffDeductionsRefs(
    Expression<bool> Function($$StaffDeductionsTableFilterComposer f) f,
  ) {
    final $$StaffDeductionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.staffDeductions,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffDeductionsTableFilterComposer(
            $db: $db,
            $table: $db.staffDeductions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WomenStaffMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $WomenStaffMembersTable> {
  $$WomenStaffMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WomenStaffMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WomenStaffMembersTable> {
  $$WomenStaffMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get monthlySalary => $composableBuilder(
    column: $table.monthlySalary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> staffAdvancesRefs<T extends Object>(
    Expression<T> Function($$StaffAdvancesTableAnnotationComposer a) f,
  ) {
    final $$StaffAdvancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.staffAdvances,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffAdvancesTableAnnotationComposer(
            $db: $db,
            $table: $db.staffAdvances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> staffDeductionsRefs<T extends Object>(
    Expression<T> Function($$StaffDeductionsTableAnnotationComposer a) f,
  ) {
    final $$StaffDeductionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.staffDeductions,
      getReferencedColumn: (t) => t.staffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StaffDeductionsTableAnnotationComposer(
            $db: $db,
            $table: $db.staffDeductions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WomenStaffMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WomenStaffMembersTable,
          WomenStaffMember,
          $$WomenStaffMembersTableFilterComposer,
          $$WomenStaffMembersTableOrderingComposer,
          $$WomenStaffMembersTableAnnotationComposer,
          $$WomenStaffMembersTableCreateCompanionBuilder,
          $$WomenStaffMembersTableUpdateCompanionBuilder,
          (WomenStaffMember, $$WomenStaffMembersTableReferences),
          WomenStaffMember,
          PrefetchHooks Function({
            bool staffAdvancesRefs,
            bool staffDeductionsRefs,
          })
        > {
  $$WomenStaffMembersTableTableManager(
    _$AppDatabase db,
    $WomenStaffMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WomenStaffMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WomenStaffMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WomenStaffMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> monthlySalary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WomenStaffMembersCompanion(
                id: id,
                name: name,
                monthlySalary: monthlySalary,
                createdAt: createdAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double monthlySalary,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WomenStaffMembersCompanion.insert(
                id: id,
                name: name,
                monthlySalary: monthlySalary,
                createdAt: createdAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WomenStaffMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({staffAdvancesRefs = false, staffDeductionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (staffAdvancesRefs) db.staffAdvances,
                    if (staffDeductionsRefs) db.staffDeductions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (staffAdvancesRefs)
                        await $_getPrefetchedData<
                          WomenStaffMember,
                          $WomenStaffMembersTable,
                          StaffAdvance
                        >(
                          currentTable: table,
                          referencedTable: $$WomenStaffMembersTableReferences
                              ._staffAdvancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WomenStaffMembersTableReferences(
                                db,
                                table,
                                p0,
                              ).staffAdvancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (staffDeductionsRefs)
                        await $_getPrefetchedData<
                          WomenStaffMember,
                          $WomenStaffMembersTable,
                          StaffDeduction
                        >(
                          currentTable: table,
                          referencedTable: $$WomenStaffMembersTableReferences
                              ._staffDeductionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WomenStaffMembersTableReferences(
                                db,
                                table,
                                p0,
                              ).staffDeductionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.staffId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WomenStaffMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WomenStaffMembersTable,
      WomenStaffMember,
      $$WomenStaffMembersTableFilterComposer,
      $$WomenStaffMembersTableOrderingComposer,
      $$WomenStaffMembersTableAnnotationComposer,
      $$WomenStaffMembersTableCreateCompanionBuilder,
      $$WomenStaffMembersTableUpdateCompanionBuilder,
      (WomenStaffMember, $$WomenStaffMembersTableReferences),
      WomenStaffMember,
      PrefetchHooks Function({bool staffAdvancesRefs, bool staffDeductionsRefs})
    >;
typedef $$StaffAdvancesTableCreateCompanionBuilder =
    StaffAdvancesCompanion Function({
      Value<int> id,
      required int staffId,
      required double amount,
      required DateTime date,
      Value<String?> notes,
      Value<bool> carriedOver,
    });
typedef $$StaffAdvancesTableUpdateCompanionBuilder =
    StaffAdvancesCompanion Function({
      Value<int> id,
      Value<int> staffId,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> notes,
      Value<bool> carriedOver,
    });

final class $$StaffAdvancesTableReferences
    extends BaseReferences<_$AppDatabase, $StaffAdvancesTable, StaffAdvance> {
  $$StaffAdvancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WomenStaffMembersTable _staffIdTable(_$AppDatabase db) =>
      db.womenStaffMembers.createAlias(
        $_aliasNameGenerator(db.staffAdvances.staffId, db.womenStaffMembers.id),
      );

  $$WomenStaffMembersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$WomenStaffMembersTableTableManager(
      $_db,
      $_db.womenStaffMembers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StaffAdvancesTableFilterComposer
    extends Composer<_$AppDatabase, $StaffAdvancesTable> {
  $$StaffAdvancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => ColumnFilters(column),
  );

  $$WomenStaffMembersTableFilterComposer get staffId {
    final $$WomenStaffMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.womenStaffMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WomenStaffMembersTableFilterComposer(
            $db: $db,
            $table: $db.womenStaffMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StaffAdvancesTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffAdvancesTable> {
  $$StaffAdvancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => ColumnOrderings(column),
  );

  $$WomenStaffMembersTableOrderingComposer get staffId {
    final $$WomenStaffMembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.womenStaffMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WomenStaffMembersTableOrderingComposer(
            $db: $db,
            $table: $db.womenStaffMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StaffAdvancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffAdvancesTable> {
  $$StaffAdvancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get carriedOver => $composableBuilder(
    column: $table.carriedOver,
    builder: (column) => column,
  );

  $$WomenStaffMembersTableAnnotationComposer get staffId {
    final $$WomenStaffMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.staffId,
          referencedTable: $db.womenStaffMembers,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WomenStaffMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.womenStaffMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StaffAdvancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StaffAdvancesTable,
          StaffAdvance,
          $$StaffAdvancesTableFilterComposer,
          $$StaffAdvancesTableOrderingComposer,
          $$StaffAdvancesTableAnnotationComposer,
          $$StaffAdvancesTableCreateCompanionBuilder,
          $$StaffAdvancesTableUpdateCompanionBuilder,
          (StaffAdvance, $$StaffAdvancesTableReferences),
          StaffAdvance,
          PrefetchHooks Function({bool staffId})
        > {
  $$StaffAdvancesTableTableManager(_$AppDatabase db, $StaffAdvancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffAdvancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffAdvancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffAdvancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> staffId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> carriedOver = const Value.absent(),
              }) => StaffAdvancesCompanion(
                id: id,
                staffId: staffId,
                amount: amount,
                date: date,
                notes: notes,
                carriedOver: carriedOver,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int staffId,
                required double amount,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<bool> carriedOver = const Value.absent(),
              }) => StaffAdvancesCompanion.insert(
                id: id,
                staffId: staffId,
                amount: amount,
                date: date,
                notes: notes,
                carriedOver: carriedOver,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StaffAdvancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (staffId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.staffId,
                                referencedTable: $$StaffAdvancesTableReferences
                                    ._staffIdTable(db),
                                referencedColumn: $$StaffAdvancesTableReferences
                                    ._staffIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StaffAdvancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StaffAdvancesTable,
      StaffAdvance,
      $$StaffAdvancesTableFilterComposer,
      $$StaffAdvancesTableOrderingComposer,
      $$StaffAdvancesTableAnnotationComposer,
      $$StaffAdvancesTableCreateCompanionBuilder,
      $$StaffAdvancesTableUpdateCompanionBuilder,
      (StaffAdvance, $$StaffAdvancesTableReferences),
      StaffAdvance,
      PrefetchHooks Function({bool staffId})
    >;
typedef $$StaffDeductionsTableCreateCompanionBuilder =
    StaffDeductionsCompanion Function({
      Value<int> id,
      required int staffId,
      required double amount,
      required DateTime date,
      Value<String?> notes,
    });
typedef $$StaffDeductionsTableUpdateCompanionBuilder =
    StaffDeductionsCompanion Function({
      Value<int> id,
      Value<int> staffId,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> notes,
    });

final class $$StaffDeductionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StaffDeductionsTable, StaffDeduction> {
  $$StaffDeductionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WomenStaffMembersTable _staffIdTable(_$AppDatabase db) =>
      db.womenStaffMembers.createAlias(
        $_aliasNameGenerator(
          db.staffDeductions.staffId,
          db.womenStaffMembers.id,
        ),
      );

  $$WomenStaffMembersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$WomenStaffMembersTableTableManager(
      $_db,
      $_db.womenStaffMembers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StaffDeductionsTableFilterComposer
    extends Composer<_$AppDatabase, $StaffDeductionsTable> {
  $$StaffDeductionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WomenStaffMembersTableFilterComposer get staffId {
    final $$WomenStaffMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.womenStaffMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WomenStaffMembersTableFilterComposer(
            $db: $db,
            $table: $db.womenStaffMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StaffDeductionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffDeductionsTable> {
  $$StaffDeductionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WomenStaffMembersTableOrderingComposer get staffId {
    final $$WomenStaffMembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.staffId,
      referencedTable: $db.womenStaffMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WomenStaffMembersTableOrderingComposer(
            $db: $db,
            $table: $db.womenStaffMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StaffDeductionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffDeductionsTable> {
  $$StaffDeductionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WomenStaffMembersTableAnnotationComposer get staffId {
    final $$WomenStaffMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.staffId,
          referencedTable: $db.womenStaffMembers,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WomenStaffMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.womenStaffMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StaffDeductionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StaffDeductionsTable,
          StaffDeduction,
          $$StaffDeductionsTableFilterComposer,
          $$StaffDeductionsTableOrderingComposer,
          $$StaffDeductionsTableAnnotationComposer,
          $$StaffDeductionsTableCreateCompanionBuilder,
          $$StaffDeductionsTableUpdateCompanionBuilder,
          (StaffDeduction, $$StaffDeductionsTableReferences),
          StaffDeduction,
          PrefetchHooks Function({bool staffId})
        > {
  $$StaffDeductionsTableTableManager(
    _$AppDatabase db,
    $StaffDeductionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffDeductionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffDeductionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffDeductionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> staffId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => StaffDeductionsCompanion(
                id: id,
                staffId: staffId,
                amount: amount,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int staffId,
                required double amount,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
              }) => StaffDeductionsCompanion.insert(
                id: id,
                staffId: staffId,
                amount: amount,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StaffDeductionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (staffId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.staffId,
                                referencedTable:
                                    $$StaffDeductionsTableReferences
                                        ._staffIdTable(db),
                                referencedColumn:
                                    $$StaffDeductionsTableReferences
                                        ._staffIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StaffDeductionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StaffDeductionsTable,
      StaffDeduction,
      $$StaffDeductionsTableFilterComposer,
      $$StaffDeductionsTableOrderingComposer,
      $$StaffDeductionsTableAnnotationComposer,
      $$StaffDeductionsTableCreateCompanionBuilder,
      $$StaffDeductionsTableUpdateCompanionBuilder,
      (StaffDeduction, $$StaffDeductionsTableReferences),
      StaffDeduction,
      PrefetchHooks Function({bool staffId})
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<DateTime> createdAt,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<DateTime> createdAt,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ThreadPurchasesTable, List<ThreadPurchase>>
  _threadPurchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.threadPurchases,
    aliasName: $_aliasNameGenerator(
      db.suppliers.id,
      db.threadPurchases.supplierId,
    ),
  );

  $$ThreadPurchasesTableProcessedTableManager get threadPurchasesRefs {
    final manager = $$ThreadPurchasesTableTableManager(
      $_db,
      $_db.threadPurchases,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _threadPurchasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SupplierPaymentsTable, List<SupplierPayment>>
  _supplierPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.supplierPayments,
    aliasName: $_aliasNameGenerator(
      db.suppliers.id,
      db.supplierPayments.supplierId,
    ),
  );

  $$SupplierPaymentsTableProcessedTableManager get supplierPaymentsRefs {
    final manager = $$SupplierPaymentsTableTableManager(
      $_db,
      $_db.supplierPayments,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _supplierPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> threadPurchasesRefs(
    Expression<bool> Function($$ThreadPurchasesTableFilterComposer f) f,
  ) {
    final $$ThreadPurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.threadPurchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThreadPurchasesTableFilterComposer(
            $db: $db,
            $table: $db.threadPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> supplierPaymentsRefs(
    Expression<bool> Function($$SupplierPaymentsTableFilterComposer f) f,
  ) {
    final $$SupplierPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplierPayments,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplierPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.supplierPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> threadPurchasesRefs<T extends Object>(
    Expression<T> Function($$ThreadPurchasesTableAnnotationComposer a) f,
  ) {
    final $$ThreadPurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.threadPurchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ThreadPurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.threadPurchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> supplierPaymentsRefs<T extends Object>(
    Expression<T> Function($$SupplierPaymentsTableAnnotationComposer a) f,
  ) {
    final $$SupplierPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplierPayments,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplierPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.supplierPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, $$SuppliersTableReferences),
          Supplier,
          PrefetchHooks Function({
            bool threadPurchasesRefs,
            bool supplierPaymentsRefs,
          })
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({threadPurchasesRefs = false, supplierPaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (threadPurchasesRefs) db.threadPurchases,
                    if (supplierPaymentsRefs) db.supplierPayments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (threadPurchasesRefs)
                        await $_getPrefetchedData<
                          Supplier,
                          $SuppliersTable,
                          ThreadPurchase
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._threadPurchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).threadPurchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supplierId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (supplierPaymentsRefs)
                        await $_getPrefetchedData<
                          Supplier,
                          $SuppliersTable,
                          SupplierPayment
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._supplierPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).supplierPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supplierId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, $$SuppliersTableReferences),
      Supplier,
      PrefetchHooks Function({
        bool threadPurchasesRefs,
        bool supplierPaymentsRefs,
      })
    >;
typedef $$ThreadPurchasesTableCreateCompanionBuilder =
    ThreadPurchasesCompanion Function({
      Value<int> id,
      required int supplierId,
      required String itemName,
      required String colorNumber,
      required DateTime purchaseDate,
      required double price,
      required double quantity,
      required String unit,
      Value<String?> notes,
    });
typedef $$ThreadPurchasesTableUpdateCompanionBuilder =
    ThreadPurchasesCompanion Function({
      Value<int> id,
      Value<int> supplierId,
      Value<String> itemName,
      Value<String> colorNumber,
      Value<DateTime> purchaseDate,
      Value<double> price,
      Value<double> quantity,
      Value<String> unit,
      Value<String?> notes,
    });

final class $$ThreadPurchasesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ThreadPurchasesTable, ThreadPurchase> {
  $$ThreadPurchasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.threadPurchases.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ThreadPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $ThreadPurchasesTable> {
  $$ThreadPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorNumber => $composableBuilder(
    column: $table.colorNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThreadPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $ThreadPurchasesTable> {
  $$ThreadPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorNumber => $composableBuilder(
    column: $table.colorNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThreadPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThreadPurchasesTable> {
  $$ThreadPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get colorNumber => $composableBuilder(
    column: $table.colorNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ThreadPurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThreadPurchasesTable,
          ThreadPurchase,
          $$ThreadPurchasesTableFilterComposer,
          $$ThreadPurchasesTableOrderingComposer,
          $$ThreadPurchasesTableAnnotationComposer,
          $$ThreadPurchasesTableCreateCompanionBuilder,
          $$ThreadPurchasesTableUpdateCompanionBuilder,
          (ThreadPurchase, $$ThreadPurchasesTableReferences),
          ThreadPurchase,
          PrefetchHooks Function({bool supplierId})
        > {
  $$ThreadPurchasesTableTableManager(
    _$AppDatabase db,
    $ThreadPurchasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThreadPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThreadPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThreadPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> supplierId = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<String> colorNumber = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ThreadPurchasesCompanion(
                id: id,
                supplierId: supplierId,
                itemName: itemName,
                colorNumber: colorNumber,
                purchaseDate: purchaseDate,
                price: price,
                quantity: quantity,
                unit: unit,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int supplierId,
                required String itemName,
                required String colorNumber,
                required DateTime purchaseDate,
                required double price,
                required double quantity,
                required String unit,
                Value<String?> notes = const Value.absent(),
              }) => ThreadPurchasesCompanion.insert(
                id: id,
                supplierId: supplierId,
                itemName: itemName,
                colorNumber: colorNumber,
                purchaseDate: purchaseDate,
                price: price,
                quantity: quantity,
                unit: unit,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ThreadPurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (supplierId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.supplierId,
                                referencedTable:
                                    $$ThreadPurchasesTableReferences
                                        ._supplierIdTable(db),
                                referencedColumn:
                                    $$ThreadPurchasesTableReferences
                                        ._supplierIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ThreadPurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThreadPurchasesTable,
      ThreadPurchase,
      $$ThreadPurchasesTableFilterComposer,
      $$ThreadPurchasesTableOrderingComposer,
      $$ThreadPurchasesTableAnnotationComposer,
      $$ThreadPurchasesTableCreateCompanionBuilder,
      $$ThreadPurchasesTableUpdateCompanionBuilder,
      (ThreadPurchase, $$ThreadPurchasesTableReferences),
      ThreadPurchase,
      PrefetchHooks Function({bool supplierId})
    >;
typedef $$SupplierPaymentsTableCreateCompanionBuilder =
    SupplierPaymentsCompanion Function({
      Value<int> id,
      required int supplierId,
      required double amount,
      required DateTime paymentDate,
      Value<String?> notes,
    });
typedef $$SupplierPaymentsTableUpdateCompanionBuilder =
    SupplierPaymentsCompanion Function({
      Value<int> id,
      Value<int> supplierId,
      Value<double> amount,
      Value<DateTime> paymentDate,
      Value<String?> notes,
    });

final class $$SupplierPaymentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SupplierPaymentsTable, SupplierPayment> {
  $$SupplierPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.supplierPayments.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupplierPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplierPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplierPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierPaymentsTable> {
  $$SupplierPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplierPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplierPaymentsTable,
          SupplierPayment,
          $$SupplierPaymentsTableFilterComposer,
          $$SupplierPaymentsTableOrderingComposer,
          $$SupplierPaymentsTableAnnotationComposer,
          $$SupplierPaymentsTableCreateCompanionBuilder,
          $$SupplierPaymentsTableUpdateCompanionBuilder,
          (SupplierPayment, $$SupplierPaymentsTableReferences),
          SupplierPayment,
          PrefetchHooks Function({bool supplierId})
        > {
  $$SupplierPaymentsTableTableManager(
    _$AppDatabase db,
    $SupplierPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> supplierId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SupplierPaymentsCompanion(
                id: id,
                supplierId: supplierId,
                amount: amount,
                paymentDate: paymentDate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int supplierId,
                required double amount,
                required DateTime paymentDate,
                Value<String?> notes = const Value.absent(),
              }) => SupplierPaymentsCompanion.insert(
                id: id,
                supplierId: supplierId,
                amount: amount,
                paymentDate: paymentDate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SupplierPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (supplierId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.supplierId,
                                referencedTable:
                                    $$SupplierPaymentsTableReferences
                                        ._supplierIdTable(db),
                                referencedColumn:
                                    $$SupplierPaymentsTableReferences
                                        ._supplierIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SupplierPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplierPaymentsTable,
      SupplierPayment,
      $$SupplierPaymentsTableFilterComposer,
      $$SupplierPaymentsTableOrderingComposer,
      $$SupplierPaymentsTableAnnotationComposer,
      $$SupplierPaymentsTableCreateCompanionBuilder,
      $$SupplierPaymentsTableUpdateCompanionBuilder,
      (SupplierPayment, $$SupplierPaymentsTableReferences),
      SupplierPayment,
      PrefetchHooks Function({bool supplierId})
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ClientModelsTable, List<ClientModel>>
  _clientModelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clientModels,
    aliasName: $_aliasNameGenerator(db.clients.id, db.clientModels.clientId),
  );

  $$ClientModelsTableProcessedTableManager get clientModelsRefs {
    final manager = $$ClientModelsTableTableManager(
      $_db,
      $_db.clientModels,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientModelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClientPaymentsTable, List<ClientPayment>>
  _clientPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.clientPayments,
    aliasName: $_aliasNameGenerator(db.clients.id, db.clientPayments.clientId),
  );

  $$ClientPaymentsTableProcessedTableManager get clientPaymentsRefs {
    final manager = $$ClientPaymentsTableTableManager(
      $_db,
      $_db.clientPayments,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clientPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> clientModelsRefs(
    Expression<bool> Function($$ClientModelsTableFilterComposer f) f,
  ) {
    final $$ClientModelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientModels,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientModelsTableFilterComposer(
            $db: $db,
            $table: $db.clientModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> clientPaymentsRefs(
    Expression<bool> Function($$ClientPaymentsTableFilterComposer f) f,
  ) {
    final $$ClientPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientPayments,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.clientPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> clientModelsRefs<T extends Object>(
    Expression<T> Function($$ClientModelsTableAnnotationComposer a) f,
  ) {
    final $$ClientModelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientModels,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientModelsTableAnnotationComposer(
            $db: $db,
            $table: $db.clientModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> clientPaymentsRefs<T extends Object>(
    Expression<T> Function($$ClientPaymentsTableAnnotationComposer a) f,
  ) {
    final $$ClientPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clientPayments,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.clientPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, $$ClientsTableReferences),
          Client,
          PrefetchHooks Function({
            bool clientModelsRefs,
            bool clientPaymentsRefs,
          })
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                createdAt: createdAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({clientModelsRefs = false, clientPaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (clientModelsRefs) db.clientModels,
                    if (clientPaymentsRefs) db.clientPayments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (clientModelsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          ClientModel
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._clientModelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).clientModelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (clientPaymentsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          ClientPayment
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._clientPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).clientPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, $$ClientsTableReferences),
      Client,
      PrefetchHooks Function({bool clientModelsRefs, bool clientPaymentsRefs})
    >;
typedef $$ClientModelsTableCreateCompanionBuilder =
    ClientModelsCompanion Function({
      Value<int> id,
      required int clientId,
      required String modelName,
      required int pieceCount,
      required double pricePerPiece,
      required DateTime date,
      Value<String?> notes,
    });
typedef $$ClientModelsTableUpdateCompanionBuilder =
    ClientModelsCompanion Function({
      Value<int> id,
      Value<int> clientId,
      Value<String> modelName,
      Value<int> pieceCount,
      Value<double> pricePerPiece,
      Value<DateTime> date,
      Value<String?> notes,
    });

final class $$ClientModelsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientModelsTable, ClientModel> {
  $$ClientModelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias(
        $_aliasNameGenerator(db.clientModels.clientId, db.clients.id),
      );

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClientModelsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientModelsTable> {
  $$ClientModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pieceCount => $composableBuilder(
    column: $table.pieceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerPiece => $composableBuilder(
    column: $table.pricePerPiece,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientModelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientModelsTable> {
  $$ClientModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pieceCount => $composableBuilder(
    column: $table.pieceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerPiece => $composableBuilder(
    column: $table.pricePerPiece,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientModelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientModelsTable> {
  $$ClientModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<int> get pieceCount => $composableBuilder(
    column: $table.pieceCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerPiece => $composableBuilder(
    column: $table.pricePerPiece,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientModelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientModelsTable,
          ClientModel,
          $$ClientModelsTableFilterComposer,
          $$ClientModelsTableOrderingComposer,
          $$ClientModelsTableAnnotationComposer,
          $$ClientModelsTableCreateCompanionBuilder,
          $$ClientModelsTableUpdateCompanionBuilder,
          (ClientModel, $$ClientModelsTableReferences),
          ClientModel,
          PrefetchHooks Function({bool clientId})
        > {
  $$ClientModelsTableTableManager(_$AppDatabase db, $ClientModelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<int> pieceCount = const Value.absent(),
                Value<double> pricePerPiece = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ClientModelsCompanion(
                id: id,
                clientId: clientId,
                modelName: modelName,
                pieceCount: pieceCount,
                pricePerPiece: pricePerPiece,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clientId,
                required String modelName,
                required int pieceCount,
                required double pricePerPiece,
                required DateTime date,
                Value<String?> notes = const Value.absent(),
              }) => ClientModelsCompanion.insert(
                id: id,
                clientId: clientId,
                modelName: modelName,
                pieceCount: pieceCount,
                pricePerPiece: pricePerPiece,
                date: date,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientModelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$ClientModelsTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$ClientModelsTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClientModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientModelsTable,
      ClientModel,
      $$ClientModelsTableFilterComposer,
      $$ClientModelsTableOrderingComposer,
      $$ClientModelsTableAnnotationComposer,
      $$ClientModelsTableCreateCompanionBuilder,
      $$ClientModelsTableUpdateCompanionBuilder,
      (ClientModel, $$ClientModelsTableReferences),
      ClientModel,
      PrefetchHooks Function({bool clientId})
    >;
typedef $$ClientPaymentsTableCreateCompanionBuilder =
    ClientPaymentsCompanion Function({
      Value<int> id,
      required int clientId,
      required double amount,
      required DateTime paymentDate,
      Value<String?> notes,
    });
typedef $$ClientPaymentsTableUpdateCompanionBuilder =
    ClientPaymentsCompanion Function({
      Value<int> id,
      Value<int> clientId,
      Value<double> amount,
      Value<DateTime> paymentDate,
      Value<String?> notes,
    });

final class $$ClientPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientPaymentsTable, ClientPayment> {
  $$ClientPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias(
        $_aliasNameGenerator(db.clientPayments.clientId, db.clients.id),
      );

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClientPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientPaymentsTable> {
  $$ClientPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientPaymentsTable> {
  $$ClientPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientPaymentsTable> {
  $$ClientPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClientPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientPaymentsTable,
          ClientPayment,
          $$ClientPaymentsTableFilterComposer,
          $$ClientPaymentsTableOrderingComposer,
          $$ClientPaymentsTableAnnotationComposer,
          $$ClientPaymentsTableCreateCompanionBuilder,
          $$ClientPaymentsTableUpdateCompanionBuilder,
          (ClientPayment, $$ClientPaymentsTableReferences),
          ClientPayment,
          PrefetchHooks Function({bool clientId})
        > {
  $$ClientPaymentsTableTableManager(
    _$AppDatabase db,
    $ClientPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ClientPaymentsCompanion(
                id: id,
                clientId: clientId,
                amount: amount,
                paymentDate: paymentDate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clientId,
                required double amount,
                required DateTime paymentDate,
                Value<String?> notes = const Value.absent(),
              }) => ClientPaymentsCompanion.insert(
                id: id,
                clientId: clientId,
                amount: amount,
                paymentDate: paymentDate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$ClientPaymentsTableReferences
                                    ._clientIdTable(db),
                                referencedColumn:
                                    $$ClientPaymentsTableReferences
                                        ._clientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClientPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientPaymentsTable,
      ClientPayment,
      $$ClientPaymentsTableFilterComposer,
      $$ClientPaymentsTableOrderingComposer,
      $$ClientPaymentsTableAnnotationComposer,
      $$ClientPaymentsTableCreateCompanionBuilder,
      $$ClientPaymentsTableUpdateCompanionBuilder,
      (ClientPayment, $$ClientPaymentsTableReferences),
      ClientPayment,
      PrefetchHooks Function({bool clientId})
    >;
typedef $$MaintenanceFaultRecordsTableCreateCompanionBuilder =
    MaintenanceFaultRecordsCompanion Function({
      Value<int> id,
      required String machineName,
      required String faultName,
      required double cost,
      required double totalCost,
      Value<DateTime> createdAt,
    });
typedef $$MaintenanceFaultRecordsTableUpdateCompanionBuilder =
    MaintenanceFaultRecordsCompanion Function({
      Value<int> id,
      Value<String> machineName,
      Value<String> faultName,
      Value<double> cost,
      Value<double> totalCost,
      Value<DateTime> createdAt,
    });

class $$MaintenanceFaultRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceFaultRecordsTable> {
  $$MaintenanceFaultRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineName => $composableBuilder(
    column: $table.machineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faultName => $composableBuilder(
    column: $table.faultName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaintenanceFaultRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceFaultRecordsTable> {
  $$MaintenanceFaultRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineName => $composableBuilder(
    column: $table.machineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faultName => $composableBuilder(
    column: $table.faultName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaintenanceFaultRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceFaultRecordsTable> {
  $$MaintenanceFaultRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get machineName => $composableBuilder(
    column: $table.machineName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get faultName =>
      $composableBuilder(column: $table.faultName, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MaintenanceFaultRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceFaultRecordsTable,
          MaintenanceFaultRecord,
          $$MaintenanceFaultRecordsTableFilterComposer,
          $$MaintenanceFaultRecordsTableOrderingComposer,
          $$MaintenanceFaultRecordsTableAnnotationComposer,
          $$MaintenanceFaultRecordsTableCreateCompanionBuilder,
          $$MaintenanceFaultRecordsTableUpdateCompanionBuilder,
          (
            MaintenanceFaultRecord,
            BaseReferences<
              _$AppDatabase,
              $MaintenanceFaultRecordsTable,
              MaintenanceFaultRecord
            >,
          ),
          MaintenanceFaultRecord,
          PrefetchHooks Function()
        > {
  $$MaintenanceFaultRecordsTableTableManager(
    _$AppDatabase db,
    $MaintenanceFaultRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceFaultRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MaintenanceFaultRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MaintenanceFaultRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> machineName = const Value.absent(),
                Value<String> faultName = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceFaultRecordsCompanion(
                id: id,
                machineName: machineName,
                faultName: faultName,
                cost: cost,
                totalCost: totalCost,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String machineName,
                required String faultName,
                required double cost,
                required double totalCost,
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceFaultRecordsCompanion.insert(
                id: id,
                machineName: machineName,
                faultName: faultName,
                cost: cost,
                totalCost: totalCost,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaintenanceFaultRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceFaultRecordsTable,
      MaintenanceFaultRecord,
      $$MaintenanceFaultRecordsTableFilterComposer,
      $$MaintenanceFaultRecordsTableOrderingComposer,
      $$MaintenanceFaultRecordsTableAnnotationComposer,
      $$MaintenanceFaultRecordsTableCreateCompanionBuilder,
      $$MaintenanceFaultRecordsTableUpdateCompanionBuilder,
      (
        MaintenanceFaultRecord,
        BaseReferences<
          _$AppDatabase,
          $MaintenanceFaultRecordsTable,
          MaintenanceFaultRecord
        >,
      ),
      MaintenanceFaultRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$WorkersTableTableManager get workers =>
      $$WorkersTableTableManager(_db, _db.workers);
  $$WorkerProductionEntriesTableTableManager get workerProductionEntries =>
      $$WorkerProductionEntriesTableTableManager(
        _db,
        _db.workerProductionEntries,
      );
  $$WorkerAdvancesTableTableManager get workerAdvances =>
      $$WorkerAdvancesTableTableManager(_db, _db.workerAdvances);
  $$StitchRatesTableTableManager get stitchRates =>
      $$StitchRatesTableTableManager(_db, _db.stitchRates);
  $$WorkerAbsentDaysTableTableManager get workerAbsentDays =>
      $$WorkerAbsentDaysTableTableManager(_db, _db.workerAbsentDays);
  $$WomenStaffMembersTableTableManager get womenStaffMembers =>
      $$WomenStaffMembersTableTableManager(_db, _db.womenStaffMembers);
  $$StaffAdvancesTableTableManager get staffAdvances =>
      $$StaffAdvancesTableTableManager(_db, _db.staffAdvances);
  $$StaffDeductionsTableTableManager get staffDeductions =>
      $$StaffDeductionsTableTableManager(_db, _db.staffDeductions);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ThreadPurchasesTableTableManager get threadPurchases =>
      $$ThreadPurchasesTableTableManager(_db, _db.threadPurchases);
  $$SupplierPaymentsTableTableManager get supplierPayments =>
      $$SupplierPaymentsTableTableManager(_db, _db.supplierPayments);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ClientModelsTableTableManager get clientModels =>
      $$ClientModelsTableTableManager(_db, _db.clientModels);
  $$ClientPaymentsTableTableManager get clientPayments =>
      $$ClientPaymentsTableTableManager(_db, _db.clientPayments);
  $$MaintenanceFaultRecordsTableTableManager get maintenanceFaultRecords =>
      $$MaintenanceFaultRecordsTableTableManager(
        _db,
        _db.maintenanceFaultRecords,
      );
}
