library;
class FileUploadInputElement { String? accept; void click(){} List<File>? get files => null; Stream<Event> get onChange => const Stream.empty();}
class File {}
class Event {}
class FileReader { dynamic result; void readAsText(File file){} Stream<Event> get onLoad => const Stream.empty();}