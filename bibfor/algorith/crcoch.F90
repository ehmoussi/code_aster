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

subroutine crcoch()
    implicit none
!
!     COMMANDE:  CREA_RESU /CONV_CHAR
!     CREE UNE STRUCTURE DE DONNEE DE TYPE
!           "DYNA_TRANS"   "EVOL_CHAR"
!
! --- ------------------------------------------------------------------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterc/r8vide.h"
#include "asterfort/asasve.h"
#include "asterfort/ascova.h"
#include "asterfort/detrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/fondpl.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jerecu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/rcmfmc.h"
#include "asterfort/refdaj.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsmxno.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsorac.h"
#include "asterfort/rssepa.h"
#include "asterfort/utmess.h"
#include "asterfort/vechme.h"
#include "asterfort/vtcreb.h"
#include "asterfort/wkvect.h"
#include "blas/dcopy.h"
!
    integer :: ibid, ier, icompt, iret, numini, numfin
    integer :: n1, nis, nbinst, nbval, nume, j
    integer :: iad, jinst, jchout
    integer :: nbv(1), jrefe
    integer :: jcpt, nbr, ivmx, k, iocc, nboini
    integer :: nondp, nchar, tnum(1)
    integer :: nbordr1, nbordr2, jondp, jchar, jinf, jfon
    integer :: neq

!
    real(kind=8) :: rbid, tps, prec, partps(3)
    complex(kind=8) :: cbid
!
    character(len=1) :: typmat
    character(len=4) :: typabs
    character(len=8) :: k8b, resu, criter, matr
    character(len=8) :: materi, carele, blan8, noma
    character(len=16) :: type, oper
    character(len=19) :: nomch, listr8, list_load, resu19, profch
    character(len=24) :: linst, nsymb, typres, lcpt, londp
    character(len=24) :: matric(3)
    character(len=24) :: modele, mate, numedd, vecond
    character(len=24) :: veonde, vaonde, charge, infoch, fomult
    character(len=24) :: vechmp, vachmp, cnchmp
    real(kind=8), pointer :: val(:) => null()
!
    data linst,listr8,lcpt,londp/'&&CRCOCH_LINST','&&CRCOCH_LISR8',&
     &     '&&CPT_CRCOCH','&&CRCOCH_LONDP'/
! --- ------------------------------------------------------------------
    call jemarq()
!
    blan8 = ' '
    list_load = ' '
    nboini=10
    modele = ' '
    carele = ' '
    materi = ' '
    vecond = '&&CRCOCH_VECOND'
    veonde = '&&CRCOCH_VEONDE'
    vaonde = '&&CRCOCH_VAONDE'
    charge = '&&CRCOCH.INFCHA    .LCHA'
    infoch = '&&CRCOCH.INFCHA    .INFC'
    fomult = '&&CRCOCH.INFCHA    .FCHA'
    vechmp = '&&CRCOCH_VECHMP'
    vachmp = '&&CRCOCH_VACHMP'
    cnchmp = '&&CRCOCH_CNCHMP'
    iocc=1
!
    call getres(resu, type, oper)
    resu19=resu
    call getvtx(' ', 'TYPE_RESU', scal=typres, nbret=n1)
    
    call getvid('CONV_CHAR', 'CHARGE', iocc=iocc, nbval=0, nbret=n1)
    if (n1 .ne. 0) then
        nchar = -n1
        nondp = nchar
        call wkvect(londp, 'V V K8', nondp, jondp)
        call getvid('CONV_CHAR','CHARGE',iocc=iocc,nbval=nondp,&
                    vect=zk8(jondp),nbret=n1)
        call jeexin(zk8(jondp)//'.CHME.ONDPL.DESC',iret)
        if (iret .eq. 0) then 
            nondp = 0
            call jedetr(londp)
            call wkvect(charge, 'V V K24', nchar, jchar)
            call wkvect(infoch, 'V V I', 7+4*nchar, jinf)
            call wkvect(fomult, 'V V K24', nchar, jfon)
            call getvid('CONV_CHAR','CHARGE',iocc=iocc,nbval=nchar,&
                    vect=zk24(jchar),nbret=n1)
            zi(jinf)=nchar
            do j = 1, nchar
              zk24(jfon+j-1) = ' '
              zi(jinf+nchar+j) = 3
            end do
        endif
    endif
!
    call rscrsd('G', resu, typres, nboini)
!
    call jelira(resu//'           .ORDR', 'LONUTI', nbordr1)
!
    numini = -1
    icompt = -1
    profch = ' '
!
!
!        MOT CLE INST PRESENT :
    nis = 0
    nbinst = 0
    call getvr8('CONV_CHAR', 'INST', iocc=iocc, nbval=0, nbret=nis)
    if (nis .ne. 0) then
        typabs = 'INST'
        nbinst = -nis
    endif

    if (nis.ne.0) then
        call wkvect(lcpt, 'V V I', nbinst, jcpt)
        call wkvect(linst, 'V V R', nbinst, jinst)
        call getvr8('CONV_CHAR', typabs, iocc=iocc, nbval=nbinst, vect=zr(jinst),&
                    nbret=n1)
        call getvr8('CONV_CHAR', 'PRECISION', iocc=iocc, scal=prec, nbret=ibid)
        call getvtx('CONV_CHAR', 'CRITERE', iocc=iocc, scal=criter, nbret=ibid)
        call rsorac(resu,'LONUTI',0,rbid,k8b,cbid,rbid,k8b,nbv,1,ibid)
!
        ivmx = rsmxno(resu)
        do k = 1, nbinst
            if (nbv(1) .gt. 0) then
                call rsorac(resu, typabs, ibid, zr(jinst+k-1), k8b,&
                            cbid, prec, criter, tnum, 1, nbr)
                nume=tnum(1)
            else
                nbr = 0
            endif
            if (nbr .lt. 0) then
                call utmess('F', 'ALGORITH2_48')
            else if (nbr.eq.0) then
                zi(jcpt+k-1) = ivmx + 1
                ivmx = ivmx + 1
            else
                zi(jcpt+k-1) = nume
            endif
        end do
    else
!        MOT CLE LIST_INST PRESENT :
        n1 = 0
        call getvid('CONV_CHAR', 'LIST_INST', iocc=iocc, scal=listr8, nbret=n1)
        if (n1 .ne. 0) then
            typabs = 'INST'
        endif
!
        call getvr8('CONV_CHAR', 'PRECISION', iocc=iocc, scal=prec, nbret=ibid)
        call getvtx('CONV_CHAR', 'CRITERE', iocc=iocc, scal=criter, nbret=ibid)
        call jelira(listr8//'.VALE', 'LONMAX', nbval)
!
        nbinst = nbval
        numini = 1
        numfin = nbinst

        nbinst = min(nbinst,nbval)
!
        call wkvect(linst, 'V V R', nbinst, jinst)
        call jeveuo(listr8//'.VALE', 'L', vr=val)
        call rsorac(resu, 'LONUTI', 0, rbid, k8b,cbid, rbid, k8b, nbv,&
                    1, ibid)
        call wkvect(lcpt, 'V V I', nbinst, jcpt)
        ivmx = rsmxno(resu)
        j = 0
        do k = 1, nbval
            if (k .lt. numini) goto 40
            if (k .gt. numfin) goto 40
            j = j + 1
            zr(jinst-1+j) = val(k)
            if (nbv(1) .gt. 0) then
                call rsorac(resu, typabs, ibid, val(k), k8b, cbid, prec, criter, tnum,&
                            1, nbr)
                nume=tnum(1)
            else
                nbr = 0
            endif
            if (nbr .lt. 0) then
                call utmess('F', 'ALGORITH2_48')
            else if (nbr.eq.0) then
                zi(jcpt+j-1) = ivmx + 1
                ivmx = ivmx + 1
            else
                zi(jcpt+j-1) = nume
            endif
 40         continue
        end do
    endif

    numedd    = ' '
    call getvid('CONV_CHAR', 'MATR_RIGI', iocc=iocc, scal=matr, nbret=n1)
    if (n1 .eq. 1) then
        call dismoi('NOM_NUME_DDL', matr, 'MATR_ASSE', repk=numedd)
    endif

    call dismoi('NOM_MODELE', matr, 'MATR_ASSE', repk=modele)
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=noma)
    call dismoi('PROF_CHNO', matr, 'MATR_ASSE', repk=profch)
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
    call dismoi('CHAM_MATER', matr, 'MATR_ASSE', repk=materi)
    call rcmfmc(materi, mate)
    typmat='R'
    if ( typres(1:10)  .eq. 'DYNA_TRANS') then
       nsymb = 'DEPL'
    else
       nsymb = 'FORC_NODA'
    endif
    call rsagsd(resu, nbinst)
!
    do j = 1, nbinst
        if (j .ge. 2) call jemarq()
        call jerecu('V')
        icompt = zi(jcpt+j-1)
        tps = zr(jinst+j-1)
        partps(1) = tps
        partps(2) = r8vide()
        partps(3) = r8vide()
        call rsexch(' ', resu, nsymb, icompt, nomch, iret)
        if (iret .eq. 0) then
            call rsadpa(resu, 'L', 1, typabs, icompt,&
                        0, sjv=iad, styp=k8b)
        else if (iret .eq. 110) then
            call rsagsd(resu, 0)
            call rsexch(' ', resu, nsymb, icompt, nomch, iret)
        else if (iret .eq. 100) then
            call vtcreb(nomch, 'G', 'R', nume_ddlz = numedd)
        endif
        if (nondp .ne. 0) then
            call jeveuo(nomch//'.VALE', 'E', jchout)
            call fondpl(modele, mate, numedd, neq, zk8(jondp),&
                    nondp, vecond, veonde, vaonde, tps,&
                    zr(jchout))
        else
            call vechme('S', modele, charge, infoch, partps,&
                    carele, mate, vechmp)
            call asasve(vechmp, numedd, 'R', vachmp)
            call ascova('D', vachmp, fomult, 'INST', tps, 'R', nomch)
        endif
!
        call jeveuo(nomch//'.REFE', 'E', jrefe)
        zk24(jrefe) = noma
        zk24(jrefe+1) = profch

        call rsnoch(resu, nsymb, icompt)
        call rsadpa(resu, 'E', 1, typabs, icompt, 0, sjv=iad, styp=k8b)
        zr(iad) = tps
        call rssepa(resu,icompt,modele(1:8),materi,carele,list_load)
        if (j .ge. 2) call jedema()
!
    end do
    call jedetr(linst)
    call jedetr(lcpt)   
!
!     REMPLISSAGE DE .REFD POUR DYNA_*:
    call jelira(resu//'           .ORDR', 'LONUTI', nbordr2)
    if (nbordr2.gt.nbordr1) then
        if ( typres(1:10)  .eq. 'DYNA_TRANS') then
            matric(1) = matr
            matric(2) = ' '
            matric(3) = ' '
            call refdaj('F', resu19, (nbordr2-nbordr1), numedd, 'DYNAMIQUE',&
                            matric, ier)                  
        endif
    endif
!
    call jedema()
end subroutine
