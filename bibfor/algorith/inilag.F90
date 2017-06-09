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

subroutine inilag(fmli, icar)
!    P. RICHARD     DATE 13/10/92
!-----------------------------------------------------------------------
!  BUT:      < INITIALISATION DES MATRICE LAGRANGE-LAGRANGE >
    implicit none
!
!
!-----------------------------------------------------------------------
!
! NOM----- / /:
!
! FMLI     /I/: FAMILLE DES MATRICE DE LIAISON
! ICAR     /I/: CARACTERISTIQUE DE LA LIAISON
!
!
!
!
!
!
!   PARAMETER REPRESENTANT LE NOMBRE MAX DE COMPOSANTE DE LA GRANDEUR
!   SOUS-JACENTE TRAITES
!
#include "jeveux.h"
!
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=24) :: fmli
    real(kind=8) :: moinun, zero5
    integer :: icar(4)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iblo, ldmat, nblig
!-----------------------------------------------------------------------
    data moinun /-1.0d+00/
    data zero5 /0.5d+00/
!-----------------------------------------------------------------------
!
    call jemarq()
    nblig=icar(1)
    iblo=icar(3)
!
!
    call jecroc(jexnum(fmli, iblo))
    call jeecra(jexnum(fmli, iblo), 'LONMAX', nblig*2)
    call jeveuo(jexnum(fmli, iblo), 'E', ldmat)
!
!-- LE ICAR(4) INDIQUE LE NUMERO DE LA SOUS STRUCTURE MAITRE
!-- DANS LA LIAISON. LA MULTIPLICATION DE LA MATRICE
!-- LAGRANGE / LAGRANGE PAR UN REEL NE CHANGE PAS LE RESULTAT
    do 10 i = 1, nblig
        zr(ldmat+i-1)=moinun*icar(4)
        zr(ldmat+nblig+i-1)=zero5*icar(4)
10  end do
!
!
!
    call jedema()
end subroutine
