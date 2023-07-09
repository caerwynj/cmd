# gdata - gen data from unit test database
# take the number of fields and the number of rows as argument
# all data is numeric

BEGIN { 
  FS=","
  OFS = ""
  ORS = ""
  nrows=5
  nfields=0
}
/2,typ/ { fmt[nfields] = $3 }
/2,len/ { len[nfields] = $3 }
/2,prc/ { prc[nfields] = $3 }
/1,col/ { nfields++ }
/0,tbl/ { 
  file = $3 ".d"
  for (i=0; i < nrows; i++) {
    for (j=(nfields - 1); j >= 0 ; j--) {
	if (fmt[j] ~ /datetime|smalldatetime/) {
	  printf("12:00:00:000AM%s", (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "tinyint") {
	  printf("%s%s", (i + j) % 128, (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "smallint") {
	  printf("%s%s", (i + j) % 32768, (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "int") {
	  printf("%s%s", (i + j) % 2147483648, (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "bit") {
	  printf("1%s", (j == 0) ? "\n" : ",") > file
	} else if (fmt[j] ~ /char|varchar/) {
	  printf("%." len[j] "s%s", i j, (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "numeric") {
	  printf("%." prc[j] "s%s", i j, (j == 0) ? "\n": ",") > file
	} else if (fmt[j] == "image") {
	  printf("2%s", (j == 0) ? "\n": ",") > file
	} else {
	  print "unknown typ " fmt[j] "\n"
	  printf("2%s", (j == 0) ? "\n": ",") > file
	}
    }
  }
  nfields = 0
  close(file)
}
