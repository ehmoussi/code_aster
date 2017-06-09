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

function xextr_uplet(n,id)
!
!-----------------------------------------------------------------------
! BUT : EXTRACTION DU P-UPLET CORRESPONDANT A UN IDENTIFIANT
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - N     : LE NOMBRE DE CHIFFRE (EN BASE 4)
!   - ID    : IDENTIFIANT DU DOMAINE
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
!-----------------------------------------------------------------------
    integer :: n, id
    integer :: xextr_uplet(n)
!-----------------------------------------------------------------------
    integer :: base_codage, idigi, res, p
    parameter (base_codage=4)
!-----------------------------------------------------------------------
!
    res=id
    do idigi=1,n
      p=int(res/base_codage**(n-idigi))
      res=res-p*base_codage**(n-idigi)
      xextr_uplet(idigi)=p-2
    enddo
!
end function
