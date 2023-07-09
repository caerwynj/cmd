#!/home/xcs0998/bin/rc

awk '
BEGIN {
	FS="\t"
	OFS="\t"
	for (i=1; ARGV[i] ~ /^-/; i++){
		split(ARGV[i], f, "")
		for(i in f)
			flags[f[i]] = 1
		ARGV[i]=""
	}
	if(!flags["t"] && !flags["m"])
		flags["s"]=1
	file=ARGV[i]; ARGV[i]=""; ARGC=1
	i++
	if(i >= ARGC)
		ARGV[ARGC++] = "-"
	system("mkinv 2 "file)
}
{
	ret=0
	aRb($2)
	pair[0]=pair[1]=""
	if(flags["t"])
		for(j=1;j<=l && r[j] <= $1;j++)
			tog[t[j]] = tog[t[j]]?0:1
	for(j=1;j<=l;j++){
		pair[0]=r[j]
		pair[1]=r[j+1]
		if(flags["m"])
			fmt($1, $2, $3, r[j], $2, t[j])
		else if(flags["t"] && tog[t[j]] && r[j] <= $1)
			fmt($1, $2, $3, r[j], $2, t[j])		
		else if(flags["s"] && sjc($1))
			fmt($1, $2, $3, r[j], $2, t[j])
	}
	if(ret==0 && flags["o"])
		fmt($1,$2,$3,"",$2,"")
	if(flags["t"])
		for(i in tog)
			delete tog[i]
}

func fn(n){
	if(flags["d"])
		return int(n/l)
	else
		return n
}

func fmt(t1,a,b,t2,c,d){
	ret++
	if(flags["r"]){
		printf("%s%c%s%c%s%c", t1, OFS, a, OFS,  fn(d), (NF>3?OFS: "\n"))
	}else if(flags["j"]){
		printf("%s%c%s%c%s%c%s%c", t1, OFS, a, OFS,  d, OFS, b, (NF>3?OFS: "\n"))
	}else{
		printf("%s%c%s%c%s%c", t1, OFS, d, OFS,  fn(b), (NF>3?OFS: "\n"))
	}
	for(i=4; i<=NF; i++)
		printf("%s%c", $i, (i==NF?"\n": OFS))
}

func sjc(current) {
	if(pair[0] == "")
		return 0
	else if(pair[1] == "")
		if(pair[0] <= current)
			return 1
		else
			return 0
	else if(pair[0] <= current && current < pair[1])
		return 1
	else if(pair[0] == current && current == pair[1])
		return 1
	else
		return 0
}

func aRb(k,  sep){
	sep=""
	if(!(k in date)){
		cmd="look -t\"	\" -x \"" k "\" " file ".2"
		while(cmd | getline x > 0){
			split(x , y, "	")
			date[k]=date[k] sep y[2]
			targ[k]=targ[k] sep y[3]
			sep="	"
		}
		close(cmd)
	}
	l=split(date[k], r, "	")
	split(targ[k], t, "	")	
}
' $*
