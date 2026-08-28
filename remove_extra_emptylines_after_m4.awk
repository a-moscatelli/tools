# dopo 2 righe consecutive bianche, non fare pass-through di ulteriori righe bianche se ci sono.
# use as: m4.exe -I . -E m4--docker-compose-pplss-v1.yaml | busybox64u.exe awk -f remove_extra_emptylines_after_m4.awk > D:\amos\dc\paperless\docker-compose.yaml

BEGIN{ C=0 }
/^[[:blank:]]*$/ {
	C++
	if(C<=2) print
	next
}
{ C=0; print $0 }

