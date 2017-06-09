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

subroutine mnlbra(xups, xfpnla, ninc, ordman, nbpt,&
                  epsman, amax, xus)
    implicit none
!
!
!     MODE_NON_LINE CALCUL D'UNE BRANCHE
!     -    -   -                 ---
! ----------------------------------------------------------------------
!
! CALCUL UNE BRANCHE A L'AIDE DES COEFFICIENTS DE LA SERIE ENTIERE
! ----------------------------------------------------------------------
! IN   XUPS   : K14  : NOM DU VECTEUR QUI CONTIENT LES COEFFICIENTS
!                       DE LA SERIE ENTIERE DE LA VARIABLE
! IN   XFPNLA : K14  : NOM DU VECTEUR QUI CONTIENT LE SECOND MEMBRE
!                       SUPPLEMENTAIRE
! IN   NINC   : I    : NOMBRE D INCONNUES DU SYSTEME
! IN   ORDMAN : I    : ORDRE DE LA MAN
! IN   NBPT   : I    : DISCRETISATION DE LA BRANCHE
! IN   EPSMAN : R8   : PRECISION POUR L'ALGORITHME MAN
! OUT  AMAX   : R8   : LONGUEUR D'ARC DE LA BRANCHE
! OUT  XUS    : K14  : BRANCHE SOLUTION
! ----------------------------------------------------------------------
!
!
#include "jeveux.h"
! ----------------------------------------------------------------------
! --- DECLARATION DES ARGUMENTS DE LA ROUTINE
! ----------------------------------------------------------------------
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dnrm2.h"
#include "blas/dscal.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"

    character(len=14) :: xups, xfpnla, xus
    integer :: ninc, ordman, nbpt
    real(kind=8) :: epsman, amax
! ----------------------------------------------------------------------
! --- DECLARATION DES VARIABLES LOCALES
! ----------------------------------------------------------------------
    integer :: ius, iups, ifpnla, i, k
    real(kind=8) :: norme, a
!
    call jemarq()
! ----------------------------------------------------------------------
! --- RECUPERATION DU POINTEUR DE LA BRANCHE
! ----------------------------------------------------------------------
    call jeveuo(xus, 'E', ius)
    call dscal(ninc*nbpt, 0.d0, zr(ius), 1)
! ----------------------------------------------------------------------
! --- RECUPERATION DES COEFFICIENTS DE LA SERIE ENTIERE
! ----------------------------------------------------------------------
    call jeveuo(xups, 'L', iups)
! ----------------------------------------------------------------------
! --- RECUPERATION DU SECOND MEMBRE SUPPLEMENTAIRE
! ----------------------------------------------------------------------
    call jeveuo(xfpnla, 'L', ifpnla)
    norme = dnrm2(ninc-1,zr(ifpnla),1)
!
    if (norme .eq. 0.d0) then
        call utmess('F', 'MECANONLINE9_61')
    else
        amax = (epsman/norme)**dble(1.d0/(ordman+1))
    endif
! ----------------------------------------------------------------------
! --- ON RECOPIE LE POINT INITIAL
! ----------------------------------------------------------------------
    call dcopy(ninc, zr(iups), 1, zr(ius), 1)
! ----------------------------------------------------------------------
! --- ON CALCUL LA BRANCHE
! ----------------------------------------------------------------------
    do i = 2, nbpt
        a=amax*dble(i-1)/dble(nbpt-1)
        do k = 0, ordman
            call daxpy(ninc, a**dble(k), zr(iups+k*ninc), 1, zr(ius+(i-1)*ninc),&
                       1)
        end do
    end do
!
    call jedema()
!
end subroutine
