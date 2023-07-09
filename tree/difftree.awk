# attempt to implement diffschema in awk. its close but doesn't work
# yet, the pretraverse and lookup functions work, ie the basic tree 
# handling.
BEGIN {	FS=","
	nxt = 1
	last = -1
	counttree = 0
}

{
	node = nxt++ 
	if ($1 == 0) {
		# this is the root of a tree so do not set l
		root[counttree++] = node
	} else if ($1 > last) {
		tree[node - 1, "r"] = node
#		print node - 1, "r = ", node
	} else if ($1 <= last) {
#		print lst[$1], "l = ", node
		tree[lst[$1], "l"] = node
	}
	tree[node, "val"] = $3
	tree[node, "typ"] = $2
	tree[node, "level"] = $1
	last = $1
	lst[$1] = node
}

END {
	difftree(root[0], root[1])
#	pretraverse(root[0], 0)
#	pretraverse(root[1], 0)
	print lookup(tree[1, "r"], "is_default")
}	


function difftree(node1, node2) {
# copy t2 on top of t1
	if (! ((node2, "val") in tree))
		return
	difftree(node1, tree[node2, "l"])
	addnode(node1, node2)
	difftree(node1, tree[node2, "r"])
}

function addnode(node1, node2) {
	print "addnode: " node1, node2
	levellast[0] = 1
	n = lookup(levellast[tree[node2, "level"] - 1], tree[node2, "val"])
	print "n: " n
	if (n == 0) {
		newnode = addend(levellast[tree[node2, "level"] -1], 
			tree[node2, "val"],
			tree[node2, "typ"], tree[node2, "level"])
		levellast[tree[newnode, "level"]] = newnode
		print "newnode: " newnode
	} else {
		tree[n, "diff"] = "exists"
		levellast[tree[n, "level"]] = n
	}
}

function addend(node, val, typ, level) {
	print "addend: ", node, val, typ, level
	if ((node, "l") in tree)
		return addend(tree[node,"l"], val, typ, level)
	else {
		newnode = nxt++
		tree[node,"l"] = newnode
		tree[newnode, "val"] = val
		tree[newnode, "typ"] = typ
		tree[newnode, "level"] = level
		tree[newnode, "diff"] = "new"
		return newnode
	}
}	
		
function pretraverse(node, flag) {
#	print "pretraverse: " node
	if (! ((node,"val") in tree))
		return
	if (flag == 1 && tree[node, "level"] == 0)
		return
	print node, tree[node, "val"], tree[node, "typ"], tree[node, "level"],
			tree[node, "diff"]
	pretraverse(tree[node, "r"], 1)
	pretraverse(tree[node, "l"], 1)
}

function lookup(node, val) {
	if (! ((node, "val") in tree))
		return 0
	print "lookup :" tree[node,"val"] ":::"
	if (tree[node,"val"] == val)
		return node
	else 
		return lookup(tree[node, "l"], val)
}
