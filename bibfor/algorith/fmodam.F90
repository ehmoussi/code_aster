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

subroutine fmodam(neq, vite, valmod, basmod, force)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/r8inir.h"
    integer :: neq
    character(len=24) :: valmod, basmod
    real(kind=8) :: vite(neq), force(neq)
!
! ----------------------------------------------------------------------
!
! ROUTINE DYNA_NON_LINE (CALCUL)
!
! CALCUL DES FORCES D'AMORTISSEMENT MODALE
!
! ----------------------------------------------------------------------
!
!
! IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
! IN  VITE   : VECTEUR VITESSE
! IN  VALMOD : MODES PROPRES
! IN  BASMOD : BASE MODALE
! OUT FORCE  : FORCE D'AMORTISSEMENT MODALE
!
!
!
!
    integer :: imode, n1, nbmode
    real(kind=8) :: amor, masgen, puls, somme
    integer :: jvalmo, jbasmo
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call jelira(valmod, 'LONMAX', nbmode)
    nbmode = nbmode/3
    call jeveuo(valmod, 'L', jvalmo)
    call jeveuo(basmod, 'L', jbasmo)
!
    call r8inir(neq, 0.d0, force, 1)
!
    do 10 imode = 1, nbmode
        masgen = zr(jvalmo+3*(imode-1)+1-1)
        puls = zr(jvalmo+3*(imode-1)+2-1)
        amor = zr(jvalmo+3*(imode-1)+3-1)
        somme = 0.d0
        do 11 n1 = 1, neq
            somme = somme + zr(jbasmo+(imode-1)*neq+n1-1)*vite(n1)
11      continue
        do 12 n1 = 1, neq
            force(n1) = force(n1) + 2.d0*amor/masgen/puls**3 *zr( jbasmo+(imode-1)*neq+n1-1)*somm&
                        &e
12      continue
10  end do
!
    call jedema()
end subroutine
