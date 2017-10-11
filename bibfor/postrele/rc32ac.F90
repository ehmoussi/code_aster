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

subroutine rc32ac(lfat, lefat)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/wkvect.h"
#include "asterfort/rc32pmb.h"
#include "asterfort/rc32sn.h"
#include "asterfort/rc32sp.h"
#include "asterfort/rc32sa.h"
#include "asterfort/rc32fact.h"
#include "asterc/r8vide.h"
#include "asterfort/getvtx.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"

    aster_logical :: lfat, lefat

!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!                           CALCUL DES GRANDEURS
!
!     ------------------------------------------------------------------
    integer :: nb, ndim, jresu, iocc, im, jmax, ns, jresus, n1, i, jcombi
    integer :: iocc1, iocc2, jresucomb, jresucombs, jvalin, nbsscyc, nbid
    integer :: kk
    real(kind=8) :: pm, pb, pmpb, pmmax, pbmax, pmpbmax, pms, pbs, pmpbs
    real(kind=8) :: snmax, sn, sns, instsn(4), instsns(4), snet, snets
    real(kind=8) :: snetmax, sigmoypres, siprmoymax, snthmax, snther, sbid
    real(kind=8) :: spmax, sp(2), sps(2), instsp(4), instsps(4), samax
    real(kind=8) :: spmeca(2), spmecas(2), salt(2), salts(2), kemeca
    real(kind=8) :: kether, fu(2), fus(2), snp, snq, snetp, snetq, sigmoypresp
    real(kind=8) :: sigmoypresq, sntherp, sntherq, snthers,snps, snqs, snetps
    real(kind=8) :: snetqs, sntherps, sntherqs, spp, spq, futot, spthmax
    real(kind=8) :: fuseism, spmecap, spmecaq, futotenv, ktsn, ktsp, sp3
    real(kind=8) :: spmeca3, sp3s, spmeca3s, spss2(2), keequi, saltss(2)
    real(kind=8) :: fuss(2), spss(1000), spssbid(1000), fusstot
    character(len=4) :: lieu(2)
    character(len=16) :: option, chap
    character(len=8) :: typeke, sscyc
    aster_logical :: ze200
!
! DEB ------------------------------------------------------------------
!
    call jemarq()
!
    lfat = .false.
    lefat = .false.
    lieu(1) = 'ORIG'
    lieu(2) = 'EXTR' 
!
!-- fait-on du calcul de pmpb, sn ou fatigue
    call getvtx(' ', 'OPTION', iocc=1, scal=option, nbret=n1)
!-- est on en ZE200
    ze200 = .false.
    call getvtx(' ', 'TYPE_RESU_MECA', iocc=1, scal=chap, nbret=n1)
    if(chap .eq. 'ZE200a' .or. chap .eq. 'ZE200b') ze200 = .true.
!-- est on en fatigue environnementale ?
    if(option .eq. 'EFAT') lefat = .true.
!-- combien de situations sont déclarées
    call getfac('SITUATION', nb)
!-- le séisme est-il pris en compte
    call getfac('SEISME', ns)
!
!-- les grandeurs sont calculées à l'origine et à l'extrémité du segment
    do 10 im = 1,2
! 
! ---------------------------------------------------------------------------------
! - POUR TOUT LE CALCUL (SITUATION, COMBINAISON, SEISME) STOCKAGE DES 9 GRANDEURS 
! - MAXIMALES A L'ORIGINE ET A L'EXTREMITE (&&RC3200.MAX_RESU)
! ---------------------------------------------------------------------------------
      pmmax = 0.d0
      pbmax = 0.d0
      pmpbmax = 0.d0
      snmax = 0.d0
      snetmax = 0.d0
      siprmoymax = 0.d0
      snthmax = 0.d0
      spmax = 0.d0
      samax = 0.d0
      spthmax = 0.d0
      fuseism = 0.d0
!
      call wkvect('&&RC3200.MAX_RESU.'//lieu(im), 'V V R', 13, jmax)
      do 20 i = 1, 13
          zr(jmax+i-1) = r8vide()
20    continue 
! ---------------------------------------------------------------------------------
! - POUR CHAQUE SITUATION, STOCKAGE DE 121 GRANDEURS A L'ORIGINE ET A L'EXTREMITE
! - (&&RC3200.SITU_RESU SANS SEISME et &&RC3200.SITUS_RESU AVEC SEISME)
! - PM, PB, PMPB, SN, INST_SN_1, INST_SN_2, SN*, INST_SN*_1, INST_SN*_2
! - SIGMOYPRES, SN_THER, SP1, INST_SALT1_1, INST_SALT1_2, SALT, FUEL, SP_THER, SPMECA, 
! - KE POUR EFAT, SPSS(100), NBSSCYC, FUSS
! ---------------------------------------------------------------------------------
      ndim = nb*121
      call wkvect('&&RC3200.SITU_RESU.'//lieu(im), 'V V R', ndim, jresu) 
      do 25 i = 1, ndim
          zr(jresu+i-1) = r8vide()
25    continue 
      if(ns .ne. 0) then
          call wkvect('&&RC3200.SITUS_RESU.'//lieu(im), 'V V R', ndim, jresus)
          do 26 i = 1, ndim
              zr(jresus+i-1) = r8vide()
26        continue 
      endif
!
      do 30 iocc = 1, nb , 1
!
!------ Calcul du PM, PB et PMPB
        if(option .eq. 'PM_PB') then
            pm = 0.d0
            pb = 0.d0
            pmpb = 0.d0
            pms = 0.d0
            pbs = 0.d0
            pmpbs = 0.d0
!
            call rc32pmb(lieu(im), iocc, 0, pm, pb, pmpb)
!
            zr(jresu+121*(iocc-1))=pm
            zr(jresu+121*(iocc-1)+1)=pb
            zr(jresu+121*(iocc-1)+2)=pmpb
            pmmax=max(pm, pmmax)
            pbmax=max(pb, pbmax)
            pmpbmax=max(pmpb, pmpbmax)
!
            if (ns .ne. 0) then
              call rc32pmb(lieu(im), iocc, ns, pms, pbs, pmpbs)
              zr(jresus+121*(iocc-1))=pms
              zr(jresus+121*(iocc-1)+1)=pbs
              zr(jresus+121*(iocc-1)+2)=pmpbs
              pmmax=max(pms, pmmax)
              pbmax=max(pbs, pbmax)
              pmpbmax=max(pmpbs, pmpbmax)
            endif
        endif
!
!------ Calcul du SN
        if(option .eq. 'SN' .or. option .eq. 'FATIGUE' .or. option .eq. 'EFAT') then
            call jeveuo('&&RC3200.INDI', 'L', jvalin)
            ktsn = zr(jvalin+9)
            ktsp = zr(jvalin+10) 
            sn = 0.d0
            sns = 0.d0
            snet = 0.d0
            snets = 0.d0
            snther = 0.d0
            sp3 = 0.d0
            spmeca3 = 0.d0
            sp3s = 0.d0
            spmeca3s = 0.d0
!
            call rc32sn(ze200, lieu(im), iocc, 0, 0, sn, instsn,&
                        snet, sigmoypres, snther, sp3, spmeca3)
            sn = sn*ktsn
            snet = snet*ktsn
            zr(jresu+121*(iocc-1)+3)=sn
            zr(jresu+121*(iocc-1)+4)=instsn(1)
            zr(jresu+121*(iocc-1)+5)=instsn(2)
            zr(jresu+121*(iocc-1)+6)=snet
            zr(jresu+121*(iocc-1)+7)=instsn(3)
            zr(jresu+121*(iocc-1)+8)=instsn(4)
            zr(jresu+121*(iocc-1)+9)=sigmoypres
            zr(jresu+121*(iocc-1)+10)=snther
            snmax=max(sn, snmax)
            snetmax=max(snet, snetmax)
            snthmax=max(snther, snthmax)
            if (sigmoypres .ne. r8vide()) siprmoymax=max(sigmoypres, siprmoymax)
!
            if (ns .ne. 0) then
              call rc32sn(ze200, lieu(im), iocc, 0, ns, sns, instsns,&
                          snets, sbid, sbid, sp3s, spmeca3s)
              sns = ktsn*sns
              snets = ktsn*snets
              zr(jresus+121*(iocc-1)+3)=sns
              zr(jresus+121*(iocc-1)+4)=instsns(1)
              zr(jresus+121*(iocc-1)+5)=instsns(2)
              zr(jresus+121*(iocc-1)+6)=snets
              zr(jresus+121*(iocc-1)+7)=instsns(3)
              zr(jresus+121*(iocc-1)+8)=instsns(4)
              zr(jresus+121*(iocc-1)+9)=sigmoypres
              zr(jresus+121*(iocc-1)+10)=snther
              snmax=max(sns, snmax)
              snetmax=max(snets, snetmax)
            endif
        endif
!
!------ Calcul du SP, du SALT et du FU de chaque situation seule
        if(option .eq. 'FATIGUE' .or. option .eq. 'EFAT') then
            lfat = .true.
            sp(1) = 0.d0
            salt(1) = 0.d0
            spmeca(1) = 0.d0
            sps(1) = 0.d0
            salts(1) = 0.d0
            spmecas(1) = 0.d0
            instsp(1)=-1.d0
            instsp(2)=-1.d0
            instsps(1)=-1.d0
            instsps(2)=-1.d0
!
            call rc32sp(ze200, lieu(im), iocc, 0, 0,&
                        sp, spmeca, instsp, nbsscyc, spss)
            sp(1) = ktsp*(sp(1)+sp3)
            spmeca(1) = ktsp*(spmeca(1)+spmeca3)
            zr(jresu+121*(iocc-1)+11)=sp(1)
            zr(jresu+121*(iocc-1)+12)=instsp(1)
            zr(jresu+121*(iocc-1)+13)=instsp(2)
            spmax=max(sp(1), spmax)
            call rc32sa('SITU', sn, sp, spmeca, kemeca, kether, salt, fu)
            zr(jresu+121*(iocc-1)+14)=salt(1)
            zr(jresu+121*(iocc-1)+15)=fu(1)
            zr(jresu+121*(iocc-1)+16)=max(0.d0, sp(1)-spmeca(1))
            zr(jresu+121*(iocc-1)+17)=spmeca(1)
!
            call getvtx(' ', 'TYPE_KE', scal=typeke, nbret=n1)
            if (typeke .eq. 'KE_MECA') then
                keequi = kemeca
            else
                keequi = (kemeca*spmeca(1)+kether*(sp(1)-spmeca(1)))/sp(1)
            endif
            zr(jresu+121*(iocc-1)+18) = keequi
!
!---------- Calcul du FU dû aux sous cycles
            call getvtx(' ', 'SOUS_CYCL', scal=sscyc, nbret=n1)
            if(sscyc .eq. 'OUI') then
              fusstot=0.d0
              do 31 kk = 1, nbsscyc
                  zr(jresu+121*(iocc-1)+19-1+kk) = spss(kk)
                  spss2(1) = keequi*spss(kk)
                  spss2(2) = 0.d0
                  call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                  fusstot = fusstot+fuss(1)
31            continue
              zr(jresu+121*(iocc-1)+119) = nbsscyc
              zr(jresu+121*(iocc-1)+120) = fusstot
              zr(jresu+121*(iocc-1)+15) = zr(jresu+121*(iocc-1)+15)+fusstot
            else
              zr(jresu+121*(iocc-1)+120) = 0.d0
            endif
!
            samax=max(salt(1), samax)
            spthmax = max(spthmax, zr(jresu+121*(iocc-1)+16))
!
!------ Calcul du SP, du SALT et du FU avec SEISME
            if (ns .ne. 0) then
              call rc32sp(ze200, lieu(im), iocc, 0, ns,&
                          sps, spmecas, instsps, nbid, spssbid)
              sps(1) = ktsp*(sps(1)+sp3s)
              spmecas(1) = ktsp*(spmecas(1)+spmeca3s)
              zr(jresus+121*(iocc-1)+11)=sps(1)
              zr(jresus+121*(iocc-1)+12)=instsps(1)
              zr(jresus+121*(iocc-1)+13)=instsps(2)
              spmax=max(spmax, sps(1))
              call rc32sa('SITU', sns, sps, spmecas, kemeca, kether, salts, fus)
              zr(jresus+121*(iocc-1)+14)=salts(1)
              zr(jresus+121*(iocc-1)+15)=fus(1)
              zr(jresus+121*(iocc-1)+16)=max(0.d0, sps(1)-spmecas(1))
              zr(jresus+121*(iocc-1)+17)=spmecas(1)
!
              if (typeke .eq. 'KE_MECA') then
                  keequi = kemeca
              else
                  keequi = (kemeca*spmecas(1)+kether*(sps(1)-spmecas(1)))/sps(1)
              endif
              zr(jresus+121*(iocc-1)+18) = keequi
!
!---------- Calcul du FU dû aux sous cycles avec SEISME
!
            if(sscyc .eq. 'OUI') then
              fusstot=0.d0
              do 32 kk = 1, nbsscyc
                  zr(jresus+121*(iocc-1)+19-1+kk) = spss(kk)
                  spss2(1) = keequi*spss(kk)
                  spss2(2) = 0.d0
                  call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                  fusstot = fusstot+fuss(1)
32            continue
              zr(jresus+121*(iocc-1)+119) = nbsscyc
              zr(jresus+121*(iocc-1)+120) = fusstot
              zr(jresus+121*(iocc-1)+15) = zr(jresu+121*(iocc-1)+15)+fusstot
            else
              zr(jresus+121*(iocc-1)+120) = 0.d0
            endif
!
              samax=max(samax, salts(1))
              spthmax = max(spthmax, zr(jresus+121*(iocc-1)+16))
!              
            endif
        endif
!
30    continue
!
! ---------------------------------------------------------------------------------
! - POUR CHAQUE COMBINAISON DE SITUATIONS POSSIBLE (MEME GROUPE ou SITUATION DE PASSAGE)
! - STOCKAGE DE 20 GRANDEURS A L'ORIGINE ET A L'EXTREMITE
! - (&&RC3200.SITU_RESU SANS SEISME et &&RC3200.SITUS_RESU AVEC SEISME)
! - SN, INST_SN_1, INST_SN_2, SN*, INST_SN*_1, INST_SN*_2
! - SIGMOYPRES, SN_THER, SP1,INST_SALT1_1, INST_SALT1_2, SALT1, SP2,INST_SALT2_1,
! - INST_SALT2_2, SALT2, FUEL, SP_THER, KE POUR EFAT, FUSS
! ---------------------------------------------------------------------------------
!
      ndim = nb*nb*20
      call wkvect('&&RC3200.COMB_RESU.'//lieu(im), 'V V R', ndim, jresucomb) 
      do 35 i = 1, ndim
          zr(jresucomb+i-1) = r8vide()
35    continue 
      if(ns .ne. 0) then
          call wkvect('&&RC3200.COMBS_RESU.'//lieu(im), 'V V R', ndim, jresucombs)
          do 36 i = 1, ndim
              zr(jresucombs+i-1) = r8vide()
36        continue 
      endif
!
!-- on consulte le tableau qui indique si la combinaison des deux situations P et Q
!-- est possible (elles sont dans le même groupe ou liées par une situation de passage)
      if(option .eq. 'FATIGUE' .or. option .eq. 'EFAT') then
        call jeveuo('&&RC3200.COMBI', 'L', jcombi)
        do 40 iocc1 = 1, nb
          do 50 iocc2 = 1, nb
              sn = 0.d0
              sns = 0.d0
              snet = 0.d0
              snets = 0.d0
              snther = 0.d0
              if(zi(jcombi+nb*(iocc1-1)+iocc2-1) .ne. 0) then
!
!---------------- Calcul de SN(P,Q), SN*(P,Q) et leurs instants sans séisme
                  call rc32sn(ze200, lieu(im), iocc1, iocc2, 0, sn, instsn,&
                              snet, sbid, snther, sp3, spmeca3) 
                  sn = ktsn*sn
                  snet = ktsn*snet
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sn
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=instsn(1)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=instsn(2)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snet
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=instsn(3)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=instsn(4)
                  sigmoypresp = zr(jresu+121*(iocc1-1)+9)
                  sigmoypresq = zr(jresu+121*(iocc2-1)+9)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+7)=max(sigmoypresp, sigmoypresq)
                  if (sigmoypresp .ne. r8vide()) siprmoymax=max(sigmoypresp, siprmoymax)
                  if (sigmoypresq .ne. r8vide()) siprmoymax=max(sigmoypresq, siprmoymax)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=snther
!---------------- On prend le max de SN(P,Q), SN(P,P) et SN(Q,Q)
                  snp = zr(jresu+121*(iocc1-1)+3)
                  snq = zr(jresu+121*(iocc2-1)+3)
                  sntherp = zr(jresu+121*(iocc1-1)+10)
                  sntherq = zr(jresu+121*(iocc2-1)+10)
                  if (snp .ge. sn) then
                      sn = snp
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sn
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=zr(jresu+121*(iocc1-1)+4)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=zr(jresu+121*(iocc1-1)+5)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=sntherp
                  endif
                  if (snq .ge. sn) then
                      sn = snq
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sn
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=zr(jresu+121*(iocc2-1)+4)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=zr(jresu+121*(iocc2-1)+5)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=sntherq
                  endif
                  snmax = max (snmax, sn)
                  snthmax=max(zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+8), snthmax)
!
                  snetp = zr(jresu+121*(iocc1-1)+6)
                  snetq = zr(jresu+121*(iocc2-1)+6)
                  if (snetp .ge. snet) then
                      snet = snetp
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snet
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=zr(jresu+121*(iocc1-1)+7)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=zr(jresu+121*(iocc1-1)+8)
                  endif
                  if (snetq .ge. snet) then
                      snet = snetq
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snet
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=zr(jresu+121*(iocc2-1)+7)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=zr(jresu+121*(iocc2-1)+8)
                  endif
                  snetmax=max(snet, snetmax)
!
!---------------- Calcul de SN, SN* et leurs instants avec séisme
                  if(ns .ne. 0) then
                      call rc32sn(ze200, lieu(im), iocc1, iocc2, ns, sns, instsns,&
                                  snets, sbid, snthers, sp3s, spmeca3s)
                      sns = ktsn*sns
                      snets = ktsn*snets    
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sns
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=instsns(1)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=instsns(2)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snets
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=instsns(3)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=instsns(4)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+7)=max(sigmoypresp, sigmoypresq)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=snthers
!
                      snps = zr(jresus+121*(iocc1-1)+3)
                      snqs = zr(jresus+121*(iocc2-1)+3)
                      sntherps = zr(jresus+121*(iocc1-1)+10)
                      sntherqs = zr(jresus+121*(iocc2-1)+10)
                      if (snps .ge. sns) then
                          sns = snps
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sns
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=zr(jresus+121*(iocc1-1)+4)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=zr(jresus+121*(iocc1-1)+5)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=sntherps
                      endif
                      if (snqs .ge. sns) then
                          sns = snqs
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+1)=sns
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+2)=zr(jresus+121*(iocc2-1)+4)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+3)=zr(jresus+121*(iocc2-1)+5)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+8)=sntherqs
                      endif
                      snmax = max (snmax, sns)
                      snthmax=max(zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+8), snthmax)
!
                      snetps = zr(jresus+121*(iocc1-1)+6)
                      snetqs = zr(jresus+121*(iocc2-1)+6)
                      if (snetps .ge. snets) then
                          snets = snetps
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snets
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=zr(jresus+121*(iocc1-1)+7)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=zr(jresus+121*(iocc1-1)+8)
                      endif
                      if (snetqs .ge. snets) then
                          snets = snetqs
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+4)=snets
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+5)=zr(jresus+121*(iocc2-1)+7)
                          zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+6)=zr(jresus+121*(iocc2-1)+8)
                      endif
                      snetmax=max(snets, snetmax)
                  endif
!
!---------------- Calcul de SP1(P,Q), SP2(P,Q) et leurs instants sans séisme
                  call rc32sp(ze200, lieu(im), iocc1, iocc2, 0,&
                              sp, spmeca, instsp, nbid, spssbid)
                  sp(1) = ktsp*(sp(1)+sp3)
                  spmeca(1) = ktsp*(spmeca(1)+spmeca3)
                  sp(2) = ktsp*(sp(2)+sp3)
                  spmeca(2) = ktsp*(spmeca(2)+spmeca3)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=sp(1)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=instsp(1)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=instsp(2)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=sp(2)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=instsp(3)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=instsp(4)
                  call rc32sa('COMB', sn, sp, spmeca, kemeca, kether, salt, fu)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salt(1)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salt(2)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fu(1)+fu(2)
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sp(1)-spmeca(1))
!---------------- On prend le max de SP(P,Q), SP(P,P) et SP(Q,Q)
                  spp = zr(jresu+121*(iocc1-1)+11)
                  spq = zr(jresu+121*(iocc2-1)+11)
                  spmecap = zr(jresu+121*(iocc1-1)+17)
                  spmecaq = zr(jresu+121*(iocc2-1)+17)
                  if (spp .ge. sp(1)) then
                      sp(1) = spp
                      sp(2) = spq
                      spmeca(1) = spmecap
                      spmeca(2) = spmecaq
                      call rc32sa('COMB', sn, sp, spmeca, kemeca, kether, salt, fu)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=spp
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=zr(jresu+121*(iocc1-1)+12)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=zr(jresu+121*(iocc1-1)+13)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salt(1)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=spq
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=zr(jresu+121*(iocc2-1)+12)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=zr(jresu+121*(iocc2-1)+13)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salt(2)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fu(1)+fu(2)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sp(1)-spmeca(1))
                  endif
                  if (spq .ge. sp(1)) then
                      sp(1) = spq
                      sp(2) = spp
                      spmeca(1) = spmecaq
                      spmeca(2) = spmecap
                      call rc32sa('COMB', sn, sp, spmeca, kemeca, kether, salt, fu)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=spq
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=zr(jresu+121*(iocc2-1)+12)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=zr(jresu+121*(iocc2-1)+13)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salt(1)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=spp
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=zr(jresu+121*(iocc1-1)+12)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=zr(jresu+121*(iocc1-1)+13)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salt(2)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fu(1)+fu(2)
                      zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sp(1)-spmeca(1))
                  endif
!
                  if (typeke .eq. 'KE_MECA') then
                      keequi = kemeca
                  else
                      keequi =(kemeca*spmeca(1)+kether*(sp(1)-spmeca(1)))/sp(1)
                  endif
                  zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+19) = keequi
!
!---------- Calcul du FU dû aux sous cycles
!
                  if(sscyc .eq. 'OUI') then
                    fusstot=0.d0
                    nbsscyc = int(zr(jresu+121*(iocc1-1)+119))
                    do 51 kk = 1, nbsscyc     
                        spss2(1) = keequi*zr(jresu+121*(iocc1-1)+19-1+kk)
                        spss2(2) = 0.d0
                        call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                        fusstot = fusstot+fuss(1)
51                  continue
                    nbsscyc = int(zr(jresu+121*(iocc2-1)+119))
                    do 52 kk = 1, nbsscyc     
                        spss2(1) = keequi*zr(jresu+121*(iocc2-1)+19-1+kk)
                        spss2(2) = 0.d0
                        call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                        fusstot = fusstot+fuss(1)
52                  continue
!
                    zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+20) = fusstot
                    zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=&
                    zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)+fusstot
                  else
                    zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+20) = 0.d0
                  endif
!
                  spmax = max(spmax, sp(1))
                  samax = max(samax, salt(1))
                  spthmax = max(spthmax, zr(jresucomb+20*nb*(iocc1-1)+20*(iocc2-1)-1+18))
!
!---------------- Calcul de SP1(P,Q), SP2(P,Q) et leurs instants avec séisme
                  if(ns .ne. 0) then
                    call rc32sp(ze200, lieu(im), iocc1, iocc2, ns,&
                                sps, spmecas, instsps, nbid, spssbid)
                    sps(1) = ktsp*(sps(1)+sp3s)
                    spmecas(1) = ktsp*(spmecas(1)+spmeca3s)
                    sps(2) = ktsp*(sps(2)+sp3s)
                    spmecas(2) = ktsp*(spmecas(2)+spmeca3s)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=sps(1)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=instsps(1)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=instsps(2)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=sps(2)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=instsps(3)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=instsps(4)
                    call rc32sa('COMB', sns, sps, spmecas, kemeca, kether, salts, fus)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salts(1)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salts(2)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fus(1)+fus(2)
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sps(1)-spmecas(1))
!---------------- On prend le max de SP(P,Q), SP(P,P) et SP(Q,Q)
                    spp = zr(jresus+121*(iocc1-1)+11)
                    spq = zr(jresus+121*(iocc2-1)+11)
                    spmecap = zr(jresus+121*(iocc1-1)+17)
                    spmecaq = zr(jresus+121*(iocc2-1)+17)
                    if (spp .ge. sps(1)) then
                      sps(1) = spp
                      sps(2) = spq
                      spmecas(1) = spmecap
                      spmecas(2) = spmecaq
                      call rc32sa('COMB', sns, sps, spmecas, kemeca, kether, salts, fus)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=spp
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=zr(jresus+121*(iocc1-1)+12)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=zr(jresus+121*(iocc1-1)+13)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salts(1)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=spq
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=zr(jresus+121*(iocc2-1)+12)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=zr(jresus+121*(iocc2-1)+13)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salts(2)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fus(1)+fus(2)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sps(1)-spmecas(1))
                    endif
                    if (spq .ge. sps(1)) then
                      sps(1) = spq
                      sps(2) = spp
                      spmecas(1) = spmecaq
                      spmecas(2) = spmecap
                      call rc32sa('COMB', sns, sps, spmecas, kemeca, kether, salts, fus)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+9)=spq
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+10)=zr(jresus+121*(iocc2-1)+12)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+11)=zr(jresus+121*(iocc2-1)+13)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+12)=salts(1)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+13)=spp
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+14)=zr(jresus+121*(iocc1-1)+12)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+15)=zr(jresus+121*(iocc1-1)+13)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+16)=salts(2)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=fus(1)+fus(2)
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+18)=max(0.d0, sps(1)-spmecas(1))
                    endif
!
                    if (typeke .eq. 'KE_MECA') then
                      keequi = kemeca
                    else
                      keequi =(kemeca*spmecas(1)+kether*(sps(1)-spmecas(1)))/sps(1)
                    endif
                    zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+19) = keequi
!
!---------- Calcul du FU dû aux sous cycles
!
                    if(sscyc .eq. 'OUI') then
                      fusstot=0.d0
                      nbsscyc = int(zr(jresu+121*(iocc1-1)+119))
                      do 53 kk = 1, nbsscyc     
                        spss2(1) = keequi*zr(jresu+121*(iocc1-1)+19-1+kk)
                        spss2(2) = 0.d0
                        call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                        fusstot = fusstot+fuss(1)
53                    continue
                      nbsscyc = int(zr(jresu+121*(iocc2-1)+119))
                      do 54 kk = 1, nbsscyc     
                        spss2(1) = keequi*zr(jresu+121*(iocc2-1)+19-1+kk)
                        spss2(2) = 0.d0
                        call rc32sa('SITU', 1e-12, spss2, spss2, kemeca, kether, saltss, fuss)
                        fusstot = fusstot+fuss(1)
54                    continue
!
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+20) = fusstot
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)=&
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+17)+fusstot
                    else
                      zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+20) = 0.d0
                    endif
!
                    spmax = max(spmax, sps(1))
                    samax = max(samax, salts(1))
                    spthmax = max(spthmax, zr(jresucombs+20*nb*(iocc1-1)+20*(iocc2-1)-1+18))
                  endif
!
              endif
50        continue
40      continue
!
! ---------------------------------------------------------------------------------
!                          CALCUL DU FACTEUR D'USAGE TOTAL
! ---------------------------------------------------------------------------------
        call rc32fact(ze200, nb, lieu(im), ns, fuseism, futot, lefat, futotenv)
      endif
! ---------------------------------------------------------------------------------
! --- on remplit le vecteur des quantités max (&&RC3200.MAX_RESU)
! ---------------------------------------------------------------------------------
      if(option .eq. 'PM_PB') then
        zr(jmax)=pmmax
        zr(jmax+1)=pbmax
        zr(jmax+2)=pmpbmax
      endif
      if(option .eq. 'SN' .or. option .eq. 'FATIGUE' .or. option .eq. 'EFAT') then
        zr(jmax+3)=snmax
        zr(jmax+4)=snetmax
        zr(jmax+5)=siprmoymax
        zr(jmax+6)=snthmax
      endif
      if(option .eq. 'FATIGUE' .or. option .eq. 'EFAT') then
        zr(jmax+7)=spthmax
        zr(jmax+8)=spmax
        zr(jmax+9)=samax
        zr(jmax+10)=futot
        zr(jmax+11)=fuseism
        zr(jmax+12)=futotenv
      endif
!
10  continue
!
    call jedema()
!
end subroutine
