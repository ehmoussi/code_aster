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

subroutine char_affe_neum(mesh, ndim, keywordfact, iocc, nb_carte,&
                          carte, nb_cmp)
!
    implicit none
!
#include "asterfort/getelem.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/vetyma.h"
#include "asterfort/getvid.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: ndim
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    integer, intent(in) :: nb_carte
    character(len=19), intent(in) :: carte(nb_carte)
    integer, intent(in) :: nb_cmp(nb_carte)
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Apply Neumann loads in <CARTE> with elements type check
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh         : name of mesh
! In  ndim         : space dimension
! In  keywordfact  : factor keyword to read elements
! In  iocc         : factor keyword index in AFFE_CHAR_MECA
! In  nb_carte     : number of <CARTE> for this Neumann load
! In  carte        : <CARTE> for this Neumann load
! In  nb_cmp       : number of components in the <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: load_type
    character(len=24) :: list_elem
    character(len=8) :: model
    integer, pointer :: p_list_elem(:) => null()
    integer :: nb_elem, nbmodel
    integer :: codret, i_carte
!
! --------------------------------------------------------------------------------------------------
!
    list_elem = '&&LIST_ELEM'
    load_type = keywordfact

    call getvid(' ', 'MODELE', scal=model, nbret=nbmodel)

!
! - Elements to apply
!
    if (nbmodel.eq.0) then
        call getelem(mesh, keywordfact, iocc, 'A', list_elem,nb_elem)
    else
        call getelem(mesh, keywordfact, iocc, 'A', list_elem,nb_elem,model=model)
    endif

    if (nb_elem .ne. 0) then
!
! ----- Check elements
!
        call jeveuo(list_elem, 'L', vi = p_list_elem)
        do i_carte = 1, nb_carte
            if (nb_cmp(i_carte) .ne. 0) then
                call vetyma(mesh, ndim, keywordfact, list_elem, nb_elem,&
                            codret)
            endif
        end do
!
! ----- Apply Neumann loads in <CARTE>
!
        do i_carte = 1, nb_carte
            if (nb_cmp(i_carte) .ne. 0) then
                call nocart(carte(i_carte), 3, nb_cmp(i_carte), mode='NUM', nma=nb_elem,&
                            limanu=p_list_elem)
            endif
        end do
!
    endif
!
    call jedetr(list_elem)
!
end subroutine
