I32 countrows(U8 *str, I64 size) {
 // count number of rows using new line characters
 I64 i;
 I32 rows = 1;
 for (i = 0; i < size; i++) {
  // ASCII code of new line is 10
  if (str[i] == 10) {
   rows++;
  }
 }
 return rows;
}

I32 numlen(U8 *str) {
 // compute length of number
 I32 i = 0;
 // ASCII codes of 0-9 are 48-57
 while (str[i] >= 48 && str[i] <= 57) {
  i++;
 }
 return i;
}

I32 getnum(U8 *str, I32 len) {
 // get number
 I32 n = 0;
 I32 ni;
 I32 i;
 len = len - 1;
 for (i = 0; i <= len; i++) {
  // ASCII codes of 0-9 are 48-57
  ni = str[i] - 48;
  //Print("ni: %d\n", ni);
  n = n * 10 + ni;
 }
 return n;
}

U8 sortBubble(I32 *arr, I32 len) {
 // sort an array with given length using the bubble sort
 I32 i;
 I32 j;
 I32 tmp;
 for (i = 0; i < len - 1; i++) {
  for (j = 0; j < len - i - 1; j++) {
   if (arr[j] > arr[j + 1]) {
    tmp = arr[j];
    arr[j] = arr[j + 1];
    arr[j + 1] = tmp;
   }
  }
 }
 return 0;
}

I64 getAbsDiff(I32 *arr1, I32 *arr2, I32 len) {
 // get absolute difference element wise of arrays
 I32 i;
 I64 ad = 0;
 I64 adi;
 for (i = 0; i < len; i++) {
  adi = Abs(arr1[i] - arr2[i]);
  //Print("adi: %d\n", adi);
  ad = ad + adi;
 }
 return ad;
}

I32 getOccurances(I32 *arr, I32 len, I32 val) {
 // get number of occurances of value in array
 I32 o = 0;
 I32 i;
 for (i = 0; i < len; i++) {
  if (arr[i] == val) {
   o++;
  }
 }
 return o;
}

U8 aoc1() {
 // variable definitions
 I64 size;
 I32 rows;
 I32 len;
 U8 *file;
 U8 *cur;
 I32 i;
 I32 *data1;
 I32 *data2;
 I64 ad;
 I64 ss = 0;
 I32 ssi;


 Print("Day 1 of AOC 2024\n");

 // part 1 of AOC from 2024
 Print("Part 1\n");

 // read the file
 file = FileRead("C:/Home/AOC/input.TXT", &size);
 cur = file;

 //Print("File size: %d\n", size);
 //Print("File contents:\n%s\n", file);

 // get number of rows
 rows = countrows(file, size);
 //Print("File has %d rows\n", rows);

 //len = numlen(file);
 //Print("Length of first number: %d\n", len);
 //Print("First number is %d\n", getnum(file, len));

 // allocate space for data
 data1 = MAlloc(rows * sizeof(I32));
 data2 = MAlloc(rows * sizeof(I32));

 for (i = 0; i < rows; i++) {
  len = numlen(cur);
  data1[i] = getnum(cur, len);
  cur = cur + len + 3;
  len = numlen(cur);
  data2[i] = getnum(cur, len);
  cur = cur + len + 1;
  //Print("%d, %d\n", data1[i], data2[i]);
 }

 /*
 Print("Data1: [");
 for (i = 0; i < rows; i++) {
  Print("%d ", data1[i]);
 }
 Print("]\n");
 Print("Data2: [");
 for (i = 0; i < rows; i++) {
  Print("%d ", data1[i]);
 }
 Print("]\n");
 */

 // sort the data
 sortBubble(data1, rows);
 sortBubble(data2, rows);

 /*
 Print("Data1: [");
 for (i = 0; i < rows; i++) {
  Print("%d ", data1[i]);
 }
 Print("]\n");
 Print("Data2: [");
 for (i = 0; i < rows; i++) {
  Print("%d ", data1[i]);
 }
 Print("]\n");
 */

 // get absolute difference
 ad = getAbsDiff(data1, data2, rows);
 Print("Absolute difference is: %d\n", ad);

 // part 2 of AOC from 2024
 Print("Part 2\n");

 // get similarity score
 for (i = 0; i < rows; i++) {
  ssi = getOccurances(data2, rows, data1[i]) * data1[i];
  //Print("ssi: %d\n", ssi);
  ss = ss + ssi;
 }
 Print("Similarity score is: %d\n", ss);

 Free(file);
 Free(data1);
 Free(data2);
 return 0;
}

aoc1;
