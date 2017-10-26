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

subroutine rc32rs(lfat, lefat)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/getvtx.h"
#include "asterfort/tbajpa.h"
#include "asterc/r8vide.h"
#include "asterfort/tbajli.h"
#include "asterc/getfac.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/rcmcrt.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
#include "asterfort/rcvale.h"
#include "asterfort/getvid.h"

    aster_logical :: lfat, lefat

!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!     AFFICHAGE DES RESULTATS DANS LA TABLE DE SORTIE
!
!     ------------------------------------------------------------------
    character(len=4) :: lieu(2)
    character(len=8) :: nomres, k8b, mater
    character(len=16) :: concep, nomcmd, typtab, valek(5)
    integer :: ibid, n1, npar1, npar0, npar2, im, valei(7), nb, i, jval
    integer :: ns, jnom, jresu, jmax, jresus, k, icodre(1), iocc1, iocc2
    integer :: jcombi, jresucomb, jresucombs, npar3, jfact, npar4
    integer :: num1, num2, noccpris, ind1, ind2, n5, jfactenv
    complex(kind=8) :: c16b
    parameter    ( npar0 = 49 , npar1 = 16 , npar2 = 25, npar3 = 23, npar4 = 26 )
    character(len=16) :: nopar1(npar1), nopar0(npar0), nopar2(npar2)
    character(len=8) :: typar1(npar1), typar0(npar0)
    character(len=16) :: nopar3(npar3), nopar4(npar4)
    real(kind=8) :: valer(19), sigmoypres, symax, rbid, valres(1)
    real(kind=8) :: fuseism, fenint, fenglobal
!
!  ------------------------------------------------------------------
    data lieu   / 'ORIG' , 'EXTR' /
!
    data nopar0 / 'TYPE','SEISME', 'LIEU', 'NOM_SIT1',&
     &            'NUM_SIT1', 'NOCC_SIT1', 'GROUP_SIT1',  'PM', 'PB', 'PMPB',&
     &            'NOM_SIT2', 'NUM_SIT2', 'NOCC_SIT2', 'GROUP_SIT2', 'SN','INST_SN_1',&
     &            'INST_SN_2', 'SN*', 'INST_SN*_1', 'INST_SN*_2',&
     &            'SIG_PRES_MOY', 'SN_THER', 'CRIT_LINE', 'SP_THER', 'CRIT_PARAB',&
     &            'SP1(MECA)', 'INST_SALT_1', 'INST_SALT_2', 'SALT',&
     &            'FU_UNIT', 'NOCC_PRIS', 'FU_PARTIEL', 'FEN', 'FEN_INTEGRE',&
     &            'FUEN_PARTIEL', 'PM_MAX', 'PB_MAX', 'PMPB_MAX', 'SN_MAX',&
     &            'SN*_MAX', 'SIGM_M_PRES', 'SN_THER_MAX', 'CRIT_LINE_MAX',&
     &            'SP_THER_MAX', 'CRIT_PARA_MAX', 'SP_MAX', 'SALT_MAX', 'FU_TOTAL',&
     &            'FUEN_TOTAL' /
    data typar0 / 'K8', 'K8', 'K8', 'K16',&
     &             'I', 'I', 'I', 'R','R','R',&
     &             'K16', 'I', 'I', 'I', 'R', 'R',&
     &             'R', 'R','R','R',&
     &             'R', 'R', 'R', 'R', 'R',&
     &             'R', 'R', 'R', 'R',&
     &             'R', 'I', 'R', 'R', 'R', &
     &             'R', 'R', 'R', 'R', 'R',&
     &             'R', 'R' , 'R', 'R',&
     &             'R', 'R', 'R', 'R', 'R',&
     &             'R' /
!
    data nopar1 / 'TYPE', 'LIEU', 'PM_MAX', 'PB_MAX', 'PMPB_MAX', 'SN_MAX',&
     &            'SN*_MAX', 'SIGM_M_PRES', 'SN_THER_MAX', 'CRIT_LINE_MAX',&
     &            'SP_THER_MAX', 'CRIT_PARA_MAX', 'SP_MAX', 'SALT_MAX', 'FU_TOTAL',&
     &            'FUEN_TOTAL' /
    data typar1 / 'K8', 'K8', 'R', 'R', 'R', 'R',&
     &            'R', 'R', 'R', 'R',&
     &            'R', 'R', 'R', 'R', 'R',&
     &            'R' /
!
    data nopar2 / 'TYPE', 'SEISME', 'LIEU',&
     &            'NOM_SIT1', 'NUM_SIT1', 'GROUP_SIT1', 'PM', 'PB', 'PMPB',&
     &            'SN', 'INST_SN_1','INST_SN_2', 'SN*', 'INST_SN*_1',&
     &            'INST_SN*_2', 'SIG_PRES_MOY', 'SN_THER', 'CRIT_LINE',&
     &            'SP_THER', 'CRIT_PARAB', 'SP1(MECA)', 'INST_SALT_1', 'INST_SALT_2',&
     &            'SALT', 'FU_UNIT' /
!
    data nopar3 / 'TYPE', 'SEISME', 'LIEU',&
     &            'NOM_SIT1', 'NUM_SIT1', 'GROUP_SIT1',&
     &            'NOM_SIT2', 'NUM_SIT2', 'GROUP_SIT2', 'SN',&
     &            'INST_SN_1','INST_SN_2', 'SN*', 'INST_SN*_1',&
     &            'INST_SN*_2', 'SIG_PRES_MOY', 'SN_THER', 'CRIT_LINE',&
     &            'CRIT_PARAB', 'INST_SALT_1', 'INST_SALT_2',&
     &            'SALT', 'FU_UNIT' /
!
    data nopar4 / 'TYPE', 'SEISME', 'LIEU',&
     &            'NOM_SIT1', 'NUM_SIT1', 'NOCC_SIT1', 'GROUP_SIT1',&
     &            'NOM_SIT2', 'NUM_SIT2', 'NOCC_SIT2', 'GROUP_SIT2', 'SN',&
     &            'INST_SN_1','INST_SN_2', 'SN*', 'INST_SN*_1',&
     &            'INST_SN*_2', 'INST_SALT_1', 'INST_SALT_2',&
     &            'SALT', 'FU_UNIT', 'NOCC_PRIS', 'FU_PARTIEL', 'FEN',&
                  'FEN_INTEGRE', 'FUEN_PARTIEL' /
!
! DEB ------------------------------------------------------------------
!
    call jemarq()
!
    call getres(nomres, concep, nomcmd)
!
    call tbcrsd(nomres, 'G')
!
    ibid=0
    rbid = 0.d0
    c16b=(0.d0,0.d0)
    call getvtx(' ', 'TYPE_RESU', scal=typtab, nbret=n1)
    call getvid(' ', 'MATER', scal=mater, nbret=n1)
!
    if (typtab .eq. 'VALE_MAX') then
        call tbajpa(nomres, npar1, nopar1, typar1)
    else
        call tbajpa(nomres, npar0, nopar0, typar0)
    endif
!     ----------------------------------------------------------------
! --- AFFICHAGE DES MAXIMA DANS LA TABLE
!     ----------------------------------------------------------------
    valek(1) = 'MAXI'
    do 130 im = 1, 2
!
        valek(2) = lieu(im)
        call jeveuo('&&RC3200.MAX_RESU.'//lieu(im), 'L', jmax)
!
        do 131 k = 1,7
            valer(k) = zr(jmax-1+k)
131     continue
!
        sigmoypres = zr(jmax+5)
        if (sigmoypres .eq. r8vide() .or. abs(sigmoypres) .lt. 1e-10) then
            valer(7) = r8vide()
            valer(8) = r8vide()
            valer(10) = r8vide()
        else
            valer(7) = zr(jmax+6)
            symax = r8vide()
            call getvr8(' ', 'SY_MAX', scal=symax, nbret=n1)
            if(n1 .eq. 0) then
                call rcvale(mater, 'RCCM', 0, k8b, [rbid],&
                             1, 'SY_02   ', valres(1), icodre(1), 0)
                if (icodre(1) .eq. 0) then
                    symax = valres(1)
                else
                    call utmess('F', 'POSTRCCM_4')
                endif
            endif
            call rcmcrt(symax, sigmoypres, valer(8), valer(10))
        endif
!
        valer(9)=zr(jmax+7)
        do 132 k = 1,3
            valer(10+k) = zr(jmax-1+8+k)
132     continue
        valer(14) = zr(jmax+12)
        if(lefat) then
            call getvr8('ENVIRONNEMENT', 'FEN_INTEGRE', iocc=1, scal=fenint, nbret=n5)
            if(n5 .eq. 0 .or. abs(fenint) .lt. 1e-8) call utmess('F', 'POSTRCCM_54')
            fenglobal =0.d0
            if (abs(zr(jmax+10)) .gt. 1e-8) fenglobal = zr(jmax+12)/zr(jmax+10)
            if(fenglobal .gt. fenint) zr(jmax+12)=zr(jmax+12)/fenint
        endif
!
        call tbajli(nomres, npar1, nopar1, [ibid], valer,&
                    [c16b], valek, 0)
130 continue
!
    if (typtab .eq. 'VALE_MAX') goto 999
!
!     ----------------------------------------------------------------
! --- AFFICHAGE DES GRANDEURS PAR SITUATION
!     ----------------------------------------------------------------
    call getfac('SITUATION', nb)
    call getfac('SEISME', ns)
    call jeveuo('&&RC3200.SITU_INFOI', 'L', jval)
    call jeveuo('&&RC3200.SITU_NOM', 'L', jnom)
!
    valek(1) = 'SITU'
!
    do 201 i = 1, nb, 1
! --aller chercher le numéro de situation
      valei(1) = zi(jval+27*(i-1))
! aller chercher le numéro de groupe
      valei(2) = zi(jval+27*(i-1)+1)
! --aller chercher le nom de situation
      valek(4) = zk16(jnom+(i-1))
!
      do 202 im = 1, 2
        call jeveuo('&&RC3200.SITU_RESU.'//lieu(im), 'L', jresu)
        valek(3) = lieu(im)
        valek(2) = 'SANS'
!
        do 203 k = 1,11
            valer(k) = zr(jresu+121*(i-1)-1+k)
203     continue
!
        sigmoypres = zr(jresu+121*(i-1)+9)
        if (sigmoypres .eq. r8vide()) then
            valer(12) = r8vide()
            valer(14) = r8vide()
        else
            symax = r8vide()
            call getvr8(' ', 'SY_MAX', scal=symax, nbret=n1)
            if(n1 .eq. 0) then
                call rcvale(mater, 'RCCM', 0, k8b, [rbid],&
                             1, 'SY_02   ', valres(1), icodre(1), 0)
                if (icodre(1) .eq. 0) then
                    symax = valres(1)
                else
                    call utmess('F', 'POSTRCCM_4')
                endif
            endif
            call rcmcrt(symax, sigmoypres, valer(12), valer(14))
        endif
        valer(13) = zr(jresu+121*(i-1)+16)
!
        do 205 k = 1,5
            valer(k+14) = zr(jresu+121*(i-1)-1+k+11)
205     continue
!
        call tbajli(nomres, npar2, nopar2, valei, valer, [c16b], valek, 0)
!
        if (ns .eq. 0) goto 888
!
        call jeveuo('&&RC3200.SITUS_RESU.'//lieu(im), 'L', jresus)
        valek(2) = 'AVEC'
!
        do 204 k = 1,11
            valer(k) = zr(jresus+121*(i-1)-1+k)
204     continue
        valer(13) = zr(jresus+121*(i-1)+16)
!
        do 206 k = 1,5
            valer(k+14) = zr(jresus+121*(i-1)-1+k+11)
206     continue
!
        call tbajli(nomres, npar2, nopar2, valei, valer, [c16b], valek, 0)
!
888     continue
!
202   continue
201 continue
!
    if(.not. lfat) goto 999
!
!     ----------------------------------------------------------------
! --- AFFICHAGE DES GRANDEURS PAR COMBINAISON
!     ----------------------------------------------------------------
! cette combinaison est-elle possible ?
    call jeveuo('&&RC3200.COMBI', 'L', jcombi)
    valek(1) = 'COMB'
!
    do 40 iocc1 = 1, nb
      do 50 iocc2 = 1, nb
          if(zi(jcombi+nb*(iocc1-1)+iocc2-1) .ne. 0 .and. iocc1 .ne. iocc2) then
! ----------- aller chercher les numéros de situation
              valei(1) = zi(jval+27*(iocc1-1))
              valei(3) = zi(jval+27*(iocc2-1))
! ----------- aller chercher les numéros de groupe
              valei(2) = zi(jval+27*(iocc1-1)+1)
              valei(4) = zi(jval+27*(iocc2-1)+1)
!
              do 52 im = 1, 2
! ----------- aller chercher les noms de situation
                  valek(4) = zk16(jnom+(iocc1-1))
                  valek(5) = zk16(jnom+(iocc2-1))
                  call jeveuo('&&RC3200.COMB_RESU.'//lieu(im), 'L', jresucomb)
                  valek(3) = lieu(im)
                  valek(2) = 'SANS'
                  do 53 k = 1,6
                    valer(k) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+k)
53                continue
!
                  sigmoypres = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+7)
                  valer(7) = sigmoypres
                  if (sigmoypres .eq. r8vide()) then
                    valer(9) = r8vide()
                    valer(10) = r8vide()
                  else
                    symax = r8vide()
                    call getvr8(' ', 'SY_MAX', scal=symax, nbret=n1)
                    if(n1 .eq. 0) then
                      call rcvale(mater, 'RCCM', 0, k8b, [rbid],&
                                  1, 'SY_02   ', valres(1), icodre(1), 0)
                      if (icodre(1) .eq. 0) then
                        symax = valres(1)
                      else
                        call utmess('F', 'POSTRCCM_4')
                      endif
                    endif
                    call rcmcrt(symax, sigmoypres, valer(9), valer(10))
                  endif
!
                  valer(8) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)
                  do 54 k = 1,3
                    valer(10+k) = r8vide()
54                continue
                  valer(14) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
! --------------- on crée la ligne avec le transitoires fictifs uniquement
                  valek(4) = 'FICTIF1' 
                  valek(5) = 'FICTIF1'
!
                  do 207 k = 1,10
                      valer(k) = r8vide()
207               continue
                  valer(14) = r8vide()
                  valer(11) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)
                  valer(12) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)
                  valer(13) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)
!
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
!
                  valek(4) = 'FICTIF2' 
                  valek(5) = 'FICTIF2'
!
                  valer(11) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)
                  valer(12) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)
                  valer(13) = zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)
!
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
!
                  if (ns .eq. 0) goto 777
!
                  valek(2) = 'AVEC'
                  valek(4) = zk16(jnom+(iocc1-1))
                  valek(5) = zk16(jnom+(iocc2-1))
                  call jeveuo('&&RC3200.COMBS_RESU.'//lieu(im), 'L', jresucombs)
                  valek(3) = lieu(im)
                  do 153 k = 1,6
                    valer(k) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+k)
153                continue
!
                  sigmoypres = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+7)
                  valer(7) = sigmoypres
                  if (sigmoypres .eq. r8vide()) then
                    valer(9) = r8vide()
                    valer(10) = r8vide()
                  else
                    symax = r8vide()
                    call getvr8(' ', 'SY_MAX', scal=symax, nbret=n1)
                    if(n1 .eq. 0) then
                      call rcvale(mater, 'RCCM', 0, k8b, [rbid],&
                                  1, 'SY_02   ', valres(1), icodre(1), 0)
                      if (icodre(1) .eq. 0) then
                        symax = valres(1)
                      else
                        call utmess('F', 'POSTRCCM_4')
                      endif
                    endif
                    call rcmcrt(symax, sigmoypres, valer(9), valer(10))
                  endif
!
                  valer(8) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)
                  do 154 k = 1,3
                    valer(10+k) = r8vide()
154                continue
                  valer(14) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
! --------------- on crée la ligne avec le transitoires fictifs uniquement
                  valek(4) = 'FICTIF1' 
                  valek(5) = 'FICTIF1'
!
                  do 307 k = 1,10
                      valer(k) = r8vide()
307               continue
                  valer(14) = r8vide()
                  valer(11) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)
                  valer(12) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)
                  valer(13) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)
!
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
!
                  valek(4) = 'FICTIF2' 
                  valek(5) = 'FICTIF2'
!
                  valer(11) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)
                  valer(12) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)
                  valer(13) = zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)
!
                  call tbajli(nomres, npar3, nopar3, valei, valer, [c16b], valek, 0)
777               continue
!
52            continue
          endif
50    continue
40  continue
!
!     ----------------------------------------------------------------
! --- AFFICHAGE DES GRANDEURS QUI INTERVIENNENT DANS FU_TOTAL
! --- SN,'INST_SN_1','INST_SN_2', 'SN*', 'INST_SN*_1', 'INST_SN*_2',
! --- 'INST_SALT_1', 'INST_SALT_2','SALT', 'FU_UNIT', 'NOCC_PRIS', 'FU_PARTIEL' 
!     ----------------------------------------------------------------
!
    valek(1) = 'FACT'
!
    do 308 im = 1,2
      valek(3) = lieu(im)
      call jeveuo('&&RC3200.FACT.'//lieu(im), 'L', jfact)
      if (lefat) call jeveuo('&&RC3200.FACTENV.'//lieu(im), 'L', jfactenv)
!
      k=0
!
555   continue
!
      num1 = zi(jfact+6*k)
      num2 = zi(jfact+6*k+1)
!
      if (num1 .eq. 0) goto 666
      noccpris = zi(jfact+6*k+4)
!
      if(zi(jfact+6*k+5) .eq. 2) then
          valek(2) = 'AVEC'
          call jeveuo('&&RC3200.SITUS_RESU.'//lieu(im), 'L', ind1)
          call jeveuo('&&RC3200.COMBS_RESU.'//lieu(im), 'L', ind2)
          call jeveuo('&&RC3200.MAX_RESU.'//lieu(im), 'L', jmax)
          fuseism = zr(jmax+11)
      endif
      if(zi(jfact+6*k+5) .eq. 1) then
          valek(2) = 'SANS'
          call jeveuo('&&RC3200.SITU_RESU.'//lieu(im), 'L', ind1)
          call jeveuo('&&RC3200.COMB_RESU.'//lieu(im), 'L', ind2)
          fuseism = 0.d0
      endif
!
      valek(4) = zk16(jnom+(num1-1))
      valek(5) = zk16(jnom+(num2-1))
!
!---- numéro de situation
      valei(1) = zi(jval+27*(num1-1))
!---- nombre d'occurences restantes de la situation
      valei(2) = zi(jfact+6*k+2)
!---- groupe de la situation
      valei(3) = zi(jval+27*(num1-1)+1)
!
!---- numéro de situation
      valei(4) = zi(jval+27*(num2-1))
!---- nombre d'occurences restantes de la situation
      valei(5) = zi(jfact+6*k+3)
!---- groupe de la situation
      valei(6) = zi(jval+27*(num2-1)+1)
!
      valei(7) = noccpris
! 
!---- une situation seule a le plus grand fu unitaire
      if(num1 .eq. num2) then
          valer(1) = zr(ind1+121*(num1-1)+3)
          valer(2) = zr(ind1+121*(num1-1)+4)
          valer(3) = zr(ind1+121*(num1-1)+5)
          valer(4) = zr(ind1+121*(num1-1)+6)
          valer(5) = zr(ind1+121*(num1-1)+7)
          valer(6) = zr(ind1+121*(num1-1)+8)
          valer(7) = zr(ind1+121*(num1-1)+12)
          valer(8) = zr(ind1+121*(num1-1)+13)
          valer(9) = zr(ind1+121*(num1-1)+14)
          valer(10) = zr(ind1+121*(num1-1)+15)+fuseism
          valer(11) = valer(10)*noccpris
!
          if(lefat) then
              valer(12) = zr(jfactenv+2*k)
              valer(13) = fenint
              valer(14) = zr(jfactenv+2*k+1)
              if(fenglobal .gt. fenint) then
                valer(12) = zr(jfactenv+2*k)/fenint
                valer(14) = zr(jfactenv+2*k+1)/fenint
              endif
          else
              valer(12) = r8vide()
              valer(13) = r8vide()
              valer(14) = r8vide()
          endif
!
          call tbajli(nomres, npar4, nopar4, valei, valer, [c16b], valek, 0)
!
!---- une combinaison de situations a le plus grand fu unitaire
      else
          valer(1) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+1)
          valer(2) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+2)
          valer(3) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+3)
          valer(4) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+4)
          valer(5) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+5)
          valer(6) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+6)
          valer(7) = r8vide()
          valer(8) = r8vide()
          valer(9) = r8vide()
          valer(10)= zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+17)+fuseism
          valer(11)= valer(10)*noccpris
!
          if(lefat) then
              valer(12) = zr(jfactenv+2*k)
              valer(13) = fenint
              valer(14) = zr(jfactenv+2*k+1)
              if(fenglobal .gt. fenint) then
                valer(12) = zr(jfactenv+2*k)/fenint
                valer(14) = zr(jfactenv+2*k+1)/fenint
              endif
          else
              valer(12) = r8vide()
              valer(13) = r8vide()
              valer(14) = r8vide()
          endif
!
          call tbajli(nomres, npar4, nopar4, valei, valer, [c16b], valek, 0)
!
          valek(4) = 'FICTIF1'
          valek(5) = 'FICTIF1'
          do 103 i = 1,6
              valer(i) = r8vide()
103       continue
          valer(7) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+10)
          valer(8) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+11)
          valer(9) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+12)
!
          valer(10) = r8vide()
          valer(11) = r8vide()
          valer(12) = r8vide()
          valer(13) = r8vide()
          valer(14) = r8vide()
!
          call tbajli(nomres, npar4, nopar4, valei, valer, [c16b], valek, 0)
!
          valek(4) = 'FICTIF2'
          valek(5) = 'FICTIF2'
!
          valer(7) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+14)
          valer(8) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+15)
          valer(9) = zr(ind2+20*nb*(num1-1)+20*(num2-1)-1+16)
!
          call tbajli(nomres, npar4, nopar4, valei, valer, [c16b], valek, 0)
!
      endif
!
      k = k+1
      goto 555
!
666 continue
!
308 continue
!
999 continue
!
    call jedema()
!
end subroutine
