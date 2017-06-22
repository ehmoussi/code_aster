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

subroutine aceapc(nomu, noma, lmax, nbocc)
!
!
! --------------------------------------------------------------------------------------------------
!
!     AFFE_CARA_ELEM
!     AFFECTATION DES CARACTERISTIQUES POUR LES ELEMENTS COUDES
!
! --------------------------------------------------------------------------------------------------
!
!   nomu   : nom utilisateur de la commande
!   noma   : nom du maillage
!   lmax   : longueur
!   nbocc  : nombre d'occurences du mot cle poutre
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=8) :: nomu, noma
    integer :: lmax, nbocc
!
#include "jeveux.h"
#include "asterfort/alcart.h"
#include "asterfort/getvem.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: iarg
    character(len=19) :: cartar
    character(len=24) :: tmpnar, tmpvar, mlggma, mlgnma, mlgcnx, mlgcoo
!
! --------------------------------------------------------------------------------------------------
!
    integer :: igm, ioc, ng, nm, nsec, ifly, isiy, iflz, isiz
    integer :: jdcc, jdco, jdls, jdvc
!
    integer :: nfl, nfly, nflz
    integer :: nsi, nsiy, nsiz
    real(kind=8) :: xfl, xfly, xflz
    real(kind=8) :: xsi, xsiy, xsiz
    character(len=19) :: sec
    logical :: okflex
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!   Y-a-t'il des poutres coudées
    okflex = .false.
    do ioc = 1, nbocc
        call getvtx('POUTRE', 'SECTION', iocc=ioc, scal=sec, nbret=nsec)
        if ( sec .ne. 'COUDE' ) cycle
!
        call getvr8('POUTRE', 'COEF_FLEX',    iocc=ioc, scal=xfl,  nbret=nfl)
        call getvr8('POUTRE', 'COEF_FLEX_XY', iocc=ioc, scal=xfly, nbret=nfly)
        call getvr8('POUTRE', 'COEF_FLEX_XZ', iocc=ioc, scal=xflz, nbret=nflz)
        call getvr8('POUTRE', 'INDI_SIGM',    iocc=ioc, scal=xsi,  nbret=nsi)
        call getvr8('POUTRE', 'INDI_SIGM_XY', iocc=ioc, scal=xsiy, nbret=nsiy)
        call getvr8('POUTRE', 'INDI_SIGM_XZ', iocc=ioc, scal=xsiz, nbret=nsiz)
!
        if ( nfly+nflz+nfl+nsiy+nsiz+nsi.gt.0 ) then
            okflex = .true.
            exit
        endif
    enddo
    if ( .not. okflex ) then
        goto 999
    endif
!
    mlggma = noma//'.GROUPEMA'
    mlgnma = noma//'.NOMMAI'
    mlgcnx = noma//'.CONNEX'
!
!   construction des cartes et allocation
    cartar = nomu//'.CARARCPO'
    tmpnar = cartar//'.NCMP'
    tmpvar = cartar//'.VALV'
    call alcart('G', cartar, noma, 'CAARPO')
    call jeveuo(tmpnar, 'E', jdcc)
    call jeveuo(tmpvar, 'E', jdvc)
    mlgcoo = noma//'.COORDO    .VALE'
    call jeveuo(mlgcoo, 'L', jdco)
!
    call wkvect('&&TMPPOUTRE_COURBE', 'V V K24', lmax, jdls)
!
    ifly=0; isiy=1; iflz=2; isiz=3
    zk8(jdcc+ifly) = 'C_FLEX_Y'
    zk8(jdcc+isiy) = 'I_SIGM_Y'
    zk8(jdcc+iflz) = 'C_FLEX_Z'
    zk8(jdcc+isiz) = 'I_SIGM_Z'
!
    do ioc = 1, nbocc
        okflex = .false.
        zr(jdvc+ifly) = 1.0
        zr(jdvc+iflz) = 1.0
        zr(jdvc+isiy) = 1.0
        zr(jdvc+isiz) = 1.0
!
        call getvem(noma, 'GROUP_MA', 'POUTRE', 'GROUP_MA', ioc, iarg, lmax, zk24(jdls), ng)
        call getvem(noma, 'MAILLE',   'POUTRE', 'MAILLE',   ioc, iarg, lmax, zk24(jdls), nm)
!
        call getvr8('POUTRE', 'COEF_FLEX',    iocc=ioc, scal=xfl,  nbret=nfl)
        call getvr8('POUTRE', 'COEF_FLEX_XY', iocc=ioc, scal=xfly, nbret=nfly)
        call getvr8('POUTRE', 'COEF_FLEX_XZ', iocc=ioc, scal=xflz, nbret=nflz)
!
        call getvr8('POUTRE', 'INDI_SIGM',    iocc=ioc, scal=xsi,  nbret=nsi)
        call getvr8('POUTRE', 'INDI_SIGM_XY', iocc=ioc, scal=xsiy, nbret=nsiy)
        call getvr8('POUTRE', 'INDI_SIGM_XZ', iocc=ioc, scal=xsiz, nbret=nsiz)
!
        if ( nfly.ne.0 ) then
            zr(jdvc+ifly) = xfly
            okflex = .true.
        endif
        if ( nflz.ne.0 ) then
            zr(jdvc+iflz) = xflz
            okflex = .true.
        endif
        if ( nfl.ne.0 ) then
            zr(jdvc+ifly) = xfl
            zr(jdvc+iflz) = xfl
            okflex = .true.
        endif
!
        if ( nsiy.ne.0 ) then
            zr(jdvc+isiy) = xsiy
            okflex = .true.
        endif
        if ( nsiz.ne.0 ) then
            zr(jdvc+isiz) = xsiz
            okflex = .true.
        endif
        if ( nsi.ne.0 ) then
            zr(jdvc+isiy) = xsi
            zr(jdvc+isiz) = xsi
            okflex = .true.
        endif
!
        if ( okflex ) then
!           Toutes les mailles de la liste de groupes mailles
            if (ng .gt. 0) then
                do igm = 1, ng
                    call nocart(cartar, 2, 4, groupma=zk24(jdls-1+igm))
                enddo
            endif
!           Toutes les mailles de la liste de mailles
            if (nm .gt. 0) then
                call nocart(cartar, 3, 4, mode='NOM', nma=nm, limano=zk24(jdls))
            endif
        endif
    enddo
!
    call jedetr('&&TMPPOUTRE_COURBE')
    call jedetr(tmpnar)
    call jedetr(tmpvar)
!
999 continue
    call jedema()
end subroutine
