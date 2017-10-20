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

subroutine aceamb(nomu, noma, lmax, nbocc)
    implicit none
#include "jeveux.h"
#include "asterc/r8rddg.h"
#include "asterc/r8dgrd.h"
#include "asterfort/alcart.h"
#include "asterfort/angvx.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/getvem.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/nocart.h"
#include "asterfort/normev.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: lmax, nbocc
    character(len=8) :: nomu, noma
!
!                          AFFE_CARA_ELEM
!
!     AFFECTATION DES CARACTERISTIQUES POUR LE MOT CLE "MEMBRANE"
!
! ----------------------------------------------------------------------
!  IN
!     NOMU   : NOM UTILISATEUR DE LA COMMANDE
!     NOMA   : NOM DU MAILLAGE
!     LMAX   : LONGUEUR
!     NBOCC  : NOMBRE D'OCCURENCES DU MOT CLE MEMBRANE
! ----------------------------------------------------------------------
    integer :: jdcc, jdvc, jdls, ioc, ng, nm, iret, jdls2
    integer :: n1, n2, n3, n4, n5, n6
    integer :: i,  nbmat, nbma, ncomp
    integer :: ima, nbno,  adrm, numa, jgrma, igr, nbmat0
    integer :: noe1, noe2, noe3, iarg
    real(kind=8) :: ep, tens
    real(kind=8) :: ang(2), angx(2)
    real(kind=8) :: axex(3), axey(3), axet2(3), xnorm, epsi, vecnor(3)
    real(kind=8) :: vn1n2(3), vn1n3(3)
    character(len=19) :: cartgr
    character(len=24) :: tmpngr, tmpvgr, nomagr, nomama, connex
    character(len=32) :: kjexn
    integer, pointer :: nume_ma(:) => null()
    real(kind=8), pointer :: vale(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbmat0)
    AS_ALLOCATE(vi=nume_ma, size=nbmat0)
    nomagr = noma//'.GROUPEMA'
    nomama = noma//'.NOMMAI'
    connex = noma//'.CONNEX'
!
! --- CONSTRUCTION DES CARTES ET ALLOCATION
    cartgr = nomu//'.CARCOQUE'
!     SI LA CARTE N'EXISTE PAS
    call exisd('CARTE', cartgr, iret)
    if (iret .eq. 0) then
        call alcart('G', cartgr, noma, 'CACOQU')
    endif
    tmpngr = cartgr//'.NCMP'
    tmpvgr = cartgr//'.VALV'
    call jeveuo(tmpngr, 'E', jdcc)
    call jeveuo(tmpvgr, 'E', jdvc)
    epsi = 1.0d-6
!
    call wkvect('&&TMPMEMBRANE', 'V V K24', lmax, jdls)
    call wkvect('&&TMPMEMBRANE2', 'V V K8', lmax, jdls2)
!
    zk8(jdcc  ) = 'EP'
    zk8(jdcc+1) = 'ALPHA'
    zk8(jdcc+2) = 'BETA'
    zk8(jdcc+3) = 'TENS'
!
! - NOMBRE DE COMPOSANTES
    ncomp = 4
! --- LECTURE DES VALEURS ET AFFECTATION DANS LA CARTE CARTPF
    do ioc = 1, nbocc
        ang(1) = 0.0d0
        ang(2) = 0.0d0
        tens   = 0.0d0
!
        call getvem(noma, 'GROUP_MA', 'MEMBRANE', 'GROUP_MA', ioc,&
                    iarg, lmax, zk24(jdls), ng)
        call getvem(noma, 'MAILLE', 'MEMBRANE', 'MAILLE', ioc,&
                    iarg, lmax, zk8(jdls2), nm)
!
        call getvr8('MEMBRANE', 'ANGL_REP_1', iocc=ioc, nbval=2, vect=ang,&
                    nbret=n1)
        call getvr8('MEMBRANE', 'ANGL_REP_2', iocc=ioc, nbval=2, vect=ang,&
                    nbret=n2)
        call getvr8('MEMBRANE', 'VECT_1', iocc=ioc, nbval=3, vect=axex,&
                    nbret=n3)
        call getvr8('MEMBRANE', 'VECT_2', iocc=ioc, nbval=3, vect=axey,&
                    nbret=n4)
        call getvr8('MEMBRANE', 'EPAIS', iocc=ioc, scal=ep, nbret=n5)
        call getvr8('MEMBRANE', 'N_INIT', iocc=ioc, scal=tens, nbret=n6)
!        EPAIS EST OBLIGATOIRE : ASSERT SI PAS LA
        if (n5 .ne. 0) then
            zr(jdvc) = ep
        else
            ASSERT(.false.)
        endif
!
!       SI ANGL_REP_1 OU VECT_1 SONT RENSEIGNES
        if ((n2 .eq. 0) .and. (n4 .eq. 0)) then
!           SI ANGL_REP_1 EST RENSEIGNE
            if (n3 .eq. 0) then
                zr(jdvc+1) = ang(1)
                zr(jdvc+2) = ang(2)
                zr(jdvc+3) = tens
            endif
!           SI VECT_1 EST RENSEIGNE
            if (n1 .eq. 0) then
                call normev(axex, xnorm)
                if (xnorm .lt. epsi) then
                    call utmess('F', 'MODELISA_10')
                endif
                call angvx(axex, angx(1), angx(2))
                zr(jdvc+1) = angx(1)*r8rddg()
                zr(jdvc+2) = angx(2)*r8rddg()
            endif
! ---       "GROUP_MA" = TOUTES LES MAILLES DE LA LISTE
            if (ng .gt. 0) then
                do i = 1, ng
                    call nocart(cartgr, 2, ncomp, groupma=zk24(jdls+i-1))
                end do
            endif
! ---       "MAILLE" = TOUTES LES MAILLES DE LA LISTE DE MAILLES
            if (nm .gt. 0) then
                call nocart(cartgr, 3, ncomp, mode='NOM', nma=nm,&
                            limano=zk8(jdls2))
            endif
!
!       SI ANGL_REP_2 OU VECT_2 SONT RENSEIGNES
        else
            if (ng .gt. 0) then
                nbmat = 0
                numa = -1
                do igr = 0, ng-1
                    kjexn = jexnom(nomagr,zk24(jdls+igr))
                    call jelira(kjexn, 'LONMAX', nbma)
                    call jeveuo(kjexn, 'L', jgrma)
                    nbmat = nbmat + nbma
                    do ima = 0, nbma-1
                        numa = numa + 1
                        nume_ma(numa+1) = zi(jgrma+ima)
                    end do
                end do
            else
                nbmat = nm
                do ima = 0, nm-1
                    kjexn = jexnom(nomama,zk8(jdls2+ima))
                    call jenonu(kjexn, nume_ma(ima+1))
                end do
            endif
!
!           SI VECT_2 EST RENSEIGNE
            if (n2 .eq. 0) then
                call normev(axey, xnorm)
                if (xnorm .lt. epsi) then
                    call utmess('F', 'MODELISA_10')
                endif
            endif
!
            do ima = 1, nbmat
!               CALCUL DE LA NORMALE : VECTEUR Z LOCAL
                numa = nume_ma(ima)
                call jelira(jexnum(connex, numa), 'LONMAX', nbno)
                call jeveuo(jexnum(connex, numa), 'L', adrm)
                noe1 = zi(adrm+1-1)
                noe2 = zi(adrm+2-1)
                noe3 = zi(adrm+3-1)
                do i = 1, 3
                    vn1n2(i) = vale(1+3*(noe2-1)+i-1) - vale(1+3*( noe1-1)+i-1 )
                    vn1n3(i) = vale(1+3*(noe3-1)+i-1) - vale(1+3*( noe1-1)+i-1 )
                end do
                vecnor(1) = vn1n2(2)*vn1n3(3) - vn1n2(3)*vn1n3(2)
                vecnor(2) = vn1n2(3)*vn1n3(1) - vn1n2(1)*vn1n3(3)
                vecnor(3) = vn1n2(1)*vn1n3(2) - vn1n2(2)*vn1n3(1)
                call normev(vecnor, xnorm)
                if (xnorm .lt. epsi) then
                    call utmess('F', 'MODELISA_11')
                endif
!
!               SI ANGL_REP_2 EST RENSEIGNE
                if (n4 .eq. 0) then
                    axey(1) = cos(ang(1)*r8dgrd())*cos(ang(2)*r8dgrd())
                    axey(2) = sin(ang(1)*r8dgrd())*cos(ang(2)*r8dgrd())
                    axey(3) = sin(ang(2)*r8dgrd())
                    call normev(axey, xnorm)
                    if (xnorm .lt. epsi) then
                        call utmess('F', 'MODELISA_10')
                    endif
                endif

!               CALCUL DU VECTEUR X LOCAL
                axex(1) = axey(2)*vecnor(3) - axey(3)*vecnor(2)
                axex(2) = axey(3)*vecnor(1) - axey(1)*vecnor(3)
                axex(3) = axey(1)*vecnor(2) - axey(2)*vecnor(1)
                call normev(axex, xnorm)
                if (xnorm .lt. epsi) then
                    call utmess('F', 'MODELISA_10')
                endif
                call angvx(axex, angx(1), angx(2))
                zr(jdvc+1) = angx(1) * r8rddg()
                zr(jdvc+2) = angx(2) * r8rddg()
                call nocart(cartgr, 3, ncomp, mode='NUM', nma=1,&
                            limanu=[numa])
            end do
        endif
    end do
!
    AS_DEALLOCATE(vi=nume_ma)
    call jedetr('&&TMPMEMBRANE')
    call jedetr('&&TMPMEMBRANE2')
    call jedetr(tmpngr)
    call jedetr(tmpvgr)
!
    call jedema()
end subroutine
