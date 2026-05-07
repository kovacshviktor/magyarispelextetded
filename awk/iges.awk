#
# igékből ás/és főnévképzős, stb. alakok legenerálása, lásd igesgen
#
BEGIN { 
    while ((getline var < "ige_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "ige_tat_kiv.1") > 0) { tat_kiv[var]=1; }
    while ((getline var < "ige_ikes_kiv.1") > 0) { ikes_kiv[var]=1; }
}
# mély hangrendű igék + i
(MELYRAG=="tat" || MELYRAG=="gat") && (tat_kiv[$0]==1 || ikes_kiv[$0]) { next }
! (MELYRAG=="ó" || MELYRAG=="ás") && ikes_kiv[$0] { next }
#/ú$/ {print $1 "v" MELYRAG }
#/ó$/ {print substr($1,1,length($1)-1) "ov" MELYRAG}
#/í$/ {print substr($1,1,length($1)-1) "iv" MELYRAG}
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*ik$/ { print substr($1,1,length($1)-2) MELYRAG }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*ít$/ { print $1 MELYRAG }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]+$/ && ! /(ik|ít)$/ { print $1 MELYRAG }
# magas
mely[$0]==1 { RAG=MELYRAG }
mely[$0]!=1 { RAG=MAGASRAG }
/[iíeéöőüű][bcdfghjklmnpqrstvwxyz]*ik$/ || /-zik$/ { print substr($1,1,length($1)-2) RAG; next }
/[iíeéöőüű][bcdfghjklmnpqrstvwxyz]*ít$/ { print $1 RAG; next }
/[iíeéöőüű][bcdfghjklmnpqrstvwxyz]+$/ && ! /(ik|ít)$/ { print $1 RAG }
