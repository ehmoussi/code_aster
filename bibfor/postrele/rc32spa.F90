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

subroutine rc32spa(ze200, lieu, iocc1, iocc2, ns, sp, spmeca, instsp)
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
    integer :: iocc1, iocc2, ns
    real(kind=8) :: sp(2), instsp(4), spmeca(2)
    aster_logical :: ze200
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200
!     CALCUL DU SP AVEC SELECTION DES INSTANTS SUR LE TRESCA SIGNE
!
!     ------------------------------------------------------------------
! IN  : ZE200  : EST ON EN ZE200 ou en B3200
! IN  : LIEU   : ='ORIG' : ORIGINE DU SEGMENT, ='EXTR' : EXTREMITE
! IN  : IOCC1  : NUMERO D'OCCURENCE DE LA PREMIERE SITUATION
! IN  : IOCC2  : NUMERO D'OCCURENCE DE LA DEUXIEME SITUATION
! IN  : NS     : =0 : PAS DE SEISME, =1 : SEISME
! OUT : SP
! OUT : SPMECA
! OUT : INSTSP : 4 INSTANTS (SP1 et SP2)
!
    integer :: jinfoi, nmecap, npresp, ntherp, jinfor, numcha, iret
    integer :: jchara, jcharb, k, j, jtranp, jsigu, i0, i1, e0(2)
    integer :: jtemp, nmecaq, npresq, ntherq, jtranq, n1, jspseis
    real(kind=8) :: presap, presbp, map(12), mbp(12), s2pp, sb(6)
    real(kind=8) :: instpmin, instpmax, maq(12), mbq(12), presaq
    real(kind=8) :: tresca, sa(6), st(6), sc(6), presbq, sa1(6), sa2(6)
    real(kind=8) :: tempa, tempb, A1(12), B1(12), tempmin, tempmax
    real(kind=8) :: mominp(12), momaxp(12), mij(12), sbm(6)
    real(kind=8) :: stm(6), sa3(6), sa4(6), sb1(6), sb2(6), sc1(6)
    real(kind=8) :: sc2(6), instqmin, instqmax, mominq(12), momaxq(12)
    real(kind=8) :: s2(2), tresca1, tresca2, st11(6), st12(6), st13(6), st14(6)
    real(kind=8) :: st21(6), st22(6), st23(6), st24(6), trescapq(2)
    real(kind=8) :: sbm1(6), sbm2(6), tresme1, tresme2, tresmepq(2)
    real(kind=8) :: stm11(6), stm12(6), stm13(6), stm14(6), stm21(6)
    real(kind=8) :: stm22(6), stm23(6), stm24(6)
    character(len=8) ::  knumec, sscyc
    aster_logical :: tranp, tranq, unitaire
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
    tranp = .false.
    tranq = .false.
    s2(1)  = 0.d0
    s2(2)  = 0.d0
    do 10 k = 1,12
        mominp(k) = 0.d0
        mominq(k) = 0.d0
        momaxp(k) = 0.d0
        momaxq(k) = 0.d0
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
    call jeveuo('&&RC3200.SITU_INFOI', 'L', jinfoi)
    call jeveuo('&&RC3200.SITU_INFOR', 'L', jinfor)
!
!-- on regarde si la pression est sous forme unitaire ou transitoire
!-- on regarde si la méca est sous forme unitaire ou transitoire
    nmecap = zi(jinfoi+27*(iocc1-1)+23)
    npresp = zi(jinfoi+27*(iocc1-1)+23)
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
        sbm(j) = 0.d0
65  continue
    if (nmecap .eq. 2 .or. npresp .eq. 2 .or. ntherp .eq. 1) then
        tranp = .true. 
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc1), 'L', jtranp)
        do 70 j = 1, 6
            sb(j) = zr(jtranp+6+j-1) -zr(jtranp+j-1)
            sbm(j)= zr(jtranp+78+j-1)-zr(jtranp+72+j-1)
70      continue
        instpmin = zr(jtranp+86)
        instpmax = zr(jtranp+87)
    else
        instpmin = -1.0
        instpmax = -1.0
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
                    A1(k) = (map(k)-mbp(k))/(tempa-tempb)
                    B1(k) = (mbp(k)*tempa-map(k)*tempb)/(tempa-tempb)
81          continue
        else
            do 82 k = 1, 12
                    A1(k) = (mbp(k)-map(k))/(tempb-tempa)
                    B1(k) = (map(k)*tempb-mbp(k)*tempa)/(tempb-tempa)
82          continue
        endif
!
        if (tranp) then
            tempmin = zr(jtranp+90)
            tempmax = zr(jtranp+91) 
            do 83 k = 1, 12
                mominp(k) = A1(k)*tempmin+B1(k)
                momaxp(k) = A1(k)*tempmax+B1(k)
                mij(k)=momaxp(k)-mominp(k)
83          continue
        else
            call jeveuo(jexnum('&&RC3200.TEMPCST', iocc1), 'L', jtemp) 
            do 86 k = 1, 12
                if (lieu .eq. 'ORIG') then
                    mominp(k) = A1(k)*zr(jtemp)+B1(k)
                    momaxp(k) = A1(k)*zr(jtemp)+B1(k)
                else
                    mominp(k) = A1(k)*zr(jtemp+1)+B1(k)
                    momaxp(k) = A1(k)*zr(jtemp+1)+B1(k)
                endif
                mij(k)=mominp(k)
86          continue 
        endif
        do 87 j = 1, 6
            do 88 k = 1, 12
                sc(j) = sc(j) + mij(k)*zr(jsigu-1+6*(k-1)+j)
88          continue
87      continue           
    endif
!--------------------------------------------------------------------
!                  DANS LE CAS D'UNE SITUATION SEULE
!                          CALCUL DE SN(P,P)
!--------------------------------------------------------------------
    do 66 i0 = 1, 2
        i1 = 2*(i0-2)+1
        e0(i0) = i1
66  continue
!
    if(iocc2 .eq. 0 .or. iocc1 .eq. iocc2) then
!
      if (ze200) then
        call rcZ2s0('SP', map, mbp, presap, presbp, ns, s2pp) 
        call rctres(sb,tresca)
        sp(1) = s2pp+tresca
        call rctres(sbm,tresca)
        spmeca(1) = s2pp+tresca
      else
        do 71 i0 = 1,2
          do 72 j = 1,6
            st(j) = sb(j)+sc(j)+e0(i0)*sa(j)
            stm(j) = sbm(j)+sc(j)+e0(i0)*sa(j)
72        continue
          if (ns .eq. 0) then
              call rctres(st, tresca)
              sp(1) = max(sp(1), tresca)
              call rctres(stm, tresca)
              spmeca(1) = max(spmeca(1), tresca)
          else
              call rc32s0b(zr(jspseis), st, tresca)
              sp(1) = max(sp(1), tresca)
              call rc32s0b(zr(jspseis), stm, tresca)
              spmeca(1) = max(spmeca(1), tresca)
          endif
          if(.not. unitaire) exit
71      continue
      endif
!
      instsp(1)=instpmin
      instsp(2)=instpmax
!
      call getvtx(' ', 'SOUS_CYCL', scal=sscyc, nbret=n1)
      if(n1 .ne. 0 .and. sscyc .eq. 'OUI') call utmess('A', 'POSTRCCM_56')
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
!-- On récupère les contraintes unitaires
      if (.not. ze200) then
        if (nmecaq .eq. 1 .or. nmecaq .eq. 3 .or. npresq .eq. 1) then
            call jeveuo('&&RC3200.MECA_UNIT .'//lieu, 'L', jsigu)
        endif
      endif
!
      do 44 k = 1, 12
          maq(k) = 0.d0
          mbq(k) = 0.d0
44    continue
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
        sb1(j) = 0.d0
        sb2(j) = 0.d0
        sbm1(j) = 0.d0
        sbm2(j) = 0.d0
        st11(j) = 0.d0
        st12(j) = 0.d0
        st13(j) = 0.d0
        st14(j) = 0.d0
        st21(j) = 0.d0
        st22(j) = 0.d0
        st23(j) = 0.d0
        st24(j) = 0.d0
165   continue
      if (nmecaq .eq. 2 .or. npresq .eq. 2 .or. ntherq .eq. 1) then
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc2), 'L', jtranq)
        tranq = .true.
        instqmin = zr(jtranq+86)
        instqmax = zr(jtranq+87)
      else
          instqmin = -1.0
          instqmax = -1.0
      endif
!
      if (tranp) then
        if (tranq) then
          do 170 j = 1, 6
            sb1(j) = zr(jtranp+6+j-1) -zr(jtranq+j-1)
            sb2(j) = zr(jtranq+6+j-1) -zr(jtranp+j-1)
            sbm1(j) = zr(jtranp+78+j-1) -zr(jtranq+72+j-1)
            sbm2(j) = zr(jtranq+78+j-1) -zr(jtranp+72+j-1)
170        continue
        else
          do 171 j = 1, 6
            sb1(j) = zr(jtranp+6+j-1) 
            sb2(j) = -zr(jtranp+j-1)
            sbm1(j) = zr(jtranp+78+j-1) 
            sbm2(j) =  -zr(jtranp+72+j-1)
171        continue
        endif
      else
        if (tranq) then
          do 172 j = 1, 6
            sb1(j) = -zr(jtranq+j-1)
            sb2(j) = zr(jtranq+6+j-1)
            sbm1(j) =  -zr(jtranq+72+j-1)
            sbm2(j) = zr(jtranq+78+j-1) 
172        continue
        endif
      endif
!
!-- SC partie unitaire avec interpolation des moments
      do 180 j = 1, 6
        sc1(j) = 0.d0
        sc2(j) = 0.d0
180    continue
!
      if (nmecaq .eq. 3) then
        tempa = zr(jinfor+4*(iocc2-1)+2)
        tempb = zr(jinfor+4*(iocc2-1)+3)
        if (tempa .lt. tempb) then
            do 181 k = 1, 12
                    A1(k) = (maq(k)-mbq(k))/(tempa-tempb)
                    B1(k) = (mbq(k)*tempa-maq(k)*tempb)/(tempa-tempb)
181         continue
        else
            do 182 k = 1, 12
                    A1(k) = (mbq(k)-maq(k))/(tempb-tempa)
                    B1(k) = (maq(k)*tempb-mbq(k)*tempa)/(tempb-tempa)
182         continue
        endif
!
        if (tranq) then
            tempmin = zr(jtranq+90)
            tempmax = zr(jtranq+91) 
            do 183 k = 1, 12
                mominq(k) = A1(k)*tempmin+B1(k)
                momaxq(k) = A1(k)*tempmax+B1(k)
183         continue
        else
            call jeveuo(jexnum('&&RC3200.TEMPCST', iocc2), 'L', jtemp) 
            do 186 k = 1, 12
                if (lieu .eq. 'ORIG') then
                    mominq(k) = A1(k)*zr(jtemp)+B1(k)
                    momaxq(k) = A1(k)*zr(jtemp)+B1(k)
                else
                    mominq(k) = A1(k)*zr(jtemp+1)+B1(k)
                    momaxq(k) = A1(k)*zr(jtemp+1)+B1(k)
                endif
186         continue 
        endif
      endif
!
      if(nmecaq .eq. 3 .or. nmecap .eq. 3) then
        do 187 j = 1, 6
            do 188 k = 1, 12
                sc1(j) = sc1(j) + (momaxp(k)-mominq(k))*zr(jsigu-1+6*(k-1)+j)
                sc2(j) = sc2(j) + (momaxq(k)-mominp(k))*zr(jsigu-1+6*(k-1)+j)
188         continue
187     continue  
      endif
!            
! --------------------------------------------------------------
!                          CALCUL DE SP(P,Q)
! --------------------------------------------------------------
      unitaire = .false.
!
!---- Mot clé pour accélerer les calculs si aucun chargement en unitaire
      if(npresp .eq. 1 .or. nmecap .eq. 1) unitaire = .true.
      if(npresq .eq. 1 .or. nmecaq .eq. 1) unitaire = .true.
!
      if (ze200) then
        trescapq(1)= -1.d0
        trescapq(2)= -1.d0
        tresmepq(1)= -1.d0
        tresmepq(2)= -1.d0
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
        call rctres(sb1,tresca1)
        call rctres(sb2,tresca2)
        call rctres(sbm1,tresme1)
        call rctres(sbm2,tresme2)
        if (tresca1 .gt. trescapq(1)) then
            trescapq(1) = tresca1
            trescapq(2) = tresca2
            tresmepq(1) = tresme1
            tresmepq(2) = tresme2
            instsp(1) = instpmax
            instsp(2) = instqmin
            instsp(3) = instqmax
            instsp(4) = instpmin
        endif
        if (tresca2 .gt. trescapq(1)) then
            trescapq(1) = tresca2
            trescapq(2) = tresca1
            tresmepq(1) = tresme2
            tresmepq(2) = tresme1
            instsp(1) = instqmax
            instsp(2) = instpmin
            instsp(3) = instpmax
            instsp(4) = instqmin
        endif
        sp(1) = s2(1)+trescapq(1)
        sp(2) = s2(2)+trescapq(2)
        spmeca(1) = s2(1)+tresmepq(1)
        spmeca(2) = s2(2)+tresmepq(2)
      else
!------ si on est en B3200
        trescapq(1)= -1.d0
        trescapq(2)= -1.d0
        tresmepq(1)= -1.d0
        tresmepq(2)= -1.d0
        do 173 i0 = 1,2
          do 174 j = 1,6
            st11(j) = sb1(j)+sc1(j)+e0(i0)*sa1(j)
            st21(j) = sb2(j)+sc2(j)+e0(i0)*sa1(j)
            stm11(j) = sbm1(j)+sc1(j)+e0(i0)*sa1(j)
            stm21(j) = sbm2(j)+sc2(j)+e0(i0)*sa1(j)
!
            if(unitaire) then
              st12(j) = sb1(j)+sc1(j)+e0(i0)*sa2(j)
              st13(j) = sb1(j)+sc1(j)+e0(i0)*sa3(j)
              st14(j) = sb1(j)+sc1(j)+e0(i0)*sa4(j)
              st22(j) = sb2(j)+sc2(j)+e0(i0)*sa2(j)
              st23(j) = sb2(j)+sc2(j)+e0(i0)*sa3(j)
              st24(j) = sb2(j)+sc2(j)+e0(i0)*sa4(j)
              stm12(j) = sbm1(j)+sc1(j)+e0(i0)*sa2(j)
              stm13(j) = sbm1(j)+sc1(j)+e0(i0)*sa3(j)
              stm14(j) = sbm1(j)+sc1(j)+e0(i0)*sa4(j)
              stm22(j) = sbm2(j)+sc2(j)+e0(i0)*sa2(j)
              stm23(j) = sbm2(j)+sc2(j)+e0(i0)*sa3(j)
              stm24(j) = sbm2(j)+sc2(j)+e0(i0)*sa4(j)
           endif
174       continue
!
!-------- Calcul du SP sans séisme
          if(ns .eq. 0) then
            call rctres(st11, tresca)
            if(tresca .gt. trescapq(1) ) then
              trescapq(1) = tresca
              call rctres(stm11, tresme1)
              tresmepq(1) = tresme1
            endif   
            call rctres(st21, tresca)          
            if(tresca .gt. trescapq(2) ) then
              trescapq(2) = tresca
              call rctres(stm21, tresme2)
              tresmepq(2) = tresme2
            endif  
!       
            if(unitaire) then
              call rctres(st12, tresca) 
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rctres(stm12, tresme1)
                tresmepq(1) = tresme1
              endif   
              call rctres(st13, tresca)
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rctres(stm13, tresme1)
                tresmepq(1) = tresme1
              endif   
              call rctres(st14, tresca)  
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rctres(stm14, tresme1)
                tresmepq(1) = tresme1
              endif   
              call rctres(st22, tresca)     
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rctres(stm22, tresme2)
                tresmepq(2) = tresme2
              endif 
              call rctres(st23, tresca)           
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rctres(stm23, tresme2)
                tresmepq(2) = tresme2
              endif 
              call rctres(st24, tresca)        
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rctres(stm24, tresme2)
                tresmepq(2) = tresme2
              endif
            endif 
          endif
!
!-------- Calcul du SP avec séisme
          if(ns .ne. 0) then
            call rc32s0b(zr(jspseis), st11, tresca)
            if(tresca .gt. trescapq(1) ) then
              trescapq(1) = tresca
              call rc32s0b(zr(jspseis), stm11, tresme1)
              tresmepq(1) = tresme1
            endif 
            call rc32s0b(zr(jspseis), st21, tresca)           
            if(tresca .gt. trescapq(2) ) then
              trescapq(2) = tresca
              call rc32s0b(zr(jspseis), stm21, tresme2)
              tresmepq(2) = tresme2
            endif        
!   
            if(unitaire) then
              call rc32s0b(zr(jspseis), st12, tresca) 
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rc32s0b(zr(jspseis), stm12, tresme1)
                tresmepq(1) = tresme1
              endif   
              call rc32s0b(zr(jspseis), st13, tresca)
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rc32s0b(zr(jspseis), stm13, tresme1)
                tresmepq(1) = tresme1
              endif    
              call rc32s0b(zr(jspseis), st14, tresca) 
              if(tresca .gt. trescapq(1) ) then
                trescapq(1) = tresca
                call rc32s0b(zr(jspseis), stm14, tresme1)
                tresmepq(1) = tresme1
              endif   
              call rc32s0b(zr(jspseis), st22, tresca)    
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rc32s0b(zr(jspseis), stm22, tresme2)
                tresmepq(2) = tresme2
              endif  
              call rc32s0b(zr(jspseis), st23, tresca)           
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rc32s0b(zr(jspseis), stm23, tresme2)
                tresmepq(2) = tresme2
              endif 
              call rc32s0b(zr(jspseis), st24, tresca)          
              if(tresca .gt. trescapq(2) ) then
                trescapq(2) = tresca
                call rc32s0b(zr(jspseis), stm24, tresme2)
                tresmepq(2) = tresme2
              endif
            endif
          endif 
!
          if(.not. unitaire) exit
173     continue
        if(trescapq(1) .gt. sp(1)) then
            sp(1) = trescapq(1)
            sp(2) = trescapq(2)
            spmeca(1) = tresmepq(1)
            spmeca(2) = tresmepq(2)
            instsp(1) = instpmax
            instsp(2) = instqmin
            instsp(3) = instqmax
            instsp(4) = instpmin
        endif
        if(trescapq(2) .gt. sp(1)) then
            sp(1) = trescapq(2)
            sp(2) = trescapq(1)
            spmeca(1) = tresmepq(2)
            spmeca(2) = tresmepq(1)
            instsp(1) = instqmax
            instsp(2) = instpmin
            instsp(3) = instpmax
            instsp(4) = instqmin
        endif
      endif
!
    endif
!
    call jedema()
!
end subroutine
