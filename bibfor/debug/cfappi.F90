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

subroutine cfappi(noma, defico, nomnoe, typapp, posapp)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/cfnomm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    character(len=8) :: noma
    character(len=24) :: defico
    integer :: posapp
    integer :: typapp
    character(len=8) :: nomnoe
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
!
! SAUVEGARDE DES PARAMETRES APPARIEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DEFICO : SD DE DEFINITION DU CONTACT
! IN  TYPAPP : TYPE D'APPARIEMENT
!               -1  NON APPARIE CAR NOEUD EXCLU SANS_NOEUD
!               -2  NON APPARIE CAR NOEUD EXCLU PAR TOLE_APPA
!               -3  NON APPARIE CAR NOEUD EXCLU PAR TOLE_PROJ_EXT
! IN  NOMNOE : NOM DU NOEUD ESCLAVE
! IN  POSAPP : ENTITE APPARIEE
!
!
!
!
    character(len=8) :: nomapp, valk(2)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    valk(1) = nomnoe
    if (typapp .eq. -3) then
        call cfnomm(noma, defico, 'MAIL', posapp, nomapp)
        valk(2) = nomapp
        call utmess('I', 'CONTACTDEBG_11', nk=2, valk=valk)
    else if (typapp.eq.-2) then
        call utmess('I', 'CONTACTDEBG_12', sk=valk(1))
    else if (typapp.eq.-1) then
        call utmess('I', 'CONTACTDEBG_13', sk=valk(1))
    endif
!
    call jedema()
end subroutine
