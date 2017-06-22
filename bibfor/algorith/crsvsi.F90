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

subroutine crsvsi(solveu)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=19) :: solveu
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
!
! ACTIVATION DE STOP_SINGULIER = 'NON' EN CAS DE DECOUPE DU PAS DE TEMPS
!
! ----------------------------------------------------------------------
!
!
! IN  SOLVEU  : NOM SD SOLVEUR
!
! ----------------------------------------------------------------------
!
    integer :: nprec
    character(len=24) :: nomslv
    integer, pointer :: slvi(:) => null()
    character(len=24), pointer :: slvk(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call jeveuo(solveu//'.SLVK', 'L', vk24=slvk)
    call jeveuo(solveu//'.SLVI', 'E', vi=slvi)
    nomslv = slvk(1)
    nprec = slvi(1)
!
    if ((nomslv.eq.'MUMPS' ) .or. (nomslv.eq.'MULT_FRONT') .or. (nomslv.eq.'LDLT' )) then
        if (nprec .gt. 0) then
            slvi(3) = 2
        else
            call utmess('I', 'DISCRETISATION_43')
        endif
    elseif ( (nomslv.eq.'GCPC') .or. (nomslv.eq.'PETSC') ) then 
        slvi(8) = 2
    endif
!
    call jedema()
end subroutine
