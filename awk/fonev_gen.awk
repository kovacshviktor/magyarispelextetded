#
# főnevek ragozási csoportba sorolása
#
# külső változó: tulaj_e (tulajdonnevek esetén kikapcs. szóösszetétel)
# ha tulaj_e==1)
# tulaj_geo_e: ötamerikai külön (a földrajzi neveknél a 119. szabály
# nincs elfogadva)
#
# ketchup ingadozása bedrótozva
#

BEGIN { 
    while ((getline var < "fonev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "fonev_magas.1") > 0) { magas[var]=1; }
    while ((getline var < "fonev_magas2.1") > 0) { magas2[var]=1; }
    while ((getline var < "fonev_ing.1") > 0) { ingadozo[var]=1; }
    while ((getline var < "fonev_jaje.1") > 0) { jaje[var]=1; }
    while ((getline var < "fonev_ae.1") > 0) { ae[var]=1; }
    while ((getline var < "fonev_jajeae.1") > 0) { jajeae[var]=1; }
    while ((getline var < "fonev_oe.1") > 0) { oe[var]=1; }
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_eleje.1") > 0) { elejeszo[var]=1; }
    while ((getline var < "fonev_vege.1") > 0) { vegeszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
    while ((getline var < "fonev_a.1") > 0) { a[var]=1; }
    while ((getline var < "fonev_y_i.1") > 0) { y_i[var]=1; }
    while ((getline var < "fonev_y_j.1") > 0) { y_j[var]=1; }
    while ((getline var < "fonev_s.1") > 0) { fn_s[var]=1; }
    while ((getline var < "tobbtagu.1") > 0) { tobbtagu[var]=1; }
    while ((getline var < "fonev_igekoto.1") > 0) { igekoto[var]=1; }
}
function jaje_e(st,j,nemj) {
if (jaje[st]==1 || y_i[st]) {return j;} else {
if (ae[st]==1) {return nemj;} else {
if (jajeae[st]==1) {return j nemj; } else {
if (match(st,"[cghjmsxyvz]$")) { return nemj;}
  else {return j;}  
}}}}

# kulon és igekoto
function kulon(st) {
    igekot = (igekoto[st]==1) ? "/X" : ""
    if (tulaj_e==1) return "/," igekot;
    if (vegeszo[st]==1) {
	return "/x/c" igekot
    } else if (elejeszo[st]==1) {
	return "/v/c" igekot
    } else if (kulonszo[st]!=1) {
	return "/Y/c" igekot
    } else {
	return "/c" igekot
    }
    return igekot
}

# ajakkerekítéses magas csoportok (improduktív -es (könyves), produktív -ös (tökös))

function _s(kotojeles_s) {
    return (tobbtagu[$1] ? kotojeles_s: "")
}

function os(s1, s2) {
    if (oe[$1]==1) return s2;
    return s1;
}

# -jú, -jű

function ju(s1, s2) {
    if (tulaj_e==1) return s1
    if (osszetett[$1] == 1) return s2
    return s1 s2
}

function tulaj(s, s2, s3, s4) {
    if (tulaj_geo_e==1) return "/q" s2
    if (tulaj_e==1) return "/q" s3
    if ($1~/^[^aeuioöőüóúéáżí]*[aeuioöüóőúéáżí]$/) s="" # ti->tiz
    if (osszetett[$1]==1) return s "y" s3
    return s s4
}

# -ka, -ke kicsinyítőképző:
# a szó nem összetett, és legalább két szótagú
function ka(s) {
    if (!osszetett[$1] && $1~/[aáeéiíoóöőuúüűAÁEÉIÍOÓÖŐUÚÜŰ].*[aáeéiíoóöőuúüű]/) return s
    return ""
}

magas2[$1]==1 && !/u$/  { # Weöreshöz, Wordhöz
    print $1 "/W/Ě/Ż/j" (y_i[$1]?"ŐBĐŃ":"ŘMÝÔ") tulaj("/í", "ś", "ČÁ˙", "čłĹĺ") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","˝") ka("l") _s("ů")
    next
}

( /[aáoóuú]$/ || /agrave;$/ || /ugrave;$/ )  && magas2[$1] != 1 {
    print $1 "/Ő/A/U/Q/Ę/Ž/i/Ď/Ň" tulaj("/á", "ľ", "Çżß", "ç˛Ăă") kulon($1) ju("ˇ","ť") _s("÷")
}
/[öőüű]$/ || /oslash;$/ || magas2[$1] == 1 { 
    print $1 "/Ő/C/W/R/Ě/Ż/j/Ţ/Ô" tulaj("/í", "ś", "Č" os("Á˙","Ŕŕ"), "čłĹĺ") kulon($1) ju("¸","˝") _s("ů")
}
/[eéiíä]$/ { 
    if (ingadozo[$1]==1) {
	print $1 "/Ő/A/U/B/V/L/Q/R/Ę/Ž/Ë/Ż/i/j/Ď/Đ/Ó" tulaj("/á/é", "ľś", "ÇżßČ", "çč˛łÄäĂă") kulon($1) ju("ˇ","ť") ju("¸","ź") _s("ř")
    } else {
        if (mely[$1]==1) {
	    print $1 "/Ő/A/U/Q/Ę/Ž/i/Ď/Ň" tulaj("/á", "ľ", "Çżß", "ç˛Ăă") kulon($1) ju("ˇ","ť") _s("÷")
	} else {
	    print $1 "/Ő/B/V/R/Ë/Ż/j/Đ/Ó" tulaj("/é", "ś", "ČŔŕ", "čłÄä") kulon($1) ju("¸","ź") _s("ř")
	}
    }
}

$1=="ketchup" { # [kecsap]-[kecsöp]
		s = fn_s[$1]?"mö":"mô"
	    print $1 "/U/Ę/Ž/i" (a[$1]?"$sŇ" s:(y_i[$1]?"ŐAĎŃ":(y_j[$1]?"ŐKŇ" s:"ÖKŇ" s))) tulaj("/á", "ľ", "Çżß", "ç˛Ăă") jaje_e($1,"/Q","/S/s") kulon($1) ju("ˇ","ť") ka("k") \
            "/W/Ě/Ż/j" (y_i[$1]?"ŐBĐŃ":"ŘMÝÔ") tulaj("/í", "ś", "ČÁ˙", "čłĹĺ") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","˝") ka("l")
            next
}
/[aáoóuúAÁOÓUÚ]['bcdfghjklmnpqrstvwxyzŁĽŚŠŞŤŹŽŻłľśšşťźžżŔĹĆÇČĎĐŃŇŘÝŢßŕĺďđńňřýţ]+$/ { 
    if (ingadozo[$1]==1) {
	s = fn_s[$1]?"nő":"nň"
	s2 = fn_s[$1]?"mö":"mô"
	print $1 "/U/V/Ę/Ž/Ë/Ż/i/j" (y_i[$1]?"ŐABĎĐŃ":"Ö×KLŇÓ" s s2)  tulaj("/á/é", "ľś", "ÇżßČŔŕ", "çč˛ĂăłÄä") jaje_e($1,"/Q/R","/T/t") kulon($1) ju("ˇ","ť") ju("¸","ź") ka("kl") _s("÷ř")
	next
    }
    if (magas[$1]==1) {
		s = fn_s[$1]?"nő":"nň"
	    print $1 "/V/Ë/Ż/j" (y_i[$1]?"ŐBĐŃ": "×LnÓ" s) tulaj("/é", "ś", "ČŔŕ", "čłÄä") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","ź") ka("l") _s("ř")
    } else {
		s = fn_s[$1]?"mö":"mô"
	    print $1 "/U/Ę/Ž/i" (a[$1]?"$sŇ" s:(y_i[$1]?"ŐAĎŃ":(y_j[$1]?"ŐKŇ" s:"ÖKŇ" s))) tulaj("/á", "ľ", "Çżß", "ç˛Ăă") jaje_e($1,"/Q","/S/s") kulon($1) ju("ˇ","ť") ka("k") _s("÷")
    }
}
/[iíeéIÍEÉYë]['bcdfghjklmnpqrstvwxyzŁĽŚŠŞŤŹŽŻłľśšşťźžżŔĹĆÇČĎĐŃŇŘÝŢßŕĺďđńňřýţ]+$/  || /Babe&0219;$/ { 
	s = fn_s[$1]?"nő":"nň"
	s2 = fn_s[$1]?"mö":"mô"
    if (ingadozo[$1]==1) {
		print $1 "/U/V/Ę/Ž/Ë/Ż/i/j" (y_i[$1]?"ŐABĎĐŃ":"Ö×KLŇÓ" s s2)  tulaj("/á/é", "ľś", "ÇżßČŔŕ", "çč˛ĂăłÄä") jaje_e($1,"/Q/R","/T/t") kulon($1) ju("ˇ","ť") ju("¸","ź") ka("kl") _s("÷ř")
    } else {
	if (mely[$1]==1) {
	    print $1 "/U/Ę/Ž/i" (y_i[$1]?"ŐAĎŃ":"ÖKŇ" s2) tulaj("/á", "ľ", "Çżß", "ç˛Ăă") jaje_e($1,"/Q","/S/s") kulon($1) ju("ˇ","ť") ka("k") _s("÷")
	} else { 
	    print $1 "/V/Ë/Ż/j" (y_i[$1]?"ŐBĐŃ":"×LÓ" s) tulaj("/é", "ś", "ČŔŕ", "čłÄä") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","ź") ka("l") _s("ř")
	}
    }
}
/[öőüűÖŐÜŰ]['bcdfghjklmnpqrstvxywzŁĽŚŠŞŤŹŽŻłľśšşťźžżŔĹĆÇČĎĐŃŇŘÝŢßŕĺďđńňřýţ]+$/ { 
    if (oe[$1]==1) {
	print $1 "/V/N/Ë/Ż/j" "×LÝňÔ" tulaj("/é", "ś", "ČŔŕ", "čłÄä") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","ź") ka("l") _s("ř")
    } else {
	print $1 "/W/Ě/Ż/j" (y_i[$1]?"ŐBĐŃ":"ŘMÝňÔ") tulaj("/í", "ś", "ČÁ˙", "čłĹĺ") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","˝") ka("l") _s("ů")
    }
}
/[-]$/ {
    print $1 "/v/c"
}
