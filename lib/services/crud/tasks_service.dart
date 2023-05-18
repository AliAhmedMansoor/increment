import 'dart:async';
import 'package:flutter/material.dart';
import 'package:incrementapp/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// Tasks Service
class TasksService {
  Database? _db;

  // TASKS STREAM
  List<DatabaseTask> _tasks = [];

  // Singleton
  static final TasksService _shared = TasksService._sharedInstance();
  TasksService._sharedInstance() {
    _tasksStreamController = StreamController<List<DatabaseTask>>.broadcast(
      onListen: () {
        _tasksStreamController.sink.add(_tasks);
      },
    );
  }
  factory TasksService() => _shared;

  // A pipe of data
  late final StreamController<List<DatabaseTask>> _tasksStreamController;

  // Getter for all tasks
  Stream<List<DatabaseTask>> get allTasks => _tasksStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheTasks() async {
    final allTasks = await getAllTasks();
    _tasks = allTasks.toList();
    _tasksStreamController.add(_tasks);
  }

  // UPDATE TASKS
  Future<DatabaseTask> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Making sure task exists
    await getTask(id: task.id);

    // Updating database
    final updatesCount = await db.update(tasksTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateTask();
    } else {
      final updatedTask = await getTask(id: task.id);
      _tasks.removeWhere((task) => task.id == updatedTask.id);
      _tasks.add(updatedTask);
      _tasksStreamController.add(_tasks);
      return updatedTask;
    }
  }

  // FETCHING ALL TASKS
  Future<Iterable<DatabaseTask>> getAllTasks() async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final tasks = await db.query(tasksTable);

    return tasks.map((tasksRow) => DatabaseTask.fromRow(tasksRow));
  }

  // FETCHING TASK
  Future<DatabaseTask> getTask({required int id}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final tasks = await db.query(
      tasksTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (tasks.isEmpty) {
      throw CouldNotFindTask();
    } else {
      final task = DatabaseTask.fromRow(tasks.first);
      _tasks.removeWhere((task) => task.id == id);
      _tasks.add(task);
      _tasksStreamController.add(_tasks);
      return task;
    }
  }

  // DELETE ALL NOTE
  Future<int> deleteAllTasks() async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(tasksTable);
    _tasks = [];
    _tasksStreamController.add(_tasks);
    return numberOfDeletions;
  }

  // DELETING TASKS
  Future<void> deleteTask({required int id}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteTask();
    } else {
      _tasks.removeWhere((task) => task.id == id);
      _tasksStreamController.add(_tasks);
    }
  }

  // CREATING TASKS
  Future<DatabaseTask> createTask({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    // If database user is actually the owner
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    // Create the task
    final taskId = await db.insert(tasksTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final task = DatabaseTask(taskId, owner.id, text, true);

    _tasks.add(task);
    _tasksStreamController.add(_tasks);

    return task;
  }

  // RETRIEVING USER
  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    // Making sure the email does exist already
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  // CREATING USER
  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    // Making sure the email doesnt exist already
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  // DELETING USER
  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  // GETTING CURRENT DATABASE
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // CLOSING DATABASE
  Future<void> close() async {
    // Can't close if not open
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  // ENSURING DATABASE IS OPEN
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  // OPENING DATABASE
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // CREATING USER TABLE
      await db.execute(createUserTable);

      // CREATING TASK TABLE
      await db.execute(createTaskTable);
      // Caching data
      await _cacheTasks();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
// USERS
class DatabaseUser {
  final int id;
  final String email;

  // Constructor
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  // Row inside the user table
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  // If two people are equal
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// TASKS
class DatabaseTask {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  // Contructor
  DatabaseTask(
    this.id,
    this.userId,
    this.text,
    this.isSyncedWithCloud,
  );

  // Row inside the user table
  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Task, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud';

  // If two people are equal
  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Constants
const dbName = 'tasks.db';
const tasksTable = 'task';
const userTable = 'user';

const idColumn = 'id';
const emailColumn = 'email';
const nameColumn = 'name';

const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''
CREATE TABLE "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const createTaskTable = '''
  CREATE TABLE IF NOT EXISTS "task" (
    "id"	INTEGER NOT NULL,
    "user_id"	INTEGER NOT NULL,
    "text"	TEXT,
    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY("user_id") REFERENCES "user"("id"),
    PRIMARY KEY("id" AUTOINCREMENT)
  );''';


// PERSONAL DOCUMENTATION

// ''' allows us to write whatever we want inbetween
// All platforms have their own documents directory so we are joining them by finding paths