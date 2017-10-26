! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine rc32sna(ze200, lieu, iocc1, iocc2, ns, sn, instsn, snet,&
                   sigmoypres, snther, sp3, spmeca3)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcZ2s0.h"
#include "asterfort/rc32s0.h"
#include "asterfort/codent.h"
#include "asterfort/jeexin.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/rctres.h"
#include "asterfort/rc32rt.h"
#include "asterc/r8vide.h"

    character(len=4) :: lieu
    integer :: iocc1, iocc2, ns
    real(kind=8) :: sn, instsn(4), snet, sigmoypres, snther, sp3, spmeca3
    aster_logical :: ze200
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200
!     CALCUL DU SN AVEC SELECTION DES INSTANTS SUR LE TRESCA SIGNE
!
!     ------------------------------------------------------------------
! IN  : ZE200  : EST ON EN ZE200 ou en B3200
! IN  : LIEU   : ='ORIG' : ORIGINE DU SEGMENT, ='EXTR' : EXTREMITE
! IN  : IOCC1  : NUMERO D'OCCURENCE DE LA PREMIERE SITUATION
! IN  : IOCC2  : NUMERO D'OCCURENCE DE LA DEUXIEME SITUATION
! IN  : NS     : =0 : PAS DE SEISME, =1 : SEISME
! OUT : SN    
! OUT : INSTSN : 2 INSTANTS DE SN ET 2 INSTANTS DE SN*
! OUT : SNET   : SN*
! OUT : SIGMOYPRES : CONTRAINTE MOYENNE DE PRESSION (pour le rochet)
! OUT : SNTHER : AMPLITUDE DE CONTRAINTES THERMIQUES(pour le rochet)
!
    integer :: jinfoi, nmecap, npresp, ntherp, jinfor, numcha, iret
    integer :: jchara, jcharb, k, j, jtranp, jsigu, i0, i1, e0(2)
    integer :: jtemp, jtranq, nmecaq, npresq, ntherq, jvalin
    real(kind=8) :: presap, presbp, map(12), mbp(12), s2pp, sb(6), sbet(6)
    real(kind=8) :: smoypr1(6), smoypr2(6), instpmin, instpmax
    real(kind=8) :: tresca, sa(6), st(6), stet(6), sipr(6), sc(6)
    real(kind=8) :: pij, tempa, tempb, A1(12), B1(12), tempmin, tempmax
    real(kind=8) :: mominp(12), momaxp(12), mij(12), maq(12)
    real(kind=8) :: mbq(12), sa1(6), sa2(6), sa3(6), sa4(6)
    real(kind=8) :: presaq, presbq, sb1(6), sb2(6)
    real(kind=8) :: sbet1(6), sbet2(6), instqmin, instqmax, s2, tresca1
    real(kind=8) :: tresca2, st11(6), st12(6), st13(6), st14(6), st21(6)
    real(kind=8) :: st22(6), st23(6), st24(6), stet11(6), stet12(6), stet13(6)
    real(kind=8) :: stet14(6), stet21(6), stet22(6), stet23(6), stet24(6)
    real(kind=8) :: mominq(12), momaxq(12), sc1(6), sc2(6), sith1(6)
    real(kind=8) :: sith2(6), snpres, snmec, k1, c1, k2, c2
    real(kind=8) :: k3, c3, sipr1(6), sipr2(6), simec1(6), simec2(6)
    character(len=8) ::  knumec
    aster_logical :: tranp, tranq
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
    sn  = 0.d0
    snet  = 0.d0
    snther  = 0.d0
    snpres  = 0.d0
    snmec  = 0.d0
    instsn(1) = -1.d0
    instsn(2) = -1.d0
    instsn(3) = -1.d0
    instsn(4) = -1.d0
    sigmoypres = r8vide()
    tranp = .false.
    tranq = .false.
    s2  = 0.d0
    do 10 k = 1,12
        mominp(k) = 0.d0
        mominq(k) = 0.d0
        momaxp(k) = 0.d0
        momaxq(k) = 0.d0
10  continue
!
! TROIS CONTRIBUTIONS POSSIBLES POUR SN
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
    npresp = zi(jinfoi+27*(iocc1-1)+22)
    ntherp = zi(jinfoi+27*(iocc1-1)+26)
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
                sa(j) = sa(j)+(map(k)-mbp(k))*zr(jsigu-1+78+6*(k-1)+j)
60          continue
50      continue
    endif
    if (.not. ze200 .and. npresp .eq. 1) then
        do 51 j = 1, 6
            sa(j) = sa(j)+(presap-presbp)*zr(jsigu-1+78+72+j)
51      continue
    endif
!
!-- SB partie transitoire
    do 65 j = 1, 6
        sb(j) = 0.d0
        sbet(j) = 0.d0
        st(j) = 0.d0
        stet(j) = 0.d0
        smoypr1(j) = 0.d0
        smoypr2(j) = 0.d0
        sipr1(j) =0.d0
        simec1(j) =0.d0
65  continue
    if (nmecap .eq. 2 .or. npresp .eq. 2 .or. ntherp .eq. 1) then
        tranp = .true. 
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc1), 'L', jtranp)
        do 70 j = 1, 6
            sb(j) = zr(jtranp+18+j-1) -zr(jtranp+12+j-1)
            sbet(j) = (zr(jtranp+18+j-1)-zr(jtranp+98+j-1)) -(zr(jtranp+12+j-1)-zr(jtranp+92+j-1))
            smoypr1(j) = zr(jtranp+24+j-1)
            smoypr2(j) = zr(jtranp+30+j-1)
70      continue
        instpmin = zr(jtranp+84)
        instpmax = zr(jtranp+85)
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
            tempmin = zr(jtranp+88)
            tempmax = zr(jtranp+89) 
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
                sc(j) = sc(j) + mij(k)*zr(jsigu-1+78+6*(k-1)+j)
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
! ----- si on est en ZE200
        call rcZ2s0('SN', map, mbp, presap, presbp, ns, s2pp) 
        call rctres(sb,tresca)
        sn = s2pp+tresca
        call rctres(sbet,tresca)
        snet = s2pp+tresca
! ----- si on est en B3200
      else
        do 71 i0 = 1,2
          do 72 j = 1,6
            st(j) = sb(j)+sc(j)+e0(i0)*sa(j)
            stet(j) = sbet(j)+sc(j)+e0(i0)*sa(j)
72        continue
          if (ns .eq. 0) then
              call rctres(st, tresca)
              sn = max(sn, tresca)
              call rctres(stet, tresca)
              snet = max(snet, tresca)
          else
              call rc32s0('SNSN', st, lieu, tresca)
              sn = max(sn, tresca)
              call rc32s0('SNSN', stet, lieu, tresca)
              snet = max(snet, tresca)
          endif
71      continue
      endif
!
      instsn(1)=instpmin
      instsn(2)=instpmax
      instsn(3)=instpmin
      instsn(4)=instpmax
!
!-- Pour le calcul du rochet thermique
      do 41 j = 1, 6
        sipr(j) = 0.d0
41    continue
      if(npresp .eq. 1) then
        if (ze200) then
            call rc32rt(presap, presbp, sigmoypres)
        else
            do 42 j = 1, 6
                pij = max(abs(presap),abs(presbp))
                sipr(j) = pij*zr(jsigu-1+156+72+j)
42          continue
            call rctres(sipr,sigmoypres)
        endif
      else if (npresp .eq. 2) then
        sigmoypres =0.d0
        call rctres(smoypr1,tresca)
        sigmoypres = max(tresca, sigmoypres)
        call rctres(smoypr2,tresca)
        sigmoypres = max(tresca, sigmoypres)
      endif
!
!-- Pour le calcul de snther, snpres
!
      if (tranp) then
        do 43 j = 1, 6
            sith1(j) = zr(jtranp+42+j-1)-zr(jtranp+36+j-1)
            sipr1(j) = zr(jtranp+54+j-1)-zr(jtranp+48+j-1)
            simec1(j) = zr(jtranp+66+j-1)-zr(jtranp+60+j-1)
43      continue
        call rctres(sith1, snther) 
        call rctres(sipr1, snpres) 
        if (ns .eq. 0 .and. .not. ze200) call rctres(simec1, snmec) 
        if (ns .ne. 0 .and. .not. ze200) call rc32s0('SNSN', simec1, lieu, snmec)
      endif
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
                sa1(j) = sa1(j)+map(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa2(j) = sa2(j)+map(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa3(j) = sa3(j)+mbp(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa4(j) = sa4(j)+mbp(k)*zr(jsigu-1+78+6*(k-1)+j)
160          continue
150      continue
        endif
!
        if(nmecaq .eq. 1) then
          do 250 j = 1, 6
            do 260 k = 1, 12
                sa1(j) = sa1(j)-mbq(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa2(j) = sa2(j)-maq(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa3(j) = sa3(j)-mbq(k)*zr(jsigu-1+78+6*(k-1)+j)
                sa4(j) = sa4(j)-maq(k)*zr(jsigu-1+78+6*(k-1)+j)
260          continue
250      continue
        endif
!
        if(npresp .eq. 1 .or. npresq .eq. 1) then
          do 151 j = 1, 6
              sa1(j) = sa1(j)+(presap-presbq)*zr(jsigu-1+78+72+j)
              sa2(j) = sa2(j)+(presap-presaq)*zr(jsigu-1+78+72+j)
              sa3(j) = sa3(j)+(presbp-presbq)*zr(jsigu-1+78+72+j)
              sa4(j) = sa4(j)+(presbp-presaq)*zr(jsigu-1+78+72+j)
151      continue
        endif
      endif
!
!-- SB partie transitoire
      do 165 j = 1, 6
        sb1(j) = 0.d0
        sb2(j) = 0.d0
        sbet1(j) = 0.d0
        sbet2(j) = 0.d0
        sith1(j) = 0.d0
        sith2(j) = 0.d0
        sipr1(j) = 0.d0
        sipr2(j) = 0.d0
        simec1(j) = 0.d0
        simec2(j) = 0.d0
        st11(j) = 0.d0
        st12(j) = 0.d0
        st13(j) = 0.d0
        st14(j) = 0.d0
        st21(j) = 0.d0
        st22(j) = 0.d0
        st23(j) = 0.d0
        st24(j) = 0.d0
        stet11(j) = 0.d0
        stet12(j) = 0.d0
        stet13(j) = 0.d0
        stet14(j) = 0.d0
        stet21(j) = 0.d0
        stet22(j) = 0.d0
        stet23(j) = 0.d0
        stet24(j) = 0.d0
165   continue
      if (nmecaq .eq. 2 .or. npresq .eq. 2 .or. ntherq .eq. 1) then
        call jeveuo(jexnum('&&RC3200.TRANSIT.'//lieu, iocc2), 'L', jtranq)
        tranq = .true.
        instqmin = zr(jtranq+84)
        instqmax = zr(jtranq+85)
      else
          instqmin = -1.0
          instqmax = -1.0
      endif
!
      if (tranp) then
        if (tranq) then
          do 170 j = 1, 6
            sb1(j) = zr(jtranp+18+j-1) -zr(jtranq+12+j-1)
            sb2(j) = zr(jtranq+18+j-1) -zr(jtranp+12+j-1)
            sbet1(j) = (zr(jtranp+18+j-1)-zr(jtranp+98+j-1)) -(zr(jtranq+12+j-1)-zr(jtranq+92+j-1))
            sbet2(j) = (zr(jtranq+18+j-1)-zr(jtranq+98+j-1)) -(zr(jtranp+12+j-1)-zr(jtranp+92+j-1))
            sith1(j) = zr(jtranp+42+j-1)-zr(jtranq+36+j-1)
            sith2(j) = zr(jtranq+42+j-1)-zr(jtranp+36+j-1)
            sipr1(j) = zr(jtranp+54+j-1)-zr(jtranq+48+j-1)
            sipr2(j) = zr(jtranq+54+j-1)-zr(jtranp+48+j-1)
            simec1(j) = zr(jtranp+66+j-1)-zr(jtranq+60+j-1)
            simec2(j) = zr(jtranq+66+j-1)-zr(jtranp+60+j-1)
170        continue
        else
          do 171 j = 1, 6
            sb1(j) = zr(jtranp+18+j-1) 
            sb2(j) = -zr(jtranp+12+j-1)
            sbet1(j) = (zr(jtranp+18+j-1)-zr(jtranp+98+j-1)) 
            sbet2(j) = -(zr(jtranp+12+j-1)-zr(jtranp+92+j-1))
            sith1(j) = zr(jtranp+42+j-1)
            sith2(j) = -zr(jtranp+36+j-1)
            sipr1(j) = zr(jtranp+54+j-1)
            sipr2(j) =-zr(jtranp+48+j-1)
            simec1(j) = zr(jtranp+66+j-1)
            simec2(j) = -zr(jtranp+60+j-1)
171        continue
        endif
      else
        if (tranq) then
          do 172 j = 1, 6
            sb1(j) = -zr(jtranq+12+j-1)
            sb2(j) = zr(jtranq+18+j-1)
            sbet1(j) = -(zr(jtranq+12+j-1)-zr(jtranq+92+j-1))
            sbet2(j) = (zr(jtranq+18+j-1)-zr(jtranq+98+j-1))
            sith1(j) = -zr(jtranq+36+j-1)
            sith2(j) = zr(jtranq+42+j-1)
            sipr1(j) = -zr(jtranq+48+j-1)
            sipr2(j) = zr(jtranq+54+j-1)
            simec1(j) = -zr(jtranq+60+j-1)
            simec2(j) = zr(jtranq+66+j-1)
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
            tempmin = zr(jtranq+88)
            tempmax = zr(jtranq+89) 
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
                sc1(j) = sc1(j) + (momaxp(k)-mominq(k))*zr(jsigu-1+78+6*(k-1)+j)
                sc2(j) = sc2(j) + (momaxq(k)-mominp(k))*zr(jsigu-1+78+6*(k-1)+j)
188         continue
187     continue  
      endif
!            
! --------------------------------------------------------------
!                          CALCUL DE SN(P,Q)
! --------------------------------------------------------------
      if (ze200) then
! ----- si on est en ZE200
        tresca= -1.d0
        call rcZ2s0('SN', map, mbq, presap, presbq, ns, s2pp)
        s2 = max(s2, s2pp) 
        call rcZ2s0('SN', map, maq, presap, presaq, ns, s2pp)
        s2 = max(s2, s2pp) 
        call rcZ2s0('SN', mbp, maq, presbp, presaq, ns, s2pp)
        s2 = max(s2, s2pp) 
        call rcZ2s0('SN', mbp, mbq, presbp, presbq, ns, s2pp)
        s2 = max(s2, s2pp) 
        call rctres(sb1,tresca1)
        if (tresca1 .gt. tresca) then
            tresca = tresca1
            call rctres(sith1, snther)
            call rctres(sipr1, snpres)
            instsn(1) = instpmax
            instsn(2) = instqmin
        endif
        call rctres(sb2,tresca2)
        if (tresca2 .gt. tresca) then
            tresca = tresca2
            call rctres(sith2, snther)
            call rctres(sipr2, snpres)
            instsn(1) = instqmax
            instsn(2) = instpmin
        endif
        sn = s2+tresca
!
        tresca= -1.d0
        call rctres(sbet1,tresca1)
        if (tresca1 .gt. tresca) then
            tresca = tresca1
            instsn(3) = instpmax
            instsn(4) = instqmin
        endif
        call rctres(sbet2,tresca2)
        if (tresca2 .gt. tresca) then
            tresca = tresca2
            instsn(3) = instqmax
            instsn(4) = instpmin
        endif
        snet = s2+tresca
      else
! ----- si on est en B3200
        do 173 i0 = 1,2
          do 174 j = 1,6
            st11(j) = sb1(j)+sc1(j)+e0(i0)*sa1(j)
            st12(j) = sb1(j)+sc1(j)+e0(i0)*sa2(j)
            st13(j) = sb1(j)+sc1(j)+e0(i0)*sa3(j)
            st14(j) = sb1(j)+sc1(j)+e0(i0)*sa4(j)
            st21(j) = sb2(j)+sc2(j)+e0(i0)*sa1(j)
            st22(j) = sb2(j)+sc2(j)+e0(i0)*sa2(j)
            st23(j) = sb2(j)+sc2(j)+e0(i0)*sa3(j)
            st24(j) = sb2(j)+sc2(j)+e0(i0)*sa4(j)
            stet11(j) = sbet1(j)+sc1(j)+e0(i0)*sa1(j)
            stet12(j) = sbet1(j)+sc1(j)+e0(i0)*sa2(j)
            stet13(j) = sbet1(j)+sc1(j)+e0(i0)*sa3(j)
            stet14(j) = sbet1(j)+sc1(j)+e0(i0)*sa4(j)
            stet21(j) = sbet2(j)+sc2(j)+e0(i0)*sa1(j)
            stet22(j) = sbet2(j)+sc2(j)+e0(i0)*sa2(j)
            stet23(j) = sbet2(j)+sc2(j)+e0(i0)*sa3(j)
            stet24(j) = sbet2(j)+sc2(j)+e0(i0)*sa4(j)
174       continue
!
!-------- Calcul du SN avec ou sans séisme
          if(ns .eq. 0) call rctres(st11, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st11, lieu, tresca)            
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instpmax
              instsn(2) = instqmin
              call rctres(sith1, snther)
              call rctres(sipr1, snpres)
              if (ns .eq. 0) call rctres(simec1, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec1, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st12, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st12, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instpmax
              instsn(2) = instqmin
              call rctres(sith1, snther)
              call rctres(sipr1, snpres)
              if (ns .eq. 0) call rctres(simec1, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec1, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st13, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st13, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instpmax
              instsn(2) = instqmin
              call rctres(sith1, snther)
              call rctres(sipr1, snpres)
              if (ns .eq. 0) call rctres(simec1, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec1, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st14, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st14, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instpmax
              instsn(2) = instqmin
              call rctres(sith1, snther)
              call rctres(sipr1, snpres)
              if (ns .eq. 0) call rctres(simec1, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec1, lieu, snmec)
          endif
!
          if(ns .eq. 0) call rctres(st21, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st21, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instqmax
              instsn(2) = instpmin
              call rctres(sith2, snther)
              call rctres(sipr2, snpres)
              if (ns .eq. 0) call rctres(simec2, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec2, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st22, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st22, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instqmax
              instsn(2) = instpmin
              call rctres(sith2, snther)
              call rctres(sipr2, snpres)
              if (ns .eq. 0) call rctres(simec2, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec2, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st23, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st23, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instqmax
              instsn(2) = instpmin
              call rctres(sith2, snther)
              call rctres(sipr2, snpres)
              if (ns .eq. 0) call rctres(simec2, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec2, lieu, snmec)
          endif
          if(ns .eq. 0) call rctres(st24, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', st24, lieu, tresca)  
          if(tresca .gt. sn) then
              sn = tresca
              instsn(1) = instqmax
              instsn(2) = instpmin
              call rctres(sith2, snther)
              call rctres(sipr2, snpres)
              if (ns .eq. 0) call rctres(simec2, snmec)
              if (ns .ne. 0) call rc32s0('SNSN', simec2, lieu, snmec)
          endif
!
!-------- Calcul du SN* avec ou sans séisme
          if(ns .eq. 0) call rctres(stet11, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet11, lieu, tresca)            
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instpmax
              instsn(4) = instqmin
          endif
          if(ns .eq. 0) call rctres(stet12, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet12, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instpmax
              instsn(4) = instqmin
          endif
          if(ns .eq. 0) call rctres(stet13, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet13, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instpmax
              instsn(4) = instqmin
          endif
          if(ns .eq. 0) call rctres(stet14, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet14, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instpmax
              instsn(4) = instqmin
          endif
!
          if(ns .eq. 0) call rctres(stet21, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet21, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instqmax
              instsn(4) = instpmin
          endif
          if(ns .eq. 0) call rctres(stet22, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet22, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instqmax
              instsn(4) = instpmin
          endif
          if(ns .eq. 0) call rctres(stet23, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet23, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instqmax
              instsn(4) = instpmin
          endif
          if(ns .eq. 0) call rctres(stet24, tresca)
          if(ns .ne. 0) call rc32s0('SNSN', stet24, lieu, tresca)  
          if(tresca .gt. snet) then
              snet = tresca
              instsn(3) = instqmax
              instsn(4) = instpmin
          endif
!
173     continue
      endif
    endif
!
!-----------------------------------------------------------
!   CALCUL DE LA PARTIE SP3 (QUI DEPEND DES INSTANTS DE SN)
!   POUR LE TERME DE RAPPEL AVEC LES INDICES DE CONTRAINTES
!-----------------------------------------------------------
!
    call jeveuo('&&RC3200.INDI', 'L', jvalin)
    k1 = zr(jvalin)
    c1 = zr(jvalin+1)
    k2 = zr(jvalin+2)
    c2 = zr(jvalin+3) 
    k3 = zr(jvalin+4)
    c3 = zr(jvalin+5)
!
    sp3 = (k3*c3-1)*snther+(k1*c1-1)*snpres+(k2*c2-1)*snmec
    spmeca3 = (k1*c1-1)*snpres+(k2*c2-1)*snmec
!
    call jedema()
!
end subroutine
