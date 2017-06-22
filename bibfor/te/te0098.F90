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

subroutine te0098(option, nomte)
!
!
    implicit none
    character(len=16) :: nomte, option
!
! --------------------------------------------------------------------------------------------------
!
!    ELEMENT MECABL2
!       OPTION : 'RIGI_MECA'
!
!    ELEMENT MECA_BARRE
!       OPTION : 'RIGI_MECA_GE'
!
!    Dans tous les cas MAT = 0
!
! --------------------------------------------------------------------------------------------------
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    integer :: nno, nbval, imatuu, iadzi, iazk24
    aster_logical :: okte
    character(len=8) :: nomu
    character(len=16) :: concep,cmd
!
    character(len=16) :: vmessk(6)
!
! --------------------------------------------------------------------------------------------------
!   Récupération des arguments de l'opérateur
    call getres(nomu,concep,cmd)
!   Seulement valide pour
!           CALC_MATR_ELEM
!       et
!           MECABL2 et RIGI_MECA
!           ou
!           MECA_BARRE et RIGI_MECA_GE
!
    okte =  ((nomte.eq.'MECABL2')   .and.(option.eq.'RIGI_MECA'))  .or. &
            ((nomte.eq.'MECA_BARRE').and.(option.eq.'RIGI_MECA_GE'))
    okte = okte .and. cmd.eq.'CALC_MATR_ELEM'
    if ( .not. okte ) then
        vmessk(1) = cmd
        vmessk(2) = concep
        vmessk(3) = nomu
        vmessk(4) = nomte
        vmessk(5) = option
        call tecael(iadzi, iazk24)
        vmessk(6) = zk24(iazk24-1+3)(1:8)
        call utmess('F', 'CALCULEL_32', nk=6, valk=vmessk )
    endif
!
! --------------------------------------------------------------------------------------------------
    call elrefe_info(fami='RIGI',nno=nno)
!
!   Parametres en sortie
    call jevech('PMATUUR', 'E', imatuu)
    nbval = 3*nno*(3*nno+1)/2
    zr(imatuu:imatuu-1+nbval)= 0.0d0
end subroutine
