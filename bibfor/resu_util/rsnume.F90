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

subroutine rsnume(resu, nomsy, nu)
    implicit none
#include "jeveux.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsorac.h"
#include "asterfort/rs_getlast.h"
    character(len=*) :: nu, resu, nomsy
! ----------------------------------------------------------------------
! BUT : RECUPERER  UN NUME_DDL DANS UNE SD_RESULTAT
! ----------------------------------------------------------------------
! IN   K8   RESU    : NOM DE LA SD_RESULAT
! IN   K16  NOMSY   : NOM SYMBOLIQUE DU CHAM_NO : 'DEPL','TEMP', ...
! OUT  K14  NU      : NOM DU NUME_DDL  TROUVE (OU ' ' SINON)
! ----------------------------------------------------------------------
!
    integer :: nume_last, icode, iret, luti, iret2
    character(len=19) :: chamno, resu2
    character(len=24), pointer :: refe(:) => null()
!
! DEB ------------------------------------------------------------------
!
    nu=' '
    resu2=resu
    call jeexin(resu2//'.ORDR', iret)
    if (iret .gt. 0) then
        call jelira(resu2//'.ORDR', 'LONUTI', luti)
        if (luti .eq. 0) goto 999
        call rs_getlast(resu, nume_last)
!
        call rsexch(' ', resu, nomsy, nume_last, chamno,&
                    icode)
!
        if (icode .eq. 0) then
            call jeveuo(chamno//'.REFE', 'L', vk24=refe)
            call jeexin(refe(2)(1:19)//'.NEQU', iret2)
            if (iret2 .gt. 0) nu=refe(2)(1:14)
        endif
    endif
999 continue
!
end subroutine
