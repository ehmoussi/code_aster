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

function lteatt(noattr, vattr, typel)
implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "asterf_types.h"
#include "asterfort/teattr.h"

    aster_logical :: lteatt
    character(len=*), intent(in) :: noattr
    character(len=*), intent(in) :: vattr
    character(len=*), intent(in), optional :: typel
!---------------------------------------------------------------------
! but : Tester si l'attribut noattr existe et a la valeur vattr
!---------------------------------------------------------------------
! Arguments:
! ----------
!    (o) in  noattr (k16) : nom de l'attribut
!    (o) in  vattr  (k16) : valeur de l'attribut
!    (f) in  typel  (k16) : Nom du type_element a interroger.
!                           Cet argument est inutile si la question concerne le
!                           type_element "courant".
!    (o) out lteatt (l)   : .true. : l'attribut existe pour le type_element
!                                    et sa valeur vaut vattr
!                           .false. : sinon

!-----------------------------------------------------------------------
!  Cette routine est utilisable partout dans le code.
!  Si elle est appelee en dehors de te0000 il faut fournir typel.
!  Sinon, typel est inutile.
!-----------------------------------------------------------------------
    character(len=16) :: vattr2
    integer :: iret
!----------------------------------------------------------------------
    if (present(typel)) then
        call teattr('C', noattr, vattr2, iret, typel=typel)
    else
        call teattr('C', noattr, vattr2, iret)
    endif
    if ((iret.eq.0) .and. (vattr.eq.vattr2)) then
        lteatt=.true.
    else
        lteatt=.false.
    endif
end function
