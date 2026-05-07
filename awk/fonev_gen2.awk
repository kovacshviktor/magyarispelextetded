#
# morfonetikus alternáns főnevek ragozási csoportba sorolása
#
# produktív toldalékolás
#
# külső változó: kulon_e (tulajdonnevek esetén kikapcs. szóösszetétel,
# ha kulon_e==1)
#
BEGIN { 
    while ((getline var < "fonev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
}

function kulon(st, nyi, nyi_rule119) {
    s=""
    if (osszetett[$1]==1) s="/y" nyi; else s = nyi_rule119;
    if (kulon_e==1) return s;
    if (kulonszo[st]!=1) {
	return s "/Y/c" melleknevrag
    } else {
	return "/c" melleknevrag
    }
}

# -talan/-telen és -i képzők (szerelemtelen, *háztalan, *szerelemi, házi)
function talan(s, s2, s3) {
    if (RAG != "") return s
    if (osszetett[$1]==1) return s2
    return s3
}

# -ka, -ke kicsinyítőképző:
# a szó nem összetett, és legalább két szótagú
function ka(s) {
    if (!osszetett[$1] && $1~/[aáeéiíoóöőuúüűAÁEÉIÍOÓÖŐUÚÜŰ].*[aáeéiíoóöőuúüű]/) return s
    return ""
}

# magánhangzóra végződő
function magan(s,s2) {
	return ($1~"[uúoóaáiíeéöőüű]$") ? s : s2
}

# mély hangrendű nevszok, morfonetikus alternánsok 
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*$/  { print $1 "/U" magan("ĎÖ","mô") \
	(RAG!="J"?"Ň":"") kulon($1,"/i", "/ç/i") talan("/Ž", "Ç", "˛") ka("k") }
# magas, ajakréses
/[iíeé][bcdfghjklmnpqrstvwxyz]*$/  {
    if (mely[$1]==1) { print $1 "/U" (RAG!="J"?"Ň":"") magan("ĎÖ","mô") \
		kulon($1,"/i","/ç/i") talan("/Ž", "Ç", "˛") ka("k")}
    else { print $1 "/V" (RAG!="J"?"Ó":"") magan("Đ×","nň") \
		kulon($1,"/j", "/č/j") talan("/Ż", "Č", "ł") ka("l")}
}
# magas, ajakkerekítéses
/[öőüű][bcdfghjklmnpqrstvwxyz]*$/ { print $0 "/W" magan("ŢŘ","Ý") \
	(RAG!="J"?"Ô":"") kulon($1,"/j", "/č/j") talan("/Ż", "Č", "ł") ka("l")}
