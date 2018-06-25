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

subroutine pmfasseinfo(tygrfi, nbfibr, nbcarm, cara, mxfiass, nbfiass, gxjxpou)
!
!
! --------------------------------------------------------------------------------------------------
!
!           Informations sur les PMF :  assemblage de groupes de fibres
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!   OUT
!       tygrfi      : type des groupes de fibres
!       nbfibr      : nombre total de fibre
!       nbcarm      : nombre de composantes dans la carte
!       cara        : caractéristiques des fibres
!       mxfiass     : nombre maximum de fibre par assemblage
!       nbfiass     : nombre de fibre par assemblage
!       gxjxpou     : constante de torsion par assemblage        
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
    integer, intent(in) :: nbfibr, tygrfi, nbcarm
    real(kind=8), intent(in) :: cara(nbcarm,nbfibr)
    integer, intent(out):: mxfiass
    integer, pointer :: nbfiass(:)
    real(kind=8), pointer :: gxjxpou(:)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii, numgr, nbassfi
!
! --------------------------------------------------------------------------------------------------
!
!
    if ( tygrfi .eq. 1 ) then
        mxfiass    = nbfibr
        ASSERT( size(nbfiass) .eq. 1 )
        nbfiass(1) = nbfibr
    else if ( tygrfi .eq. 2 ) then
        nbassfi = 0
        do ii = 1 , nbfibr
            numgr   = nint( cara(nbcarm,ii) )
            nbassfi = max( nbassfi , numgr )
        enddo
        ASSERT( nbassfi .ne. 0 )
!
        ASSERT( size(nbfiass) .eq. nbassfi )
        nbfiass(1:nbassfi) = 0
        do ii = 1 , nbfibr
            numgr = nint( cara(nbcarm,ii) )
            nbfiass(numgr) = nbfiass(numgr) + 1
            gxjxpou(numgr) = cara(nbcarm-1,ii)
        enddo
        mxfiass = 0
        do ii = 1 , nbassfi
            mxfiass = max( mxfiass , nbfiass(ii) )
        enddo
        ASSERT( mxfiass .ne. 0 )
    else
        call utmess('F', 'ELEMENTS2_40', si=tygrfi)
    endif
end subroutine
