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

function cgverho(imate)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/lteatt.h"
#include "asterfort/tecach.h"
!
    integer :: imate
    aster_logical :: cgverho
!
!
!    operateur CALC_G : verification au niveau des te
!    ----------------
!
!    but : verifier que si les champs de : -       pesanteur
!                                          - et/ou rotation 
!                                          - et/ou pulsation
!          sont des donnees d'entrees du calcul elementaire, on dispose
!          bien d'une valeur de rho sur cet élément
!
!    in  : imate (adresse du materiau)
!    out : cgverho = .true. si tout est OK, .false. sinon
!
! ----------------------------------------------------------------------
!
    integer :: icodre, iret, codrho(1), ipesa, irota, ipuls
    aster_logical :: rhoabs
    real(kind=8) :: rhobid(1)
    character(len=16) :: phenom
    character(len=4) :: fami
!
! ----------------------------------------------------------------------
!
    call rccoma(zi(imate), 'ELAS', 1, phenom, icodre)
    if (lteatt('LXFEM','OUI')) then
        fami='XFEM'
    else
        fami='RIGI'
    endif
    call rcvalb(fami, 1, 1, '+', zi(imate),&
                ' ', phenom, 0, ' ', [0.d0],&
                1, 'RHO', rhobid(1), codrho(1), 0)
!
!   rhoabs -> .true. si rho est absent
    rhoabs = codrho(1).ne.0
!
    call tecach('ONO', 'PPESANR', 'L', iret, iad=ipesa)
    call tecach('ONO', 'PROTATR', 'L', iret, iad=irota)
    call tecach('ONO', 'PPULPRO', 'L', iret, iad=ipuls)
!
!   si le champ est present, et rho absent -> NOOK
    cgverho = .true.
    if ((ipesa.ne.0) .and. rhoabs) cgverho = .false.
    if ((irota.ne.0) .and. rhoabs) cgverho = .false.
    if ((ipuls.ne.0) .and. rhoabs) cgverho = .false.
!
end function
