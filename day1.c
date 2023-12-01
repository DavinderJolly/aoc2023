#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int part_one() {
  FILE *file;

  if (fopen_s(&file, "day1input.txt", "r") == 0) {
    char line[128];
    int total = 0;

    while (fgets(line, sizeof(line), file) != NULL) {
      size_t len = strlen(line);
      if (len > 0 && line[len - 1] == '\n') {
        line[len - 1] = '\0';
      }

      char digits[3];

      size_t i = 0;
      while (line[i] != '\0') {
        if (isdigit(line[i])) {
          digits[0] = line[i];
          break;
        }
        i += 1;
      }
      i = len - 1;
      while (i >= 0) {
        if (isdigit(line[i])) {
          digits[1] = line[i];
          break;
        }
        i -= 1;
      }

      total += atoi(digits);
    }
    fclose(file);
    return total;
  } else {
    perror("Error opening file");
    return -1;
  }
}

int char_to_digit(char digit_char) {
  if (digit_char >= '0' && digit_char <= '9') {
    return digit_char - '0';
  } else {
    return -1;
  }
}

int word_to_number(char *line) {
  const char *num_words[] = {"zero", "one", "two",   "three", "four",
                             "five", "six", "seven", "eight", "nine"};

  int first_idx = -1;
  const char *first_pos = NULL;

  for (int i = 0; i < 10; ++i) {
    const char *pos = strstr(line, num_words[i]);

    if (pos != NULL && (first_pos == NULL || pos < first_pos)) {
      first_idx = i;
      first_pos = pos;
    }
  }

  return first_idx;
}

int word_to_number_reverse(char *line) {
  const char *num_words[] = {"orez", "eno", "owt",   "eerht", "ruof",
                             "evif", "xis", "neves", "thgie", "enin"};

  int first_idx = -1;
  const char *first_pos = NULL;

  for (int i = 0; i < 10; ++i) {
    const char *pos = strstr(line, num_words[i]);

    if (pos != NULL && (first_pos == NULL || pos < first_pos)) {
      first_idx = i;
      first_pos = pos;
    }
  }

  return first_idx;
}

int part_two() {
  FILE *file;

  if (fopen_s(&file, "day1input.txt", "r") == 0) {
    char line[128];
    int total = 0;

    while (fgets(line, sizeof(line), file) != NULL) {
      size_t len = strlen(line);
      if (len > 0 && line[len - 1] == '\n') {
        line[len - 1] = '\0';
      }

      size_t i = 0;
      int first_digit;
      while (line[i] != '\0') {
        if (isalpha(line[i])) {
          char word[128];
          size_t j = 0;
          word[j++] = line[i++];
          while (isalpha(line[i])) {
            word[j++] = line[i++];
          }
          word[j] = '\0';
          int res = word_to_number(word);
          if (res != -1) {
            first_digit = res;
            break;
          }
        }

        if (isdigit(line[i])) {
          first_digit = char_to_digit(line[i]);
          break;
        }

        i++;
      }

      i = len - 1;
      int last_digit;
      while (i >= 0) {
        if (isalpha(line[i])) {
          char word[128];
          size_t j = 0;
          word[j++] = line[i--];
          while (isalpha(line[i])) {
            word[j++] = line[i--];
          }
          word[j] = '\0';
          int res = word_to_number_reverse(word);
          if (res != -1) {
            last_digit = res;
            break;
          }
        }

        if (isdigit(line[i])) {
          last_digit = char_to_digit(line[i]);
          break;
        }

        i--;
      }

      total += first_digit * 10 + last_digit;
    }

    fclose(file);
    return total;
  } else {
    perror("Error opening file");
    return -1;
  }
}

int main() {
  int p1_answer = part_one();
  printf("Answer for part 1: %d\n", p1_answer);

  int p2_answer = part_two();
  printf("Answer for part 2: %d\n", p2_answer);

  return 0;
}
