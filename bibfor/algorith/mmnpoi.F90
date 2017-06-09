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

subroutine mmnpoi(noma, nommae, numnoe, iptm, nompt)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
    character(len=8) :: noma
    character(len=8) :: nommae
    integer :: iptm, numnoe
    character(len=16) :: nompt
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - SD APPARIEMENT)
!
! NOM DU POINT DE CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NOMMAE : NOM DE LA MAILLE ESCLAVE
! IN  NUMNOE : NOM DU NOEUD
!               VAUT -1 SI CE LE POINT DE CONTACT N'EST PAS UN NOEUD
! IN  IPTM   : NUMERO DU PT D'INTEGRATION ( SI PAS INTEG. AUX NOEUDS)
! OUT NOMPT  : NOM DU POINT DE CONTACT
!
!
!
!
    character(len=4) :: for4
    character(len=8) :: nomnoe
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    write(for4,'(I4)') iptm
    if (numnoe .gt. 0) then
        call jenuno(jexnum(noma//'.NOMNOE', numnoe), nomnoe)
        nompt = 'NOEUD   '//nomnoe
    else
        write(for4,'(I4)') iptm
        nompt = nommae//'-PT '//for4
    endif
!
    call jedema()
!
end subroutine
