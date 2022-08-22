BEGIN {
	px=0
}
px==0 && /^L3$/ {px=1}
px==1 		{print}
px==1 && /^L7$/ {px=0}
END {
	print "done"
}
