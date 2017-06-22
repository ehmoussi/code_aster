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

subroutine te0245(option, nomte)
!
!
!
! --------------------------------------------------------------------------------------------------
!
!           CALCUL DES TERMES PROPRES A UNE STRUCTURE  (ELEMENT DE BARRE)
!
! --------------------------------------------------------------------------------------------------
!
!   IN
!       OPTION  : 'MASS_INER      : CALCUL DES CARACTERISTIQUES DE STRUCTURES
!       NOMTE   :
!        'MECA_BARRE'       : BARRE
!        'MECA_2D_BARRE'    : BARRE 2D
!
! --------------------------------------------------------------------------------------------------
!
implicit none
    character(len=*) :: option, nomte
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/lonele.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: lcastr, lmater, lsect, igeom
    integer :: codres(1)
    real(kind=8) :: rho(1), a, xl, r8b
    character(len=16) :: ch16, phenom
!
! --------------------------------------------------------------------------------------------------
!
     call jevech('PMATERC', 'L', lmater)
!
    call rccoma(zi(lmater), 'ELAS', 1, phenom, codres(1))
!
    r8b = 0.0d0
    if (phenom.eq.'ELAS' .or. phenom.eq.'ELAS_ISTR' .or. phenom.eq.'ELAS_ORTH') then
        call rcvalb('FPG1', 1, 1, '+', zi(lmater),' ', phenom, 0, ' ', [r8b],&
                    1, 'RHO', rho, codres, 1)
        if (rho(1) .le. r8prem()) then
            call utmess('F', 'ELEMENTS5_45')
        endif
    else
        call utmess('F', 'ELEMENTS_50')
    endif
!
!   recuperation des caracteristiques generales des sections
    call jevech('PCAGNBA', 'L', lsect)
    a = zr(lsect)
!
!   Longueur de l'élément
    if (nomte .eq. 'MECA_BARRE') then
        xl = lonele(igeom=igeom)
    else if (nomte.eq.'MECA_2D_BARRE') then
        xl = lonele(dime=2, igeom=igeom)
    else
        xl = 0.0d0
        ASSERT( ASTER_FALSE )
    endif
!
!   calcul des caracteristiques elementaires
    if (option .eq. 'MASS_INER') then
        call jevech('PMASSINE', 'E', lcastr)
!       masse et cdg de l'element
        if (nomte .eq. 'MECA_BARRE') then
            zr(lcastr) = rho(1) * a * xl
            zr(lcastr+1) =( zr(igeom+4) + zr(igeom+1) ) / 2.d0
            zr(lcastr+2) =( zr(igeom+5) + zr(igeom+2) ) / 2.d0
            zr(lcastr+3) =( zr(igeom+6) + zr(igeom+3) ) / 2.d0
        else if (nomte.eq.'MECA_2D_BARRE') then
            zr(lcastr) = rho(1) * a * xl
            zr(lcastr+1) =( zr(igeom+3) + zr(igeom+1) ) / 2.d0
            zr(lcastr+2) =( zr(igeom+4) + zr(igeom+2) ) / 2.d0
        endif
!       inertie de l'element
        zr(lcastr+4) = 0.d0
        zr(lcastr+5) = 0.d0
        zr(lcastr+6) = 0.d0
        zr(lcastr+7) = 0.d0
        zr(lcastr+8) = 0.d0
        zr(lcastr+9) = 0.d0
    else
        ch16 = option
        call utmess('F', 'ELEMENTS2_47', sk=ch16)
    endif
!
end subroutine
