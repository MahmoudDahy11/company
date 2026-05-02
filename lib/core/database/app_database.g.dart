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
}
