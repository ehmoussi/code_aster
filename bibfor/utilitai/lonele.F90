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

function lonele(dime, igeom)
!
!
! --------------------------------------------------------------------------------------------------
!
!                           CALCULE LA LONGEUR D'UN ELEMENT
!
!   Message <F> en cas de longueur <= r8prem
!
!   IN
!       dime    : dimension de l'espace
!
!   OUT
!       igeom   : adresse-1 du zr sur la géométrie  x1,y1 : < zr(igeom+1), zr(igeom+2) >
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    integer,optional,intent(in)  :: dime
    integer,optional,intent(out) :: igeom
    real(kind=8) :: lonele
!
! --------------------------------------------------------------------------------------------------
!
    integer             :: iadzi, iazk24, igeomloc, idimloc
    real(kind=8)        :: r8bid,xl
    character(len=8)    :: nomail
!
! --------------------------------------------------------------------------------------------------
!
    if ( present(dime) ) then
        idimloc = dime
    else
        idimloc = 3
    endif
!
    call jevech('PGEOMER', 'L', igeomloc)
    igeomloc = igeomloc - 1
!
    if (idimloc .eq. 3) then
        r8bid = ( zr(igeomloc+4) - zr(igeomloc+1) )**2
        r8bid = ( zr(igeomloc+5) - zr(igeomloc+2) )**2 + r8bid
        r8bid = ( zr(igeomloc+6) - zr(igeomloc+3) )**2 + r8bid
    else if (idimloc.eq.2) then
        r8bid = ( zr(igeomloc+3) - zr(igeomloc+1) )**2
        r8bid = ( zr(igeomloc+4) - zr(igeomloc+2) )**2 + r8bid
    else
!       no warning: ‘r8bid’ may be used uninitialized in this function
        r8bid = 0.0d0
        ASSERT( ASTER_FALSE )
    endif
    xl = sqrt( r8bid )
    if (xl .le. r8prem()) then
        call tecael(iadzi, iazk24)
        nomail = zk24(iazk24-1+3)(1:8)
        call utmess('F', 'ELEMENTS2_43', sk=nomail)
    endif
!
    lonele = xl
    if ( present(igeom) ) then
        igeom = igeomloc
    endif
end function
