! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine rc32spb(ze200, lieu, iocc1, iocc2, ns,&
                   sp, spmeca, instsp, nbsscyc, spss)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcZ2s0.h"
#include "asterfort/rc32s0b.h"
#include "asterfort/codent.h"
#include "asterfort/jeexin.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/rctres.h"
#include "asterfort/getvtx.h"
#include "asterc/r8vide.h"

    character(len=4) :: lieu
    integer :: iocc1, iocc2, ns, nbsscyc
    real(kind=8) :: sp(2), instsp(4), spmeca(2), spss(100)
    aster_logical :: ze200
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE ZE200 et B3200
!     CALCUL DU SP SANS SELECTION DES INSTANTS
!
!     ------------------------------------------------------------------
! IN  : ZE200  : EST ON EN ZE200 ou en B3200
! IN  : LIEU   : ='ORIG' : ORIGINE DU SEGMENT, ='EXTR' : EXTREMITE
! IN  : IOCC1  : NUMERO D'OCCURENCE DE LA PREMIERE SITUATION
! IN  : IOCC2  : NUMERO D'OCCURENCE DE LA DEUXIEME SITUATION
! IN  : NS     : 0 SANS SEISME OU 1 SI SEISME
! OUT : SP     : SP1 et SP2 
! OUT : INSTSP : INSTANTS DE SP1 et SP2
!
    integer :: jinfoi, nmecap, npresp, ntherp, jinfor, numcha, iret
    integer :: jchara, jcharb, k, j, jtranp, jsigu, i0, i1, e0(2)
    integer :: jtemp, i, l, nbinstp, nmecaq, npresq, ntherq, nbinstq
    integer :: jtranq, instp(4), tmax, n1, tmin, ntrav, vtrav(1000)
    integer :: ntrav2, vtrav2(1000), jspseis
    real(kind=8) :: presap, presbp, map(12), mbp(12), s2pp, sb(6)
    real(kind=8) :: tresca, sa(6), st(6), sc(6), tempa, tempb, A1p(12)
    real(kind=8) :: B1p(12), mij(12), trescamax, presaq, presbq, maq(12)
    real(kind=8) :: sbm(6), trescamecmax, stm(6), momcstp(12), mbq(12)
    real(kind=8) :: sa1(6), sa2(6), sa3(6), sa4(6), st1(6), st2(6), st3(6)
    real(kind=8) :: st4(6), A1q(12), B1q(12), momcstq(12), s2(2), mom2(12)
    real(kind=8) :: mom1(12), stm1(6), stm2(6), stm3(6), stm4(6)
    real(kind=8) :: sb01(6), sb02(6), sb12(6), tresca01, tresca02, tresca12
    real(kind=8) :: sb23(6), tresca23, trescaprin
    character(len=8) ::  knumec, sscyc
    aster_logical :: tranp, tranq, lresi, cycprinok, unitaire
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
    if(.not. ze200 .and. ns .ne. 0) call jeveuo('&&RC3200.SPSEISME.'//lieu, 'L', jspseis)
!
    sp(1)  = 0.d0
    sp(2)  = 0.d0
    spmeca(1)  = 0.d0
    spmeca(2)  = 0.d0
    instsp(1) = -1.d0
    instsp(2) = -1.d0
    instsp(3) = -1.d0
    instsp(4) = -1.d0
    nbsscyc = 0
    tranp = .false.
    tranq = .false.
    cycprinok = .false.
    do 10 k = 1,12
        mom1(k) = 0.d0
        mom2(k) = 0.d0
        momcstp(k) = 0.d0
        momcstq(k) = 0.d0
10  continue
!
! TROIS CONTRIBUTIONS POSSIBLES POUR SP
! SA  : UNITAIRE
!       SOUS SITUATION : CHAR_ETAT_A, CHAR_ETAT_B, PRES_A, PRES_B 
! SB  : TRANSITOIRE
!       SOUS SITUATION : NUME_RESU_THER NUME_RESU_MECA, NUME_RESU_PRES 
! SC  : INTERPOLATION DES MOMENTS
!       SOUS SITUATION : TEMP_A, TEMP_B, CHAR_ETAT_A, CHAR_ETAT_B, TABL_TEMP
!
!--------------------------------------------------------------------
!                  DANS LE CAS D'UNE SITUATION SEULE
!                          CALCUL DE SP(P,P)
!--------------------------------------------------------------------
    call jeveuo('&&RC3200.SITU_INFOI', 'L', jinfoi)
    call jeveuo('&&RC3200.SITU_INFOR', 'L', jinfor)
!
!-- on regarde si la pression est sous forme unitaire ou transitoire
!-- on regarde si la méca est sous forme unitaire ou transitoire
    nmecap = zi(jinfoi+27*(iocc1-1)+23)
    npresp = zi(jinfoi+27*(iocc1-1)+22)
    ntherp = zi(jinfoi+27*(iocc1-1)+26)
!
    unitaire = .false.
!
!---- Mot clé pour accélerer les calculs si aucun chargement en unitaire
    if(npresp .eq. 1 .or. nmecap .eq. 1) unitaire = .true.
!
    presap = zr(jinfor+4*(iocc1-1))
    presbp = zr(jinfor+4*(iocc1-1)+1)
!
    do 30 k = 1, 12
        map(k) = 0.d0
        mbp(k) = 0.d0
30  continue
!
    if (nmecap .eq. 1 .or. nmecap .eq. 3) then
!------ Chargement état A
        numcha = zi(jinfoi+27*(iocc1-1)+24)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jchara)
!------ Chargement état B
        numcha = zi(jinfoi+27*(iocc1-1)+25)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jcharb)
!
        do 31 k = 1, 12
            map(k) = zr(jchara-1+k)
            mbp(k) = zr(jcharb-1+k)
31      continue
!
    endif
!-- On récupère les contraintes unitaires
    if (.not. ze200) then
        if (nmecap .eq. 1 .or. nmecap .eq. 3 .or. npresp .eq. 1) then
            call jeveuo('&&RC3200.MECA_UNIT .'//lieu, 'L', jsigu)
        endif
    endif
!
!-- SA partie unitaire (moments et/ou pression)
    do 40 j = 1, 6
        sa(j) = 0.d0
40  continue
    if (.not. ze200 .and. nmecap .eq. 1) then
        do 50 j = 1, 6
            do 60 k = 1, 12
                sa(j) = sa(j)+(map(k)-mbp(k))*zr(jsigu-1+6*(k-1)+j)
60          continue
50      continue
    endif
    if (.not. ze200 .and. npresp .eq. 1) then
        do 51 j = 1, 6
            sa(j) = sa(j)+(presap-presbp)*zr(jsigu-1+72+j)
51      continue
    endif
!
!-- SB partie transitoire
    do 65 j = 1, 6
        sb(j) = 0.d0
        st(j) = 0.d0
65  continue
!
    if (nmecap .eq. 2 .or. npresp .eq. 2 .or. ntherp .eq. 1) then
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc1), 'L', jtranp)
        tranp = .true.
        nbinstp = int(zr(jtranp))
    endif
!
!-- SC partie unitaire avec interpolation des moments
    do 80 j = 1, 6
        sc(j) = 0.d0
80  continue
!
    if (nmecap .eq. 3) then
        tempa = zr(jinfor+4*(iocc1-1)+2)
        tempb = zr(jinfor+4*(iocc1-1)+3)
        if (tempa .lt. tempb) then
            do 81 k = 1, 12
                    A1p(k) = (map(k)-mbp(k))/(tempa-tempb)
                    B1p(k) = (mbp(k)*tempa-map(k)*tempb)/(tempa-tempb)
81          continue
        else
            do 82 k = 1, 12
                    A1p(k) = (mbp(k)-map(k))/(tempb-tempa)
                    B1p(k) = (map(k)*tempb-mbp(k)*tempa)/(tempb-tempa)
82          continue
        endif
!
! ----  si la situation ne possède aucun transitoire
! ----  (ni thermique, ni de pression ni mécanique)
        if (nmecap .ne. 2 .and. npresp .ne. 2 .and. ntherp .ne. 1) then
            call jeveuo(jexnum('&&RC3200.TEMPCST', iocc1), 'L', jtemp) 
            do 86 k = 1, 12
                if (lieu .eq. 'ORIG') then
                    momcstp(k) = A1p(k)*zr(jtemp)+B1p(k)
                else
                    momcstp(k) = A1p(k)*zr(jtemp+1)+B1p(k)
                endif
86          continue 
            do 87 j = 1, 6
              do 88 k = 1, 12
                sc(j) = sc(j) + momcstp(k)*zr(jsigu-1+6*(k-1)+j)
88            continue
87          continue   
        endif        
    endif
!--------------------------------------------------------------------
!                  DANS LE CAS D'UNE SITUATION SEULE
!--------------------------------------------------------------------
!-- CALCUL DU SP selon le chapitre du RCC-M étudié
!
    do 66 i0 = 1, 2
        i1 = 2*(i0-2)+1
        e0(i0) = i1
66  continue
!
    trescamax = -1.d0
!
    if(iocc2 .eq. 0 .or. iocc1 .eq. iocc2) then
      if (ze200) then
! ----- si on est en ZE200
        call rcZ2s0('SP', map, mbp, presap, presbp, ns, s2pp)
        if (tranp) then
            do 67 i = 1, nbinstp
                do 68 l = 1, nbinstp
                    do 69 j = 1,6
                        sb(j) = zr(jtranp+50*(i-1)+1+j)- zr(jtranp+50*(l-1)+1+j)
69                  continue
                    call rctres(sb,tresca)
                    if(tresca .gt. trescamax) then
                        trescamax=tresca
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranp+50*(l-1)+1)
                        tmin = min(i,l)
                        tmax = max(i,l)
                    endif
68              continue
67          continue         
            sp(1) = s2pp+trescamax
            do 64 j = 1,6
                sbm(j) = zr(jtranp+50*(tmax-1)+1+6+j)- zr(jtranp+50*(tmin-1)+1+6+j)
64          continue
            call rctres(sbm, trescamecmax)            
            spmeca(1) = s2pp+trescamecmax
        else
            sp(1) = s2pp
        endif
      else
! ----- si on est en B3200
        if (tranp) then
          do 70 i = 1, nbinstp
            do 71 l = 1, nbinstp
!
              do 72 i0 = 1,2
                do 73 j = 1,6
                    sc(j) = 0.d0
                    sb(j) = zr(jtranp+50*(i-1)+1+j)- zr(jtranp+50*(l-1)+1+j)
                    sbm(j) = zr(jtranp+50*(i-1)+1+6+j)- zr(jtranp+50*(l-1)+1+6+j)
!
                    if (nmecap .eq. 3) then
                      do 83 k = 1, 12
                        mij(k)=A1p(k)*(zr(jtranp+50*(i-1)+1+48+1)-zr(jtranp+50*(l-1)+1+48+1))
                        sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
83                     continue
                    endif
!
                    st(j) = sb(j)+sc(j)+e0(i0)*sa(j)
                    stm(j) = sbm(j)+sc(j)+e0(i0)*sa(j)
!
73              continue
                if (ns .eq. 0) then
                  call rctres(st,tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      instsp(1) = zr(jtranp+50*(i-1)+1)
                      instsp(2) = zr(jtranp+50*(l-1)+1)
                      tmin = min(i,l)
                      tmax = max(i,l)
                      call rctres(stm, trescamecmax)
                  endif
                else
                  call rc32s0b(zr(jspseis), st, tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      instsp(1) = zr(jtranp+50*(i-1)+1)
                      instsp(2) = zr(jtranp+50*(l-1)+1)
                      call rc32s0b(zr(jspseis), stm, trescamecmax)
                  endif
                endif
                if(.not. unitaire) exit
72            continue
71          continue
70        continue
        else
            do 74 i0 = 1,2
                do 75 j = 1,6
                    st(j) = sc(j)+e0(i0)*sa(j)
75              continue
                if (ns .eq. 0) then
                  call rctres(st,tresca)
                  trescamax=max(tresca, trescamax)
                  trescamecmax= trescamax
                else
                  call rc32s0b(zr(jspseis), st, tresca)
                  trescamax=max(tresca, trescamax)
                  trescamecmax= trescamax
                endif
74            continue
        endif
        sp(1) = trescamax
        spmeca(1) = trescamecmax
      endif
!
!-- CALCUL DU SP_SOUS_CYCLE
      lresi = .false.
      call getvtx(' ', 'SOUS_CYCL', scal=sscyc, nbret=n1)
      if(tranp .and. ns .eq. 0 .and. sscyc .eq. 'OUI') then
!
!-------- ETAPE 1 : On recalcule le cycle principal pour ne pas le prendre en compte deux fois
!
          do 25 k = 1,6 
              sb01(k) = zr(jtranp+50*(tmin-1)+1+k) - zr(jtranp+50*(tmax-1)+1+k)
25        continue    
          call rctres(sb01, trescaprin)
!
!-------- ETAPE 2 : Sélection des extremas
!
!-------- on garde le premier instant comme un extrema
          ntrav = 1
          vtrav(1) = 1
          i = 1
          j = 2
!
1 continue
          if (i+2 .gt. nbinstp .or. j+1 .gt. nbinstp) then
              goto 100
          endif
!
          do 76 k = 1,6 
              sb01(k) = zr(jtranp+50*(i-1)+1+k) - zr(jtranp+50*(j-1)+1+k)
              sb02(k) = zr(jtranp+50*(i-1)+1+k) - zr(jtranp+50*(j+1-1)+1+k)
              sb12(k) = zr(jtranp+50*(j-1)+1+k) - zr(jtranp+50*(j+1-1)+1+k)
76        continue
!
          call rctres(sb01,tresca01)
          call rctres(sb02,tresca02)
          call rctres(sb12,tresca12)
!
          if(tresca01 .lt. tresca02 .and. tresca02 .gt. tresca12) then
              j = j+1
              goto 1
          else if(tresca01 .lt. 1.0e-12) then
              j = j+1
              goto 1
          else
              ntrav = ntrav+1
              vtrav(ntrav) = j
              i = j
              j = j+1
              goto 1
          endif     
!
100 continue
!
!-------- on garde le dernier instant comme un extrema
          i = nbinstp
          do 77 k = 1,6 
              sb01(k) = zr(jtranp+50*(nbinstp-1)+1+k) - zr(jtranp+50*(vtrav(ntrav)-1)+1+k)
77        continue
          call rctres(sb01, tresca01) 
          if(tresca01 .gt. 1.0e-12) then
              ntrav= ntrav+1
              vtrav(ntrav) = nbinstp
          endif
!
!
!-------- ETAPE 3 : Extraction des sous-cycles
2 continue
          i = 1
!
3 continue
          if (i+3 .gt. ntrav) then
              goto 200
          endif
!
          do 78 k = 1,6 
              sb01(k) = zr(jtranp+50*(vtrav(i+1)-1)+1+k) - zr(jtranp+50*(vtrav(i)-1)+1+k)
              sb12(k) = zr(jtranp+50*(vtrav(i+2)-1)+1+k) - zr(jtranp+50*(vtrav(i+1)-1)+1+k)
              sb23(k) = zr(jtranp+50*(vtrav(i+3)-1)+1+k) - zr(jtranp+50*(vtrav(i+2)-1)+1+k)
78        continue
!
          call rctres(sb01,tresca01)
          call rctres(sb12,tresca12)
          call rctres(sb23,tresca23)
!
          if (tresca01 .ge. tresca12 .and. tresca23 .ge. tresca12) then
              if(.not. cycprinok .and. abs(tresca12-trescaprin) .lt. 1e-6) then
                  cycprinok = .true.
              else
                  nbsscyc = nbsscyc+1
                  if (nbsscyc .gt. 100) then
                      call utmess('A', 'POSTRCCM_57')
                  else
                      spss(nbsscyc) = tresca12
                  endif
              endif
!
              do 4 k = i+1, ntrav-2
                  vtrav(k) = vtrav(k+2)
4             continue
              ntrav = ntrav-2
              i = 1
              goto 3
          else
              i=i+1
              goto 3
          endif
!
200 continue
!
!-------- ETAPE 4 : Traitement du résidu
!
          if (.not.lresi .and. ntrav .gt. 1) then
!
!---------- raccordement rn est-il un extrema ?
            ntrav2 = ntrav
            do 5 k = 1, ntrav-1
                vtrav2(k) = vtrav(k)
5           continue            
            do 79 k = 1,6 
              sb01(k) = zr(jtranp+50*(vtrav(ntrav-1)-1)+1+k) - zr(jtranp+50*(vtrav(ntrav)-1)+1+k)
              sb02(k) = zr(jtranp+50*(vtrav(ntrav-1)-1)+1+k) - zr(jtranp+50*(vtrav(1)-1)+1+k)
              sb12(k) = zr(jtranp+50*(vtrav(ntrav)-1)+1+k) - zr(jtranp+50*(vtrav(1)-1)+1+k)
79          continue
!
            call rctres(sb01,tresca01)
            call rctres(sb02,tresca02)
            call rctres(sb12,tresca12)
!
            if(tresca01 .lt. tresca02 .and. tresca02 .gt. tresca12) then
                ntrav2 = ntrav2-1  
            else
                vtrav2(ntrav2) = vtrav(ntrav)
            endif 
!             
!---------- raccordement r1 est-il un extrema ?          
            do 20 k = 1,6 
              sb01(k) = zr(jtranp+50*(vtrav2(ntrav2)-1)+1+k) - zr(jtranp+50*(vtrav(1)-1)+1+k)
              sb02(k) = zr(jtranp+50*(vtrav2(ntrav2)-1)+1+k) - zr(jtranp+50*(vtrav(2)-1)+1+k)
              sb12(k) = zr(jtranp+50*(vtrav(1)-1)+1+k) - zr(jtranp+50*(vtrav(2)-1)+1+k)
20          continue
!
            call rctres(sb01,tresca01)
            call rctres(sb02,tresca02)
            call rctres(sb12,tresca12)
!
            if(tresca01 .lt. tresca02 .and. tresca02 .gt. tresca12) then
                do 21 k = 1, ntrav-1
                  vtrav2(ntrav2+k) = vtrav(k+1)
21               continue  
                ntrav2 = ntrav2+ntrav-1
            else if(tresca01 .lt. 1e-12) then
                do 22 k = 1, ntrav-1
                  vtrav2(ntrav2+k) = vtrav(k+1)
22               continue  
                ntrav2 = ntrav2+ntrav-1
            else
                do 23 k = 1, ntrav
                  vtrav2(ntrav2+k) = vtrav(k)
23               continue  
                ntrav2 = ntrav2+ntrav
            endif   
!---------- on recommence l'extraction des sous cycles une seule fois
            lresi = .true.
            ntrav = ntrav2
            do 24 k = 1, ntrav
                vtrav(k) = vtrav2(k)
24          continue  
            goto 2          
          endif 
!
      endif
!-- FIN DU CALCUL DU SP_SOUS_CYCLE
!
    else
!--------------------------------------------------------------------
!                  DANS LE CAS D'UNE COMBINAISON DE SITUATIONS
!--------------------------------------------------------------------
!-- on regarde si la pression est sous forme unitaire ou transitoire
!-- on regarde si la méca est sous forme unitaire ou transitoire
      nmecaq = zi(jinfoi+27*(iocc2-1)+23)
      npresq = zi(jinfoi+27*(iocc2-1)+22)
      ntherq = zi(jinfoi+27*(iocc2-1)+26)
!
      presaq = zr(jinfor+4*(iocc2-1))
      presbq = zr(jinfor+4*(iocc2-1)+1)
!
      do 44 k = 1, 12
          maq(k) = 0.d0
          mbq(k) = 0.d0
44    continue
!
!-- On récupère les contraintes unitaires
      if (.not. ze200) then
        if (nmecaq .eq. 1 .or. nmecaq .eq. 3 .or. npresq .eq. 1) then
            call jeveuo('&&RC3200.MECA_UNIT .'//lieu, 'L', jsigu)
        endif
      endif
!
      if (nmecaq .eq. 1 .or. nmecaq .eq. 3) then
!------ Chargement état A
        numcha = zi(jinfoi+27*(iocc2-1)+24)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jchara)
!------ Chargement état B
        numcha = zi(jinfoi+27*(iocc2-1)+25)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jcharb)
        do 45 k = 1, 12
            maq(k) = zr(jchara-1+k)
            mbq(k) = zr(jcharb-1+k)
45      continue
      endif
!
!-- SA partie unitaire (moments et/ou pression)
      do 140 j = 1, 6
        sa1(j) = 0.d0
        sa2(j) = 0.d0
        sa3(j) = 0.d0
        sa4(j) = 0.d0
140    continue
      if (.not. ze200) then
        if(nmecap .eq. 1) then
          do 150 j = 1, 6
            do 160 k = 1, 12
                sa1(j) = sa1(j)+map(k)*zr(jsigu-1+6*(k-1)+j)
                sa2(j) = sa2(j)+map(k)*zr(jsigu-1+6*(k-1)+j)
                sa3(j) = sa3(j)+mbp(k)*zr(jsigu-1+6*(k-1)+j)
                sa4(j) = sa4(j)+mbp(k)*zr(jsigu-1+6*(k-1)+j)
160          continue
150      continue
        endif
!
        if(nmecaq .eq. 1) then
          do 250 j = 1, 6
            do 260 k = 1, 12
                sa1(j) = sa1(j)-mbq(k)*zr(jsigu-1+6*(k-1)+j)
                sa2(j) = sa2(j)-maq(k)*zr(jsigu-1+6*(k-1)+j)
                sa3(j) = sa3(j)-mbq(k)*zr(jsigu-1+6*(k-1)+j)
                sa4(j) = sa4(j)-maq(k)*zr(jsigu-1+6*(k-1)+j)
260          continue
250      continue
        endif
!
        if(npresp .eq. 1 .or. npresq .eq. 1) then
          do 151 j = 1, 6
              sa1(j) = sa1(j)+(presap-presbq)*zr(jsigu-1+72+j)
              sa2(j) = sa2(j)+(presap-presaq)*zr(jsigu-1+72+j)
              sa3(j) = sa3(j)+(presbp-presbq)*zr(jsigu-1+72+j)
              sa4(j) = sa4(j)+(presbp-presaq)*zr(jsigu-1+72+j)
151      continue
        endif
      endif
!
!-- SB partie transitoire
      do 165 j = 1, 6
        sb(j) = 0.d0
        sbm(j) = 0.d0
        st1(j) = 0.d0
        st2(j) = 0.d0
        st3(j) = 0.d0
        st4(j) = 0.d0
        stm1(j) = 0.d0
        stm2(j) = 0.d0
        stm3(j) = 0.d0
        stm4(j) = 0.d0
165   continue
!
      if (nmecaq .eq. 2 .or. npresq .eq. 2 .or. ntherq .eq. 1) then
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc2), 'L', jtranq)
        tranq = .true.
        nbinstq = int(zr(jtranq))
      endif
!
!-- SC partie unitaire avec interpolation des moments
      do 180 j = 1, 6
        sc(j) = 0.d0
180   continue
!
      if (nmecaq .eq. 3) then
        tempa = zr(jinfor+4*(iocc2-1)+2)
        tempb = zr(jinfor+4*(iocc2-1)+3)
        if (tempa .lt. tempb) then
            do 181 k = 1, 12
                    A1q(k) = (maq(k)-mbq(k))/(tempa-tempb)
                    B1q(k) = (mbq(k)*tempa-maq(k)*tempb)/(tempa-tempb)
181         continue
        else
            do 182 k = 1, 12
                    A1q(k) = (mbq(k)-maq(k))/(tempb-tempa)
                    B1q(k) = (maq(k)*tempb-mbq(k)*tempa)/(tempb-tempa)
182         continue
        endif
!
! ----  si la situation ne possède aucun transitoire
! ----  (ni thermique, ni de pression ni mécanique)
        if (.not. tranq) then
            call jeveuo(jexnum('&&RC3200.TEMPCST', iocc2), 'L', jtemp) 
            do 186 k = 1, 12
                if (lieu .eq. 'ORIG') then
                    momcstq(k) = A1q(k)*zr(jtemp)+B1q(k)
                else
                    momcstq(k) = A1q(k)*zr(jtemp+1)+B1q(k)
                endif
186          continue   
        endif        
      endif
!            
! --------------------------------------------------------------
!                          CALCUL DE SP(P,Q)
! --------------------------------------------------------------
!
      trescamax = -1.d0
      s2(1) = 0.d0
      s2(2) = 0.d0
      unitaire = .false.
!
!---- Mot clé pour accélerer les calculs si aucun chargement en unitaire
      if(npresp .eq. 1 .or. nmecap .eq. 1) unitaire = .true.
      if(npresq .eq. 1 .or. nmecaq .eq. 1) unitaire = .true.
!
      if (ze200) then
! ----- si on est en ZE200
        call rcZ2s0('SP', map, mbq, presap, presbq, ns, s2pp)
        if(s2pp .gt. s2(1)) then
            s2(1) = s2pp
            call rcZ2s0('SP', mbp, maq, presbp, presaq, ns, s2(2))
        endif
        call rcZ2s0('SP', map, maq, presap, presaq, ns, s2pp)
        if(s2pp .gt. s2(1)) then
            s2(1) = s2pp
            call rcZ2s0('SP', mbp, mbq, presbp, presbq, ns, s2(2))
        endif
        call rcZ2s0('SP', mbp, maq, presbp, presaq, ns, s2pp)
        if(s2pp .gt. s2(1)) then
            s2(1) = s2pp
            call rcZ2s0('SP', map, mbq, presap, presbq, ns, s2(2))
        endif
        call rcZ2s0('SP', mbp, mbq, presbp, presbq, ns, s2pp)
        if(s2pp .gt. s2(1)) then
            s2(1) = s2pp
            call rcZ2s0('SP', map, maq, presap, presaq, ns, s2(2))
        endif
!
        if (tranp) then
          if(tranq) then
            do 167 i = 1, nbinstp
                do 168 l = 1, nbinstq
                    do 169 j = 1,6
                        sb(j) = zr(jtranp+50*(i-1)+1+j)- zr(jtranq+50*(l-1)+1+j)
                        sbm(j) = zr(jtranp+50*(i-1)+1+6+j)- zr(jtranq+50*(l-1)+1+6+j)
169                 continue
                    call rctres(sb,tresca)
                    if(tresca .gt. trescamax) then
                        trescamax=tresca
                        call rctres(sbm,trescamecmax)
                        instp(1) = i
                        instp(2) = l
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                    endif
168             continue
167         continue    
          else
            do 267 i = 1, nbinstp
                do 269 j = 1,6
                    sb(j) = zr(jtranp+50*(i-1)+1+j)
                    sbm(j) = zr(jtranp+50*(i-1)+1+6+j)
269             continue
                call rctres(sb,tresca)
                if(tresca .gt. trescamax) then
                    call rctres(sbm,trescamecmax)
                    trescamax=tresca
                    instp(1) = i
                    instsp(1) = zr(jtranp+50*(i-1)+1)
                endif
267         continue
          endif
        else   
          if(tranq) then
            do 368 l = 1, nbinstq
                do 369 j = 1,6
                    sb(j) = - zr(jtranq+50*(l-1)+1+j)
                    sbm(j) = - zr(jtranq+50*(l-1)+1+6+j)
369             continue
                call rctres(sb,tresca)
                if(tresca .gt. trescamax) then
                    call rctres(sbm,trescamecmax)
                    trescamax=tresca
                    instp(2) = l
                    instsp(2) = zr(jtranq+50*(l-1)+1)
                endif
368         continue  
          endif
!
        endif
!
        sp(1) = s2(1)+trescamax
        spmeca(1) = s2(1)+trescamecmax
!
      else
! ----- si on est en B3200
        if (tranp) then
! ----- la première situation a un transitoire
          if(tranq) then
! ------- la deuxième situation a un transitoire
            do 467 i = 1, nbinstp
                do 468 l = 1, nbinstq
                  do 469 i0 = 1, 2 
                    do 470 j = 1,6
                        sc(j)= 0.d0
                        sb(j) = zr(jtranp+50*(i-1)+1+j)- zr(jtranq+50*(l-1)+1+j)
                        sbm(j) = zr(jtranp+50*(i-1)+1+6+j)- zr(jtranq+50*(l-1)+1+6+j)
                        do 483 k = 1, 12
                          if (nmecap .eq. 3) mom1(k) = A1p(k)*zr(jtranp+50*(i-1)+1+48+1)+B1p(k)
                          if (nmecaq .eq. 3) mom2(k) = A1q(k)*zr(jtranq+50*(l-1)+1+48+1)+B1q(k)
                          mij(k)=mom1(k)-mom2(k)
                          if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                            sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                          endif
483                     continue
                        st1(j) = sb(j)+sc(j)+e0(i0)*sa1(j)
                        stm1(j) = sbm(j)+sc(j)+e0(i0)*sa1(j)
                        if(unitaire) then
                          st2(j) = sb(j)+sc(j)+e0(i0)*sa2(j)
                          st3(j) = sb(j)+sc(j)+e0(i0)*sa3(j)
                          st4(j) = sb(j)+sc(j)+e0(i0)*sa4(j)
                          stm2(j) = sbm(j)+sc(j)+e0(i0)*sa2(j)
                          stm3(j) = sbm(j)+sc(j)+e0(i0)*sa3(j)
                          stm4(j) = sbm(j)+sc(j)+e0(i0)*sa4(j)
                        endif
470                 continue
!                    
                    if (ns .eq. 0) call rctres(st1,tresca)
                    if (ns .ne. 0) call rc32s0b(zr(jspseis), st1, tresca)
                    if(tresca .gt. trescamax) then
                        trescamax=tresca
                        if(ns .eq. 0) call rctres(stm1, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm1, trescamecmax)
                        instp(1) = i
                        instp(2) = l
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                    endif
                    if(unitaire) then
                      if (ns .eq. 0) call rctres(st2,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st2, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm2, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm2, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instp(2) = l
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st3,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st3, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm3, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm3, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instp(2) = l
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st4,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st4, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm4, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm4, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instp(2) = l
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                    endif
                    if(.not. unitaire) exit
469               continue
468             continue
467         continue    
          else
! ------- la deuxième situation n'a pas de transitoire
            do 567 i = 1, nbinstp
                  do 569 i0 = 1, 2 
                    do 570 j = 1,6
                        sc(j)= 0.d0
                        sb(j) = zr(jtranp+50*(i-1)+1+j)- 0.d0
                        sbm(j) = zr(jtranp+50*(i-1)+1+6+j)
                        do 583 k = 1, 12
                          if (nmecap .eq. 3) mom1(k) = A1p(k)*zr(jtranp+50*(i-1)+1+48+1)+B1p(k)
                          mij(k)=mom1(k)-momcstq(k)
                          if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                            sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                          endif
583                     continue
                        st1(j) = sb(j)+sc(j)+e0(i0)*sa1(j)
                        stm1(j) = sbm(j)+sc(j)+e0(i0)*sa1(j)
                        if(unitaire) then
                          st2(j) = sb(j)+sc(j)+e0(i0)*sa2(j)
                          st3(j) = sb(j)+sc(j)+e0(i0)*sa3(j)
                          st4(j) = sb(j)+sc(j)+e0(i0)*sa4(j)
                          stm2(j) = sbm(j)+sc(j)+e0(i0)*sa2(j)
                          stm3(j) = sbm(j)+sc(j)+e0(i0)*sa3(j)
                          stm4(j) = sbm(j)+sc(j)+e0(i0)*sa4(j)
                        endif
570                 continue
!                    
                    if (ns .eq. 0) call rctres(st1,tresca)
                    if (ns .ne. 0) call rc32s0b(zr(jspseis), st1, tresca)
                    if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm1, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm1, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                    endif
!
                    if(unitaire) then
                      if (ns .eq. 0) call rctres(st2,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st2, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm2, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm2, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st3,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st3, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm3, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm3, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st4,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st4, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm4, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm4, trescamecmax)
                        trescamax=tresca
                        instp(1) = i
                        instsp(1) = zr(jtranp+50*(i-1)+1)
                      endif
                    endif
                    if(.not. unitaire) exit
569               continue
567         continue    
          endif
        else  
! ----- la première situation n'a pas de transitoire
          if(tranq) then
! ------- la deuxième situation a un transitoire
              do 668 l = 1, nbinstq
                  do 669 i0 = 1, 2 
                    do 670 j = 1,6
                        sc(j)= 0.d0
                        sb(j) = 0.d0- zr(jtranq+50*(l-1)+1+j)
                        sbm(j) =- zr(jtranq+50*(l-1)+1+6+j)
                        do 683 k = 1, 12
                          if (nmecaq .eq. 3) mom2(k) = A1q(k)*zr(jtranq+50*(l-1)+1+48+1)+B1q(k)
                          mij(k)=momcstp(k)-mom2(k)
                          if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                            sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                          endif
683                     continue
                        st1(j) = sb(j)+sc(j)+e0(i0)*sa1(j)
                        stm1(j) = sbm(j)+sc(j)+e0(i0)*sa1(j)
                        if(unitaire)then
                          st2(j) = sb(j)+sc(j)+e0(i0)*sa2(j)
                          st3(j) = sb(j)+sc(j)+e0(i0)*sa3(j)
                          st4(j) = sb(j)+sc(j)+e0(i0)*sa4(j)
                          stm2(j) = sbm(j)+sc(j)+e0(i0)*sa2(j)
                          stm3(j) = sbm(j)+sc(j)+e0(i0)*sa3(j)
                          stm4(j) = sbm(j)+sc(j)+e0(i0)*sa4(j)
                        endif
670                 continue
!                    
                    if (ns .eq. 0) call rctres(st1,tresca)
                    if (ns .ne. 0) call rc32s0b(zr(jspseis), st1, tresca)
                    if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm1, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm1, trescamecmax)
                        trescamax=tresca
                        instp(2) = l
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                    endif
!             
                    if(unitaire) then
                      if (ns .eq. 0) call rctres(st2,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st2, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm2, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm2, trescamecmax)
                        trescamax=tresca
                        instp(2) = l
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st3,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st3, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm3, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm3, trescamecmax)
                        trescamax=tresca
                        instp(2) = l
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                      if (ns .eq. 0) call rctres(st4,tresca)
                      if (ns .ne. 0) call rc32s0b(zr(jspseis), st4, tresca)
                      if(tresca .gt. trescamax) then
                        if(ns .eq. 0) call rctres(stm4, trescamecmax)
                        if(ns .ne. 0) call rc32s0b(zr(jspseis), stm4, trescamecmax)
                        trescamax=tresca
                        instp(2) = l
                        instsp(2) = zr(jtranq+50*(l-1)+1)
                      endif
                    endif
                    if(.not. unitaire) exit
669               continue
668           continue  
          else
! ------- la deuxième situation n'a pas non plus de transitoire
              do 769 i0 = 1, 2 
                  do 770 j = 1,6
                      sc(j)= 0.d0
                      do 783 k = 1, 12
                          mij(k)=momcstp(k)-momcstq(k)
                          if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                            sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                          endif
783                   continue
                      st1(j) = sc(j)+e0(i0)*sa1(j)
                      st2(j) = sc(j)+e0(i0)*sa2(j)
                      st3(j) = sc(j)+e0(i0)*sa3(j)
                      st4(j) = sc(j)+e0(i0)*sa4(j)
770               continue
!                    
                  if (ns .eq. 0) call rctres(st1,tresca)
                  if (ns .ne. 0) call rc32s0b(zr(jspseis), st1, tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      trescamecmax=tresca
                  endif
                  if (ns .eq. 0) call rctres(st2,tresca)
                  if (ns .ne. 0) call rc32s0b(zr(jspseis), st2, tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      trescamecmax=tresca
                  endif
                  if (ns .eq. 0) call rctres(st3,tresca)
                  if (ns .ne. 0) call rc32s0b(zr(jspseis), st3, tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      trescamecmax=tresca
                  endif
                  if (ns .eq. 0) call rctres(st4,tresca)
                  if (ns .ne. 0) call rc32s0b(zr(jspseis), st4, tresca)
                  if(tresca .gt. trescamax) then
                      trescamax=tresca
                      trescamecmax=tresca
                  endif
                  if(.not. unitaire) exit
!
769           continue  
          endif 
        endif 
!
        sp(1) = trescamax
        spmeca(1) = trescamecmax
!
!---- fin de si on est en B3200
      endif
!
!---- Calcul de SP(2), de SPMECA(2) et de INSTSP(3 et 4)
!
!---- on trouve d'abord les instants de SP(2)
      trescamax= -1.d0
      if(tranp) then
        do 800 i = 1, nbinstp
            do 810 j = 1, 6
                sb(j)=zr(jtranp+50*(i-1)+1+j)- zr(jtranp+50*(instp(1)-1)+1+j)
810         continue
            call rctres(sb, tresca)
            if (tresca .gt. trescamax) then
                trescamax=tresca
                instp(3) = i
            endif
800     continue
      endif
!
      trescamax= -1.d0
      if(tranq) then
        do 900 l = 1, nbinstq
            do 910 j = 1,6
                sb(j)=zr(jtranq+50*(l-1)+1+j)- zr(jtranq+50*(instp(2)-1)+1+j)
910         continue
            call rctres(sb, tresca)
            if (tresca .gt. trescamax) then
                trescamax=tresca
                instp(4) = l
            endif
900     continue
      endif
!
!-- on calcule les grandeurs
      do 920 j = 1, 6
        sb(j)=0.d0
        sc(j)=0.d0
        sbm(j)=0.d0
920   continue
!
      if (tranp) then
        if (tranq) then
            instsp(3)=zr(jtranp+50*(instp(3)-1)+1)
            instsp(4)=zr(jtranq+50*(instp(4)-1)+1)
            do 921 j = 1,6
                sb(j)=zr(jtranp+50*(instp(3)-1)+1+j)- zr(jtranq+50*(instp(4)-1)+1+j)
                sbm(j) = zr(jtranp+50*(instp(3)-1)+1+6+j)- zr(jtranq+50*(instp(4)-1)+1+6+j)
                do 922 k = 1, 12
                    if (nmecap .eq. 3) mom1(k) = A1p(k)*zr(jtranp+50*(instp(3)-1)+1+48+1)+B1p(k)
                    if (nmecaq .eq. 3) mom2(k) = A1q(k)*zr(jtranq+50*(instp(4)-1)+1+48+1)+B1q(k)
                    mij(k)=mom1(k)-mom2(k)
                    if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                        sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                    endif
922             continue
921         continue
        else
            instsp(3)=zr(jtranp+50*(instp(3)-1)+1)
            do 923 j = 1,6
                sb(j)=zr(jtranp+50*(instp(3)-1)+1+j)- 0.d0
                sbm(j) = zr(jtranp+50*(instp(3)-1)+1+6+j)
                do 924 k = 1, 12
                    if (nmecap .eq. 3) mom1(k) = A1p(k)*zr(jtranp+50*(instp(3)-1)+1+48+1)+B1p(k)
                    mij(k)=mom1(k)-momcstq(k)
                    if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                        sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                    endif
924             continue
923         continue
        endif
      else
        if(tranq) then
            instsp(4)=zr(jtranq+50*(instp(4)-1)+1)
            do 925 j = 1,6
                sb(j)=- zr(jtranq+50*(instp(4)-1)+1+j)
                sbm(j) = - zr(jtranq+50*(instp(4)-1)+1+6+j)
                do 926 k = 1, 12
                    if (nmecaq .eq. 3) mom2(k) = A1q(k)*zr(jtranq+50*(instp(4)-1)+1+48+1)+B1q(k)
                    mij(k)=momcstp(k)-mom2(k)
                    if(nmecap .eq. 3 .or. nmecaq .eq. 3) then
                        sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
                    endif
926             continue
925         continue
        endif
      endif
!
      if(ze200) then
          call rctres(sb, trescamax)
          call rctres(sbm, trescamecmax)
          sp(2) = trescamax+s2(2)
          spmeca(2) = trescamecmax+s2(2)
      else
        trescamax= -1.d0
        trescamecmax= 0.d0
        do 927 i0 = 1, 2 
          do 928 j = 1,6
            st1(j) = sb(j)+ sc(j)+ e0(i0)*sa1(j)
            stm1(j) = sbm(j)+ sc(j)+ e0(i0)*sa1(j)
            if(unitaire) then
              st2(j) = sb(j)+ sc(j)+ e0(i0)*sa2(j)
              st3(j) = sb(j)+ sc(j)+ e0(i0)*sa3(j)
              st4(j) = sb(j)+ sc(j)+ e0(i0)*sa4(j)
              stm2(j) = sbm(j)+ sc(j)+ e0(i0)*sa2(j)
              stm3(j) = sbm(j)+ sc(j)+ e0(i0)*sa3(j)
              stm4(j) = sbm(j)+ sc(j)+ e0(i0)*sa4(j)
            endif
928       continue
!                 
          if (ns .eq. 0) call rctres(st1,tresca)
          if (ns .ne. 0) call rc32s0b(zr(jspseis), st1, tresca)
          if(tresca .gt. trescamax) then
            trescamax=tresca
            if(ns .eq. 0) call rctres(stm1, trescamecmax)
            if(ns .ne. 0) call rc32s0b(zr(jspseis), stm1, trescamecmax)
          endif
!
          if(unitaire) then
            if (ns .eq. 0) call rctres(st2,tresca)
            if (ns .ne. 0) call rc32s0b(zr(jspseis), st2, tresca)
            if(tresca .gt. trescamax) then
              trescamax=tresca
              if(ns .eq. 0) call rctres(stm2, trescamecmax)
              if(ns .ne. 0) call rc32s0b(zr(jspseis), stm2, trescamecmax)
            endif
            if (ns .eq. 0) call rctres(st3,tresca)
            if (ns .ne. 0) call rc32s0b(zr(jspseis), st3, tresca)
            if(tresca .gt. trescamax) then
              if(ns .eq. 0) call rctres(stm3, trescamecmax)
              if(ns .ne. 0) call rc32s0b(zr(jspseis), stm3, trescamecmax)
              trescamax=tresca
            endif
            if (ns .eq. 0) call rctres(st4,tresca)
            if (ns .ne. 0) call rc32s0b(zr(jspseis), st4, tresca)
            if(tresca .gt. trescamax) then
              if(ns .eq. 0) call rctres(stm4, trescamecmax)
              if(ns .ne. 0) call rc32s0b(zr(jspseis), stm4, trescamecmax)
              trescamax=tresca
            endif
          endif
          if(.not. unitaire) exit
!
927     continue
!
        sp(2) = trescamax
        spmeca(2) = trescamecmax
      endif
!
!-- fin de calcul de sp pour une combinaison
    endif
!
    call jedema()
!
end subroutine
