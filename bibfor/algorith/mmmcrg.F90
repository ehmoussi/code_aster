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

subroutine mmmcrg(noma, ddepla, depplu, ngeom, vgeom)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
!
#include "asterc/r8vide.h"
#include "asterfort/cnomax.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
    character(len=8) :: noma
    character(len=19) :: depplu, ddepla
    character(len=16) :: ngeom
    real(kind=8) :: vgeom
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - ALGORITHME - UTILITAIRE)
!
! CALCUL DU CRITERE DE CONVERGENCE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DDEPLA : INCREMENT SOLUTION
! IN  DEPPLU : SOLUTION A L'INSTANT COURANT
! OUT NGEOM  : LIEU OU LE CRITERE EST MAX
! OUT VGEOM  : VALEUR DU CRITERE MAX
!
! ----------------------------------------------------------------------
!
    integer :: ncmp
    parameter    (ncmp=3)
    character(len=8) :: liscmp(ncmp)
!
    real(kind=8) :: vmax1, vmax2, vmaxi
    real(kind=8) :: cridep
    character(len=8) :: nomnoe
    integer :: numno1, numno2, numnoe
!
    data liscmp  /'DX','DY','DZ'/
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    vmax1 = 0.d0
    vmax2 = 0.d0
    cridep = 0.d0
    ngeom = ' '
    vgeom = r8vide()
!
! --- NORME MAX AVEC SELECTION DES COMPOSANTES
!
    call cnomax(ddepla, ncmp, liscmp, vmax1, numno1)
    call cnomax(depplu, ncmp, liscmp, vmax2, numno2)
!
! --- CALCUL DU CRITERE
!
    if (vmax2 .gt. 0.d0) then
        cridep = vmax1/vmax2
    else
        cridep = 1.d0
    endif
!
! --- EMPLACEMENT DU RESIDU MAX
!
    numnoe = numno1
    vmaxi = cridep
    if (numnoe .eq. 0) then
        nomnoe = ' '
    else
        call jenuno(jexnum(noma//'.NOMNOE', numnoe), nomnoe)
    endif
    ngeom = nomnoe//'        '
    vgeom = vmaxi
!
    call jedema()
end subroutine
