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

subroutine mmmcrf(noma, ddepla, depplu, nfrot, vfrot)
!
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
    character(len=16) :: nfrot
    real(kind=8) :: vfrot
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - ALGORITHME - UTILITAIRE)
!
! CALCUL RESIDU DE FROTTEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DDEPLA : INCREMENT SOLUTION
! IN  DEPPLU : SOLUTION A L'INSTANT COURANT
! OUT NFROT  : LIEU OU LE CRITERE EST MAX
! OUT VFROT  : VALEUR DU CRITERE MAX
!
! ----------------------------------------------------------------------
!
    integer :: ncmp
    parameter    (ncmp=1)
    character(len=8) :: liscmp(ncmp)
!
    real(kind=8) :: vmax1, vmax2, vmaxi
    real(kind=8) :: crilbd
    character(len=8) :: nomnoe
    integer :: numno1, numno2, numnoe
!
    data liscmp  /'LAGS_C'/
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    vmax1 = 0.d0
    vmax2 = 0.d0
    crilbd = 0.d0
    nfrot = ' '
    vfrot = r8vide()
!
! --- TRI DES COMPOSANTES
!
    call cnomax(ddepla, ncmp, liscmp, vmax1, numno1)
    call cnomax(depplu, ncmp, liscmp, vmax2, numno2)
!
! --- CRITERE: VARIATION RELATIVE SUR LES LAGS_C
!
   if (vmax2 .gt. 1.d0) then
        crilbd = vmax1/vmax2
    elseif  (vmax2 .gt. 0.0) then
        crilbd = vmax1
    else
        crilbd = 0.d0
    endif

!
! --- INFORMATIONS SUR LE CRITERE
!
    numnoe = numno1
    vmaxi = crilbd
    if (numnoe .eq. 0) then
        nomnoe = ' '
    else
        call jenuno(jexnum(noma//'.NOMNOE', numnoe), nomnoe)
    endif
    nfrot = nomnoe//'        '
    vfrot = vmaxi
!
    call jedema()
end subroutine
