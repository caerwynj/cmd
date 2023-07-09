BEGIN {	FS=","
	nxt = 1
	last = -1
}

{	node = nxt++ 
	if ($1 > last) {
		tree[node - 1, "r"] = node
#		print node - 1, "r = ", node
	} else if ($1 <= last) {
#		print lst[$1], "l = ", node
		tree[lst[$1], "l"] = node
	}
	tree[node, "val"] = $3
	tree[node, "typ"] = $2
	last = $1
	lst[$1] = node
}
END {
	pretraverse(1)
	print lookup(tree[1, "r"], "is_default")
}	

function pretraverse(node) {
#	print "debug node: " node
	if (! ((node,"val") in tree))
		return
	print node, tree[node, "val"], tree[node, "typ"]
	pretraverse(tree[node, "r"])
	pretraverse(tree[node, "l"])
}

function lookup(node, val) {
	print "debug :" tree[node,"val"] ":::"
	if (! ((node, "val") in tree))
		return 0
	if (tree[node,"val"] == val)
		return node
	else 
		return lookup(tree[node, "l"], val)
}
