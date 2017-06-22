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

subroutine cfreso(sdcont_solv, ldscon, nbliac)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rldlg3.h"
!
!
    character(len=24) :: sdcont_solv
    integer :: nbliac
    integer :: ldscon
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
!
! RESOLUTION DE [-A.C-1.AT].{MU} = {JEU(DEPTOT) - A.DDEPL0}
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  LDSCON : DESCRIPTEUR DE LA MATRICE DE CONTACT
! IN  ISTO   : INDICATEUR D'ARRET EN CAS DE PIVOT NUL
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
!
!
!
!
    integer :: ilifin, neqmax
    complex(kind=8) :: c16bid
    character(len=19) :: mu
    integer :: jmu
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    mu = sdcont_solv(1:14)//'.MU'
    call jeveuo(mu, 'E', jmu)
!
! --- INITIALISATIONS
!
    ilifin = nbliac
!
! --- ON NE RESOUD LE SYSTEME QUE DE 1 A ILIFIN
!
    neqmax = zi(ldscon+2)
    zi(ldscon+2) = ilifin
!
! --- RESOLUTION : [-A.C-1.AT].{MU} = {JEU(DEPTOT) - A.DDEPL0}
!
    c16bid = dcmplx(0.d0, 0.d0)
    call rldlg3('LDLT', ldscon, zr(jmu), [c16bid], 1)
    zi(ldscon+2) = neqmax
!
    call jedema()
!
end subroutine
