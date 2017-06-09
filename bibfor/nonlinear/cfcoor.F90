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

subroutine cfcoor(noma, defico, newgeo, posmam, ksi1,&
                  ksi2, coordp)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfcarm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mmcoor.h"
    character(len=8) :: noma
    character(len=24) :: defico
    character(len=19) :: newgeo
    integer :: posmam
    real(kind=8) :: ksi1
    real(kind=8) :: ksi2
    real(kind=8) :: coordp(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE DISCRETE - APPARIEMENT)
!
! CALCUL DES COORDONNEES DE LA PROJECTION DU NOEUD ESCLAVE
! SUR LA MAILLE MAITRE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  NEWGEO : COORDONNEES REACTUALISEES DES NOEUDS DU MAILLAGE
! IN  POSMAM : INDICE DE LA MAILLE MAITRE (DANS SD CONTACT)
! IN  KSI1   : COORDONNEE PARAMETRIQUE KSI DU PROJETE
! IN  KSI2   : COORDONNEE PARAMETRIQUE ETA DU PROJETE
! OUT COORDP : COORDONNEES DE LA PROJECTION DU NOEUD ESCLAVE
!
!
!
!
    integer :: nnomam, idim, ndim, nummam
    real(kind=8) :: coorma(27)
    character(len=8) :: alias, nommam
    character(len=4) :: typmai
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    do 10 idim = 1, 3
        coordp(idim) = 0.d0
10  end do
!
! --- CARACTERISTIQUES DE LA MAILLE MAITRE
!
    call cfcarm(noma, defico, newgeo, posmam, typmai,&
                nummam, alias, nommam, ndim, nnomam,&
                coorma)
    if (typmai .ne. 'MAIT') then
        ASSERT(.false.)
    endif
!
! --- COORDONNEES DU PROJETE
!
    call mmcoor(alias, nnomam, ndim, coorma, ksi1,&
                ksi2, coordp)
!
    call jedema()
end subroutine
