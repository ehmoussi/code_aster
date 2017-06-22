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

subroutine cfnoap(noma, defico, typapp, entapp, nomapp,&
                  type2)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfnomm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=24) :: defico
    character(len=8) :: noma
    integer :: entapp, typapp
    character(len=8) :: nomapp
    character(len=4) :: type2
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE DISCRETE - APPARIEMENT - UTILITAIRE)
!
! NOM DE L'ENTITE APPARIEE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE DEFINITION DU CONTACT
! IN  NOMA   : NOM DU MAILLAGE
! IN  TYPAPP : TYPE D'ENTITE APAPRIEE
! IN  ENTAPP : POSITION DE L'ENTITE APPARIE DANS SD_CONTACT
! OUT NOMAPP : NOM DE L'ENTITE APPARIEE
! OUT TYPE2  : TYPE D'APPARIEMENT
!                TYPE2  = ' NON'
!                TYPE2  = '/ND '
!                TYPE2  = '/EL '
!
!
!
!
    integer :: posnom, posmam
    character(len=8) :: nomnom, nommam
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! ----- NOM ET TYPE (MAILLE OU NOEUD) DU MAITRE
!
    if (typapp .lt. 0) then
        type2 = ' NON'
        nomapp = ' APPARIE'
    else if (typapp.eq.1) then
        posnom = entapp
        call cfnomm(noma, defico, 'NOEU', posnom, nomnom)
        type2 = '/ND '
        nomapp = nomnom
    else if (typapp.eq.2) then
        posmam = entapp
        call cfnomm(noma, defico, 'MAIL', posmam, nommam)
        type2 = '/EL '
        nomapp = nommam
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
