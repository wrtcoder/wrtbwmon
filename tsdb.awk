#!/usr/bin/awk

BEGIN{
    t=0
    interval=10
}

function addEntry(t, _in, _out, entryFile){
    printf "%f/%d/%d ", t, _in, _out >> entryFile
}

function compact(host){
    if(lastCompact[host]){
	print "compacting " host " at time " t ": " t-lastCompact[host] "s"
    } else {
	print "first compaction for " host
    }
    f="./" host ".tsdb"
    print f
    while(1==getline line < f){
	n=split(line, l, " ")
	print n
	if(n > 0){
	    split(l[1], a, "/")
	    firstTS=a[1]
	    lastTS=firstTS
	    s_in=s_out=0
	    print l[1]
	    for(i in l){
		split(l[i], a, "/")
		s_in  += a[2]
		s_out += a[3]
		if(a[1] - lastTS > interval){
		    addEntry(a[1], s_in, s_out, host ".m.tsdb")
		    print a[1], s_in, s_out, host ".m.tsdb"
		    lastTS=a[1]
		    s_in=s_out=0
		}
	    }
	}
    }
    close(f)
    #!@todo retain entries not compacted
    "rm " f
    lastCompact[host] = t
}

function dump(){
    for(host in db_in){
	if(t-lastCompact[host] >= interval)
	    compact(host)
	addEntry(t, db_in[host], db_out[host], host ".tsdb")
	delete db_in[host]
	delete db_out[host]
    }
}

NF==1{
    t=$1
    printf "%s\r", t
    dump()
    next
}

{
    split($1, a, "/")
    host = a[1]
    dir  = a[2]
    if(dir == "in")
	db_in[host] += $2
    else
	db_out[host] += $2
}

END{
    dump()
}