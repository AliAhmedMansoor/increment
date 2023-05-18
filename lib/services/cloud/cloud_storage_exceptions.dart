// Using Inheritance to group exceptions

class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C - Create
class CouldNotCreateTaskException extends CloudStorageException {}

// R - Read
class CouldNotGetAllTasksException extends CloudStorageException {}

// U - Update
class CouldNotUpdateTaskException extends CloudStorageException {}

// D - Delete
class CouldNotDeleteTaskException extends CloudStorageException {}
