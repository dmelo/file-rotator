Delete files from directory until directory size gets under a threashold. It
deletes least recently accessed files first.

Usage: file-rotator.sh -d DIR -l SIZE\_LIMIT

    DIR -- Directory that will bet trimmed.
    LIMIT -- Size limit of DIR, in bytes.
